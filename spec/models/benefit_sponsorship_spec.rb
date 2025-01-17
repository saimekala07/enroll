# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BenefitSponsorship, :type => :model do
  context "when an HBX is instantiated as a benefit sponsor" do
    let(:hbx_profile)             { FactoryBot.create(:hbx_profile) }
    let(:service_markets)         { %w[individual] }

    let(:valid_params) do
      {
        hbx_profile:      hbx_profile,
        service_markets:  service_markets,
      }
    end

    context "with no arguments" do
      let(:params) {{}}

      it "should not save" do
        expect(BenefitSponsorship.create(**params).valid?).to be_falsey
      end
    end

    context "with no service market" do
      let(:params) {valid_params.except(:service_markets)}

      it "should fail validation" do
        expect(BenefitSponsorship.create(**params).errors[:service_markets].any?).to be_truthy
      end
    end

    context "with all required arguments" do
      let(:params)                  { valid_params }
      let(:benefit_sponsorship)     { BenefitSponsorship.new(**params) }
      let(:geographic_rating_area)  { FactoryBot.build(:geographic_rating_area) }

      it "should be valid" do
        expect(benefit_sponsorship.valid?).to be_truthy
      end

      it "should save" do
        expect(benefit_sponsorship.save).to be_truthy
      end

      context "and it is saved" do
        before { benefit_sponsorship.save }

        it "should be findable by ID" do
          expect(BenefitSponsorship.find(hbx_profile.benefit_sponsorship.id)).to eq benefit_sponsorship
        end

        context "and a benefit coverage period is defined with open enrollment start/end dates" do
          let(:benefit_coverage_period) { FactoryBot.build(:benefit_coverage_period, open_enrollment_start_on: TimeKeeper.date_of_record - 10.days, open_enrollment_end_on: TimeKeeper.date_of_record + 10.days) }

          context "when system date is during open enrollment period" do
            before do
              benefit_sponsorship.benefit_coverage_periods = benefit_coverage_period.to_a
            end

            it 'is_under_open_enrollment should return true' do
              expect(benefit_sponsorship.is_coverage_period_under_open_enrollment?).to be_truthy
            end
          end

          context "when system date is outside open enrollment period" do
            let(:benefit_coverage_period) { FactoryBot.build(:benefit_coverage_period, open_enrollment_start_on: TimeKeeper.date_of_record + 10.days, open_enrollment_end_on: TimeKeeper.date_of_record + 40.days) }

            before do
              benefit_sponsorship.benefit_coverage_periods = benefit_coverage_period.to_a
            end

            it 'is_under_open_enrollment should return false' do
              expect(benefit_sponsorship.is_coverage_period_under_open_enrollment?).to be_falsey
            end
          end
        end

        context "and benefit coverage periods are defined for the current and following years" do
          let(:benefit_coverage_period_previous_year) do
            FactoryBot.build(:benefit_coverage_period,
                             start_on: (TimeKeeper.date_of_record - 1.year).beginning_of_year,
                             end_on: (TimeKeeper.date_of_record - 1.year).end_of_year,
                             open_enrollment_start_on: ((TimeKeeper.date_of_record - 1.year).beginning_of_year - 2.months),
                             open_enrollment_end_on: ((TimeKeeper.date_of_record - 1.year).beginning_of_year + 1.month))
          end
          let(:benefit_coverage_period_this_year) do
            FactoryBot.build(:benefit_coverage_period,
                             start_on: TimeKeeper.date_of_record.beginning_of_year,
                             end_on: TimeKeeper.date_of_record.end_of_year,
                             open_enrollment_start_on: (TimeKeeper.date_of_record.beginning_of_year - 2.months),
                             open_enrollment_end_on: (TimeKeeper.date_of_record.beginning_of_year + 1.month))
          end
          let(:benefit_coverage_period_next_year) do
            FactoryBot.build(:benefit_coverage_period,
                             start_on: (TimeKeeper.date_of_record + 1.year).beginning_of_year,
                             end_on: (TimeKeeper.date_of_record + 1.year).end_of_year,
                             open_enrollment_start_on: ((TimeKeeper.date_of_record + 1.year).beginning_of_year - 2.months),
                             open_enrollment_end_on: ((TimeKeeper.date_of_record + 1.year).beginning_of_year + 1.month))
          end
          let(:enroll_date) {Date.today}

          before do
            TimeKeeper.set_date_of_record_unprotected!(enroll_date)
            benefit_sponsorship.benefit_coverage_periods = [benefit_coverage_period_previous_year, benefit_coverage_period_this_year, benefit_coverage_period_next_year]
          end

          after do
            TimeKeeper.set_date_of_record_unprotected!(Date.today)
          end

          it 'should return this year as the current benefit coverage period' do
            expect(benefit_sponsorship.current_benefit_coverage_period).to eq(benefit_coverage_period_this_year)
          end

          it 'should return next year as the renewal benefit coverage period' do
            expect(benefit_sponsorship.renewal_benefit_coverage_period).to eq(benefit_coverage_period_next_year)
          end

          it 'should return previous year as the previous benefit coverage period' do
            expect(benefit_sponsorship.previous_benefit_coverage_period).to eq(benefit_coverage_period_previous_year)
          end

          context "before next year open enrollment" do
            context "and today's date is before the deadline for first-of-next-month enrollment" do
              let(:enroll_date)              { Date.new(2015,9,15).end_of_month + HbxProfile::IndividualEnrollmentDueDayOfMonth.days }
              let(:first_of_next_month_date) { enroll_date.end_of_month + 1.day }

              it 'should return first-of-next-month as the earliest effective date' do
                expect(benefit_sponsorship.earliest_effective_date).to eq first_of_next_month_date
              end
            end

            context "and today's date is after the deadline for first-of-next-month enrollment" do
              let(:enroll_date)                   { Date.new(2015,9,15).end_of_month + HbxProfile::IndividualEnrollmentDueDayOfMonth.days + 1 }
              let(:first_of_following_month_date) { enroll_date.next_month.end_of_month + 1.day }

              it 'should return first-of-following-month as the earliest effective date' do
                expect(benefit_sponsorship.earliest_effective_date).to eq first_of_following_month_date
              end
            end
          end

          context "during open enrollment renewal" do
            context "and today's date is before the deadline for first-of-next-month enrollment" do
              let(:enroll_date)              { Date.new(2015,11,15) }
              let(:first_of_next_month_date) { enroll_date.end_of_month + 1.day }
              let(:start_on) { benefit_coverage_period_next_year.start_on }

              it 'should return first-of-next-month as the earliest effective date' do
                expect(benefit_sponsorship.earliest_effective_date).to eq start_on
              end
            end

            context "and today's date is after the deadline for first-of-next-month enrollment" do
              let(:enroll_date)                   { Date.new(2015,11,16) }
              let(:first_of_following_month_date) { enroll_date.next_month.end_of_month + 1.day }
              let(:start_on) { benefit_coverage_period_next_year.start_on }

              it 'should return first-of-following-month as the earliest effective date' do
                expect(benefit_sponsorship.earliest_effective_date).to eq start_on
              end
            end
          end
        end
      end
    end
  end

  describe '.create_prospective_year_benefit_coverage_period' do
    let(:hbx_profile) { FactoryBot.create(:hbx_profile) }

    let(:benefit_sponsorship) { FactoryBot.create(:benefit_sponsorship, hbx_profile: hbx_profile) }
    let(:system_date) { TimeKeeper.date_of_record }
    let(:current_year) { system_date.year }
    let(:prospective_year) { current_year.next }
    let(:benefit_coverage_period) do
      FactoryBot.create(:benefit_coverage_period, benefit_sponsorship: benefit_sponsorship, coverage_year: current_year)
    end
    let(:renewal_benefit_coverage_period) do
      FactoryBot.create(:benefit_coverage_period, benefit_sponsorship: benefit_sponsorship, coverage_year: prospective_year)
    end

    before do
      benefit_coverage_period
      renewal_benefit_coverage_period
      allow(FinancialAssistanceRegistry).to receive(:feature_enabled?).with(:create_bcp_on_date_change).and_return(feature_enabled)

      allow(
        FinancialAssistanceRegistry[:create_bcp_on_date_change].settings(:bcp_creation_month)
      ).to receive(:item).and_return(system_date.month)

      allow(
        FinancialAssistanceRegistry[:create_bcp_on_date_change].settings(:bcp_creation_day)
      ).to receive(:item).and_return(system_date.day)
    end

    context 'when:
      - with a prospective year bcp
      - feature :create_bcp_on_date_change is enabled
      - both :bcp_creation_month and :bcp_creation_day match with the system month and day
      ' do

      let(:feature_enabled) { true }

      it 'returns the existing prospective year bcp' do
        BenefitSponsorship.create_prospective_year_benefit_coverage_period(system_date)
        expect(
          benefit_sponsorship.reload.benefit_coverage_periods.by_year(prospective_year).count
        ).to eq(1)
        expect(
          benefit_sponsorship.reload.benefit_coverage_periods.by_year(prospective_year).first
        ).to eq(renewal_benefit_coverage_period)
      end
    end

    context 'when:
      - with a prospective year bcp
      - feature :create_bcp_on_date_change is disabled
      - both :bcp_creation_month and :bcp_creation_day match with the system month and day
      ' do

      let(:feature_enabled) { false }

      it 'returns the nil' do
        expect(
          BenefitSponsorship.create_prospective_year_benefit_coverage_period(system_date)
        ).to be_nil
      end
    end
  end

  describe '#create_benefit_coverage_period' do
    let(:hbx_profile) { FactoryBot.create(:hbx_profile) }

    let(:benefit_sponsorship) do
      FactoryBot.create(:benefit_sponsorship, hbx_profile: hbx_profile, benefit_coverage_periods: benefit_coverage_periods)
    end
    let(:current_year) { TimeKeeper.date_of_record.year }
    let(:prospective_year) { current_year.next }

    context 'with an existing benefit_coverage_period for the given year' do
      let(:benefit_coverage_periods) { [FactoryBot.build(:benefit_coverage_period, coverage_year: current_year)] }
      let!(:renewal_benefit_coverage_period) do
        FactoryBot.create(:benefit_coverage_period, benefit_sponsorship: benefit_sponsorship, coverage_year: prospective_year)
      end

      it 'returns the existing benefit_coverage_period' do
        expect(
          benefit_sponsorship.create_benefit_coverage_period(prospective_year)
        ).to eq(renewal_benefit_coverage_period)
      end
    end

    context 'without an existing benefit_coverage_period for the given year' do
      let(:benefit_coverage_periods) { [FactoryBot.build(:benefit_coverage_period, coverage_year: current_year)] }

      it 'returns the newly created benefit_coverage_period' do
        expect(
          benefit_sponsorship.create_benefit_coverage_period(prospective_year)
        ).to eq(
          benefit_sponsorship.benefit_coverage_periods.by_year(prospective_year).first
        )
      end
    end

    context 'without any benefit_coverage_periods' do
      let(:benefit_coverage_periods) { [] }

      it 'returns the existing benefit_coverage_period' do
        expect(
          benefit_sponsorship.create_benefit_coverage_period(prospective_year)
        ).to be_a(BenefitCoveragePeriod)
      end
    end
  end
end
