class MigrateDcBenefitApplication < Mongoid::Migration
  def self.up
    if Settings.site.key.to_s == "dc"
      @logger = Logger.new("#{Rails.root}/log/benefit_application_migration.log")
      migrate_plan_years_to_benefit_applications
    end
  end

  def self.down
  end

  def self.migrate_benefit_sponsor_catalog
    say_with_time("Time take to migrate benefit sponsor catalog") do
      BenefitMarkets::BenefitSponsorCatalog.delete_all

      @catalog_hash = {}
      BenefitSponsors::Site.all.where(site_key: :dc).first.benefit_market_for(:aca_shop).benefit_market_catalogs.each do |benefit_catalog|
        service_areas = ::BenefitMarkets::Locations::ServiceArea.where("active_year" => benefit_catalog.product_active_year).to_a
        (1..12).each do |month|
          effective_date = Date.new(benefit_catalog.product_active_year, month, 1)
          if Organization.where(:'employer_profile.plan_years.start_on'=> effective_date).present?
            catalog = BenefitMarkets::BenefitSponsorCatalogFactory.call(effective_date, benefit_catalog, service_areas)
            @catalog_hash[effective_date] = catalog.as_document
          end
        end
      end

      BenefitMarkets::BenefitSponsorCatalog.collection.insert_many(@catalog_hash.values)
      @catalog_hash = {}

      # shop
      BenefitMarkets::BenefitSponsorCatalog.collection.aggregate([{"$out" => "new_test_benefit_markets_benefit_sponsor_catalogs_copy"}]).each
      Organization.collection.aggregate([
        {"$match" => { 'hbx_id' => { "$nin" => ["100101", "118510", "100102"] },
                       "employer_profile.plan_years" => { "$exists" => true }}},
        {"$project" => {"employer_profile.plan_years" => 1}},
        {"$sort" => {"employer_profile.plan_years.start_on" => 1 }},
        {"$unwind" => "$employer_profile.plan_years"},
        {"$lookup" => {
            from: "new_test_benefit_markets_benefit_sponsor_catalogs_copy",
            localField: "employer_profile.plan_years.start_on",
            foreignField: "effective_date",
            as: "results"
        }},
        {"$unwind" => "$results"},
        {"$project" => {"results"=>1,"employer_profile.plan_years"=>1}},
        {"$project" => {_id: 0, probation_period_kinds:"$results.probation_period_kinds",
                        effective_date: "$results.effective_date",
                        effective_period: "$results.effective_period",
                        open_enrollment_period:  "$results.open_enrollment_period",
                        service_area_ids: "$results.service_area_ids",
                        product_packages: "$results.product_packages",
                        benefit_application_id: "$employer_profile.plan_years._id",
                        updated_at: "$results.updated_at"

        }},
        {"$out"=> "benefit_markets_benefit_sponsor_catalogs"}
      ],:allow_disk_use => true).each

      # congress
      Organization.where(:'hbx_id'.in=>["100101", "118510", "100102"]).each do |org|
        org.employer_profile.plan_years.each do |plan_year|
          benefit_catalog = BenefitSponsors::Site.all.where(site_key: :dc).first.benefit_market_for(:fehb).benefit_market_catalogs.detect{|catalog| catalog.product_active_year == plan_year.start_on.year}
          service_areas = ::BenefitMarkets::Locations::ServiceArea.where("active_year" => benefit_catalog.product_active_year).to_a
          catalog = BenefitMarkets::BenefitSponsorCatalogFactory.call(plan_year.start_on, benefit_catalog, service_areas)
          catalog.benefit_application_id = plan_year.id
          catalog.save
        end
      end

      BenefitMarkets::BenefitSponsorCatalog.create_indexes
      BenefitSponsors::BenefitSponsorships::BenefitSponsorship.create_indexes
      BenefitSponsors::BenefitApplications::BenefitApplication.create_indexes
    end
  end

  def self.migrate_plan_years_to_benefit_applications

    migrate_benefit_sponsor_catalog

    old_organizations = Organization.unscoped.exists(:"employer_profile.plan_years" => true)
    success = 0
    failed = 0
    total_plan_years = 0
    limit = 500

    say_with_time("Time take to migrate plan years") do

      old_organizations.batch_size(limit).no_timeout.each do |old_org|

        new_organization = new_org(old_org)
        @benefit_sponsorship = new_organization.active_benefit_sponsorship

        old_org.employer_profile.plan_years.asc(:start_on).each do |plan_year|
          total_plan_years += 1
          @benefit_package_map = {}
          begin
            @benefit_application = convert_plan_year_to_benefit_application(plan_year)
            if @benefit_application.valid?
              BenefitSponsors::BenefitApplications::BenefitApplication.skip_callback(:save, :after, :notify_on_save,  raise: false)
              BenefitSponsors::BenefitApplications::BenefitApplication.skip_callback(:create, :after, :renew_benefit_package_assignments,  raise: false)
              BenefitSponsors::BenefitApplications::BenefitApplication.skip_callback(:create, :after, :notify_on_create,  raise: false)
              BenefitSponsors::BenefitApplications::BenefitApplication.skip_callback(:create, :after, :set_expiration_date,  raise: false)
              @benefit_application.save!
              # @benefit_application.save!(validate: false) # TODO check with validation
              assign_employee_benefits
              print '.' unless Rails.env.test?
              success += 1
            else
              raise StandardError, @benefit_application.errors.to_s
            end
          rescue Exception => e
            failed += 1
            print 'F' unless Rails.env.test?
            @logger.error "Migration Failed for Organization HBX_ID: #{old_org.hbx_id},
            validation_errors:
            benefit_application - #{@benefit_application.try(:errors).try(:messages)},
            #{e.inspect}" unless Rails.env.test?
          end
        end
      end
      @logger.info " Total #{old_organizations.count} old organizations with plan years" unless Rails.env.test?
      @logger.info " Total #{total_plan_years} plan years" unless Rails.env.test?
      @logger.info " #{failed} plan years failed to migrate into new DB at this point." unless Rails.env.test?
      @logger.info " #{success} plan years successfully migrated into new DB at this point." unless Rails.env.test?
    end
  end

  # TODO: Verify updated by field on plan year updated_by_id
  def self.convert_plan_year_to_benefit_application(plan_year)

    benefit_applications =  @benefit_sponsorship.benefit_applications.where(id: plan_year.id)
    raise "Multile plan year found #{plan_year.employer_profile.organization.hbx_id}" if benefit_applications.count > 1
    raise "Plan year not found #{plan_year.employer_profile.organization.hbx_id}" if benefit_applications.count == 0

    @benefit_application = benefit_applications.first
    @benefit_application.pull_benefit_sponsorship_attributes

    benefit_sponsor_catalog = BenefitMarkets::BenefitSponsorCatalog.where(benefit_application_id: plan_year.id).first rescue nil
    raise "@benefit_sponsor_catalog not found #{plan_year.employer_profile.organization.hbx_id}" if benefit_sponsor_catalog.blank?

    @benefit_application.benefit_sponsor_catalog_id = benefit_sponsor_catalog.id

    plan_year.benefit_groups.unscoped.each do |benefit_group|
      params = sanitize_benefit_group_attrs(benefit_group)
      importer = BenefitSponsors::Importers::BenefitPackageImporter.call(@benefit_application, params)
      raise Standard, "Benefit Package creation failed" if importer.benefit_package.blank?
      @benefit_package_map[benefit_group.id] = importer.benefit_package.id
    end

    @benefit_application.aasm_state = set_benefit_application_state(plan_year)
    @benefit_application.predecessor_id = set_predecessor_application
    construct_workflow_state_transitions(plan_year)
    @benefit_application
  end

  def self.set_benefit_application_state(plan_year)
    return :imported if plan_year.is_conversion
    return @benefit_application.matching_state_for(plan_year) unless plan_year.enrolled?
    if plan_year.enrolled? && plan_year.binder_paid?
      :binder_paid
    else
      :enrollment_closed
    end
  end

  def self.set_predecessor_application
    benefit_applications =  @benefit_sponsorship.benefit_applications.select{ |app| app.start_on == @benefit_application.start_on.prev_day && [:active, :terminated, :expired, :imported].include?(app.aasm_state) }
    raise Standard, "More than One Predecessor application found, benefit_sponsorship: #{@benefit_sponsorship.id}" if benefit_applications.count > 1
    benefit_applications.present? ? benefit_applications.first.id : nil
  end

  def self.sanitize_benefit_group_attrs(benefit_group)
    attributes = benefit_group.attributes.slice(
        :title, :description, :created_at, :updated_at, :is_active, :effective_on_kind, :effective_on_offset,
        :plan_option_kind, :relationship_benefits, :dental_relationship_benefits
    )

    attributes[:is_default] = benefit_group.default
    attributes[:reference_plan_hios_id] = benefit_group.reference_plan.hios_id
    if benefit_group.is_offering_dental?
      attributes[:dental_reference_plan_hios_id] = benefit_group.dental_reference_plan.hios_id
      attributes[:dental_plan_option_kind] = benefit_group.dental_plan_option_kind
      attributes[:elected_dental_plan_hios_ids] = benefit_group.elected_dental_plans.map(&:hios_id)
      if attributes[:dental_plan_option_kind].blank? &&  # TODO fix prod data.
        attributes[:dental_plan_option_kind] = benefit_group.elected_dental_plans.pluck(:carrier_profile_id).uniq.count == 1 ? "single_carrier" : "single_plan"
      end
    end
    attributes.symbolize_keys
  end

  def self.construct_workflow_state_transitions(plan_year)
    plan_year.workflow_state_transitions.unscoped.asc(:transition_at).each do |wst|
      attributes = wst.attributes.except(:_id)
      attributes[:from_state] = @benefit_application.send(:plan_year_to_benefit_application_states_map)[wst.from_state.to_sym]
      attributes[:to_state] = @benefit_application.send(:plan_year_to_benefit_application_states_map)[wst.to_state.to_sym]
      attributes[:to_state] = :enrollment_closed if plan_year.enrolled? && attributes[:to_state] == :binder_paid && !plan_year.binder_paid?
      @benefit_application.workflow_state_transitions.build(attributes)
    end
  end

  def self.assign_employee_benefits
    @benefit_package_map.each do |benefit_group, benefit_package|
      census_employees = CensusEmployee.unscoped.where("benefit_group_assignments.benefit_group_id" => benefit_group)

      ce = census_employees.select{|ce| ce.benefit_sponsorship_id.blank?}
      ce.update_all(benefit_sponsorship_id: @benefit_sponsorship, benefit_sponsors_employer_profile_id: @benefit_sponsorship.profile.id) if ce.present?

      census_employees.each do |census_employee|
        census_employee.employee_role.update_attribute(:benefit_sponsors_employer_profile_id, @benefit_sponsorship.profile.id) if census_employee.employee_role && census_employee.employee_role.benefit_sponsors_employer_profile_id.blank?

        census_employee.benefit_group_assignments.unscoped.where(benefit_group_id: benefit_group).update_all(benefit_package_id:  benefit_package)
        CensusEmployee.skip_callback(:save, :after, :assign_default_benefit_package,  raise: false)
        CensusEmployee.skip_callback(:save, :after, :assign_benefit_packages,  raise: false)
        CensusEmployee.skip_callback(:save, :after, :construct_employee_role,  raise: false)
        CensusEmployee.skip_callback(:update, :after, :update_hbx_enrollment_effective_on_by_hired_on,  raise: false)

      end
    end
  end

  def self.new_org(old_org)
    BenefitSponsors::Organizations::Organization.where(hbx_id: old_org.hbx_id).first
  end
end