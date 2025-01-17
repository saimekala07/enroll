# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('lib', 'object_builders', 'product_builder')
require Rails.root.join('lib', 'tasks', 'hbx_import', 'qhp', 'parsers', 'plan_benefit_template_parser')

describe "qhp builder" do

  before :all do
    @service_area_id = "DCS001"
    bcbs_issuer_profile = FactoryBot.create(:benefit_sponsors_organizations_issuer_profile, issuer_hios_ids: ["42690"])

    FactoryBot.create(:benefit_markets_locations_service_area, issuer_provided_code: @service_area_id, active_year: 2019, issuer_profile_id: bcbs_issuer_profile.id, issuer_hios_id: "42690")
    FactoryBot.create(:benefit_markets_locations_service_area, issuer_provided_code: @service_area_id, active_year: 2019, issuer_profile_id: bcbs_issuer_profile.id, issuer_hios_id: "42690")
    @files = Dir.glob(File.join(Rails.root, 'spec/test_data/plan_data/plans/*.xml'))
  end

  context "new model having product without qhp" do
    let(:setting) { double }

    before :all do
      @product = FactoryBot.create(:benefit_markets_products_health_products_health_product, hios_id: "42690MA1234502-01", hios_base_id: "42690MA1234502", csr_variant_id: "01", application_period: Date.new(2019, 1, 1)..Date.new(2019, 12, 31))
    end

    before :each do
      allow(EnrollRegistry).to receive(:[]).with(:enroll_app).and_return(setting)
      allow(setting).to receive(:setting).with(:state_abbreviation).and_return(double(item: 'DC'))
      allow(setting).to receive(:setting).with(:geographic_rating_area_model).and_return(double(item: 'single'))
    end

    xit "should have 1 existing product" do
      expect(BenefitMarkets::Products::Product.all.count).to eq 1
    end

    it "should not have any qhp data" do
      expect(Products::Qhp.all.count).to eq 0
      expect(Products::Qhp.all.where(:"qhp_cost_share_variances.hios_plan_and_variant_id" => @product.hios_id).count).to eq 0
    end

    context "when new product is imported" do
      before(:all) do
        xml = Nokogiri::XML(File.open(@files.first))
        product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
        product = ProductBuilder.new({})
        product.add(product_parser.to_hash)
        product.run
      end

      xit "should load/update 2 aca_shop products from file" do
        expect(BenefitMarkets::Products::Product.aca_shop_market.count).to eq 2
      end

      it "should load/update 1 congressional_market products from file" do
        expect(BenefitMarkets::Products::Product.congressional_market.count).to eq 1
      end

      it "should load 2 QHP records from the file" do
        expect(Products::Qhp.all.count).to eq 2
      end

      it "should assign qhp_cost_share_variances from file to the existing products" do
        expect(Products::Qhp.all.where(:"qhp_cost_share_variances.hios_plan_and_variant_id" => @product.hios_id).count).to eq 1
      end

      xit "should have all qhp_cost_share_variances for all the products" do
        BenefitMarkets::Products::Product.all.each do |product|
          expect(Products::Qhp.all.where(:"qhp_cost_share_variances.hios_plan_and_variant_id" => product.hios_id).count).to eq 1
        end
      end

      it "should populate hsa_eligibility field on BenefitMarkets::Products" do
        expect(BenefitMarkets::Products::Product.count).to eq(3)
        expect(BenefitMarkets::Products::Product.all.select(&:hsa_eligibility).size).to eq(2)
      end
    end
  end

  describe '.network_data' do

    context 'when feature is enabled' do
      before(:each) do
        ::BenefitMarkets::Products::Product.delete_all
        allow(EnrollRegistry[:import_network_data].feature).to receive(:is_enabled).and_return(true)
        xml = Nokogiri::XML(File.open(@files.first))
        product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
        product = ProductBuilder.new({})
        product.add(product_parser.to_hash)
        product.run
      end

      it 'should import the network information' do
        expect(::BenefitMarkets::Products::Product.pluck(:dc_in_network, :nationwide)).to eq [[true, false], [true, false], [true, false]]
      end
    end

    context 'when feature is disabled' do
      before(:each) do
        ::BenefitMarkets::Products::Product.delete_all
        allow(EnrollRegistry[:import_network_data].feature).to receive(:is_enabled).and_return(false)
        xml = Nokogiri::XML(File.open(@files.first))
        product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
        product = ProductBuilder.new({})
        product.add(product_parser.to_hash)
        product.run
      end

      it 'should not import the network information' do
        expect(::BenefitMarkets::Products::Product.pluck(:dc_in_network, :nationwide)).to eq [[nil, nil], [nil, nil], [nil, nil]]
      end
    end

  end

  context "new model having product with qhp" do
    before :all do
      BenefitMarkets::Products::Product.all.delete
      Products::Qhp.all.delete

      @product2 = FactoryBot.create(:benefit_markets_products_health_products_health_product, hios_id: "42690MA1234502-01", hios_base_id: "42690MA1234502", csr_variant_id: "01", application_period: Date.new(2019, 1, 1)..Date.new(2019, 12, 31))
      products_qhp = FactoryBot.create(
        :products_qhp,
        issuer_id: "42690",
        standard_component_id: "42690MA1234502",
        plan_marketing_name: "Test Blue Premium",
        hios_product_id: "42690MA234", network_id: "MAN001",
        service_area_id: @service_area_id,
        active_year: 2019
      )
      products_qhp.qhp_cost_share_variances.create(hios_plan_and_variant_id: "42690MA1234502-01", plan_marketing_name: "Test Blue Premium", metal_level: "Platinum", csr_variation_type: "Standard Platinum On Exchange Plan", product_id: @product2.id)
    end

    it "should have 1 existing products" do
      expect(BenefitMarkets::Products::Product.all.count).to eq 1
    end

    it "should have 1 qhp record" do
      expect(Products::Qhp.all.count).to eq 1
      expect(Products::Qhp.all.where(:"qhp_cost_share_variances.hios_plan_and_variant_id" => @product2.hios_id).count).to eq 1
    end

    context "when new product is imported" do
      before(:all) do
        xml = Nokogiri::XML(File.open(@files.first))
        product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
        product = ProductBuilder.new({})
        product.add(product_parser.to_hash)
        product.run
      end

      it "should load/update 2 aca_shop products from file" do
        expect(BenefitMarkets::Products::Product.aca_shop_market.count).to eq 2
      end

      it "should load/update 1 congressional_market products from file" do
        expect(BenefitMarkets::Products::Product.congressional_market.count).to eq 1
      end

      it "should load 2 QHP records from the file" do
        expect(Products::Qhp.all.count).to eq 2
      end

      it "should only have one QHP record with hsa_eligibility as Yes from xml file" do
        expect(Products::Qhp.all.select {|p| p.hsa_eligibility == "Yes"}.size).to eq 1
      end

      it "should not create new qhp_cost_share_variances, but update from file to the existing one" do
        expect(Products::Qhp.all.where(:"qhp_cost_share_variances.hios_plan_and_variant_id" => @product2.hios_id).count).to eq 1
      end

      it "should have all qhp_cost_share_variances for all the products" do
        BenefitMarkets::Products::Product.all.each do |product|
          expect(Products::Qhp.all.where(:"qhp_cost_share_variances.hios_plan_and_variant_id" => product.hios_id).count).to eq 1
        end
      end

      context "products already present" do
        before(:all) do
          xml = Nokogiri::XML(File.open(@files.first))
          product_parser = Parser::PlanBenefitTemplateParser.parse(xml.root.canonicalize, :single => true)
          product = ProductBuilder.new({})
          product.add(product_parser.to_hash)
          product.run
        end

        it "should update 2 aca_shop product(s) from file" do
          expect(BenefitMarkets::Products::Product.aca_shop_market.count).to eq 2
        end

        it "should update the congressional_market product(s) if already present" do
          expect(BenefitMarkets::Products::Product.congressional_market.count).to eq 1
        end

      end

    end
  end

  after :all do
    DatabaseCleaner.clean
  end
end

def invoke_tasks(file)
  Rake::Task["xml:plans"].invoke(file)
end
