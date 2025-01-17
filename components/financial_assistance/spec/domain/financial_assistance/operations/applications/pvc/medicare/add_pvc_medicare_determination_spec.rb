# frozen_string_literal: true

require 'rails_helper'
require "#{FinancialAssistance::Engine.root}/spec/shared_examples/pvc/medicare/test_pvc_medicare_response"

RSpec.describe ::FinancialAssistance::Operations::Applications::Pvc::Medicare::AddPvcMedicareDetermination, dbclean: :after_each do
  before :all do
    DatabaseCleaner.clean
  end

  let(:family) { FactoryBot.create(:family, :with_primary_family_member)}
  let!(:application) do
    FactoryBot.create(:financial_assistance_application, hbx_id: '200000126', aasm_state: "determined",
                                                         family_id: family.id)
  end
  let!(:applicant) do
    FactoryBot.create(:financial_assistance_applicant,
                      eligibility_determination_id: nil,
                      person_hbx_id: '1629165429385938',
                      is_primary_applicant: true,
                      first_name: 'esi',
                      last_name: 'evidence',
                      ssn: "518124854",
                      dob: Date.new(1988, 11, 11),
                      family_member_id: family.primary_family_member.id,
                      application: application)
  end

  let(:due_on) { nil }
  let(:aasm_state) { 'attested' }
  let(:enrollment) { nil }

  context 'success' do
    context 'FDSH PVC Medicare outstanding response' do
      include_context 'FDSH PVC Medicare sample response'

      before do
        enrollment
        @applicant = application.applicants.first
        @applicant.build_non_esi_evidence(key: :non_esi_mec, title: "NON ESI MEC", aasm_state: aasm_state,
                                          due_on: due_on)
        @applicant.save!
        @result = subject.call({payload: response_payload, applicant_identifier: '1629165429385938'})

        @application = ::FinancialAssistance::Application.by_hbx_id(response_payload[:hbx_id]).first.reload
        @app_entity = ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(response_payload).success
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should update applicant verification' do
        @applicant.reload
        expect(@applicant.non_esi_evidence.aasm_state).to eq 'negative_response_received'
        expect(@result.success).to eq('Successfully updated Applicant with evidences and verifications')
      end

      context "due_date does not exists and enrolled" do
        let(:enrollment) do
          FactoryBot.create(:hbx_enrollment, :with_enrollment_members,
                            family: family, enrollment_members: family.family_members)
        end
        let(:request_result_hash) do
          {
            :result => "eligible",
            :source => "MEDC",
            :code => "7313",
            :code_description => "Applicant Not Found",
            :action => 'pvc_bulk_call'
          }
        end

        it 'should set due date to system_date + 35.days it is a bulk call' do
          due_date = TimeKeeper.date_of_record + EnrollRegistry[:bulk_call_verification_due_in_days].item.to_i
          @applicant.reload
          expect(@applicant.non_esi_evidence.due_on).to eq due_date
        end
      end

      context 'due_date exists' do
        let(:due_on) { TimeKeeper.date_of_record }
        let(:aasm_state) { 'outstanding' }

        it 'should not update due_on on local mec evidence' do
          @applicant.reload
          expect(@applicant.non_esi_evidence.due_on).to eq nil
        end
      end
    end

    context 'FDSH PVC Medicare attested response' do
      include_context 'FDSH PVC Medicare sample response'

      before do
        @applicant = application.applicants.first
        @applicant.build_non_esi_evidence(key: :non_esi_mec, title: "NON ESI MEC")
        @applicant.save!
        @result = subject.call(payload: response_payload_2, applicant_identifier: '1629165429385938')

        @application = ::FinancialAssistance::Application.by_hbx_id(response_payload[:hbx_id]).first.reload
        @app_entity = ::AcaEntities::MagiMedicaid::Operations::InitializeApplication.new.call(response_payload).success
      end

      it 'should return success' do
        expect(@result).to be_success
      end

      it 'should update applicant verification' do
        @applicant.reload
        expect(@applicant.non_esi_evidence.aasm_state).to eq "attested"
        expect(@applicant.non_esi_evidence.due_on).to be nil
        expect(@result.success).to eq('Successfully updated Applicant with evidences and verifications')
      end
    end
  end
end
