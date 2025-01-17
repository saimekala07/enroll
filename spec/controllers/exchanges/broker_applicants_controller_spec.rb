require 'rails_helper'

RSpec.describe Exchanges::BrokerApplicantsController do

  describe ".index" do
    let(:user) { instance_double("User", :has_hbx_staff_role? => true) }

    before :each do
      sign_in(user)
      get :index, format: :js, xhr:true
    end

    it "should render index" do
      expect(assigns(:broker_applicants))
      expect(response).to have_http_status(:success)
      expect(response).to render_template("exchanges/broker_applicants/index")
    end

    context 'when hbx staff role missing' do
      let(:user) { instance_double("User", :has_hbx_staff_role? => false) }

      it 'should redirect when hbx staff role missing' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to('/exchanges/hbx_profiles')
      end
    end
  end

  describe ".edit" do
    let(:user) { instance_double("User", :has_hbx_staff_role? => true, :person => person) }
    let(:person) { instance_double("Person", :agent? => false) }
    let(:broker_role) {FactoryBot.create(:broker_role)}

    before :each do
      sign_in(user)
      get :edit, params:{id: broker_role.person.id}, format: :html, xhr:true
    end

    it "should render edit" do
      expect(assigns(:broker_applicant))
      expect(response).to have_http_status(:success)
      expect(response).to render_template("shared/brokers/applicant.html.erb", "layouts/single_column")
    end
  end

  describe ".update" do
    let(:user) { instance_double("User", :has_hbx_staff_role? => true, :person => person) }
    let(:person) { instance_double("Person", :agent? => false) }
    let(:broker_role) {FactoryBot.create(:broker_role)}

    before :all do
      @broker_agency_profile = FactoryBot.create(:broker_agency).broker_agency_profile
    end

    before :each do
      @broker_agency_profile.update_attributes({ primary_broker_role: broker_role })
      sign_in(user)
    end

    context 'carrier appointments, license, and reason' do
      it "should update for blank values" do
        put(
          :update,
          params: {
            "update" => "Update",
            id: broker_role.person.id,
            "person" => {
              "broker_role_attributes" => {
                "license" => "0",
                "training" => "0",
                "carrier_appointments" => {}
              }
            }
          }
        )
        broker_role.reload
        expect(broker_role.carrier_appointments).to eq({})
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to('/exchanges/hbx_profiles')
      end

      it 'should update for set values' do
        broker_role.update_attributes!(carrier_appointments: {})
        broker_role.reload
        expect(broker_role.carrier_appointments).to eq({})
        put(
          :update,
          params: {
            "update" => "Update",
            id: broker_role.person.id,
            "person" => {
              "broker_role_attributes" => {
                "license" => "1",
                "training" => "1",
                "carrier_appointments" => {"Aetna Health Inc" => "true", "United Health Care Insurance" => "true"}
              }
            }
          }
        )
        broker_role.reload
        expect(broker_role.carrier_appointments).to eq({"Aetna Health Inc" => "true", "United Health Care Insurance" => "true"})
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to('/exchanges/hbx_profiles')
      end
    end

    context 'when application denied' do
      before :each do
        put :update, params:{id: broker_role.person.id, deny: true}, format: :js
        broker_role.reload
      end

      it "should change applicant status to denied" do
        expect(assigns(:broker_applicant))
        expect(broker_role.aasm_state).to eq 'denied'
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to('/exchanges/hbx_profiles')
      end
    end

    context 'when application extended' do
      context "for denied application" do
        before :each do
          broker_role.deny!
          put :update, params: { id: broker_role.person.id, extend: true }, format: :js
          broker_role.reload
        end

        it 'should move application to application_extended' do
          expect(assigns(:broker_applicant))
          expect(broker_role.aasm_state).to eq 'application_extended'
        end

        it 'should redirect' do
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to('/exchanges/hbx_profiles')
        end
      end

      context "for pending application" do
        before :each do
          allow(broker_role).to receive(:is_primary_broker?).and_return(true)
          broker_role.pending!
          put :update, params: { id: broker_role.person.id, extend: true }, format: :js
          broker_role.reload
        end

        it 'should move application to application_extended' do
          expect(assigns(:broker_applicant))
          expect(broker_role.aasm_state).to eq 'application_extended'
        end

        it 'should redirect' do
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to('/exchanges/hbx_profiles')
        end
      end

      context "for extended application" do
        before :each do
          broker_role.deny!
          broker_role.extend_application!
          put :update, params: { id: broker_role.person.id, extend: true }, format: :js
          broker_role.reload
        end

        it 'should move application to application_extended' do
          expect(assigns(:broker_applicant))
          expect(broker_role.aasm_state).to eq 'application_extended'
        end

        it 'should redirect' do
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to('/exchanges/hbx_profiles')
        end
      end
    end

    context 'when application approved and applicant is not primary broker' do

      before :each do
        FactoryBot.create(:hbx_profile)
        put :update, params:{id: broker_role.person.id, approve: true, person: { broker_role_attributes: { training: true , carrier_appointments: {}} } }, format: :js
        broker_role.reload
      end

      it "should approve and change status to broker agency pending" do
        allow(broker_role).to receive(:broker_agency_profile).and_return(@broker_agency_profile)

        expect(assigns(:broker_applicant))
        expect(broker_role.aasm_state).to eq 'broker_agency_pending'
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to('/exchanges/hbx_profiles')
      end
    end

    context 'when applicant is a primary broker' do
      let(:broker_agency_profile) { FactoryBot.create(:broker_agency_profile, primary_broker_role_id: broker_role.id) }

      context 'when application is approved' do
        before :each do
          broker_role.update_attributes({ broker_agency_profile_id: @broker_agency_profile.id })
          put :update, params: {id: broker_role.person.id, approve: true, person: { broker_role_attributes: { training: true , carrier_appointments: {}} }} , format: :js
          broker_role.reload
        end

        it "should change applicant status to active" do
          expect(assigns(:broker_applicant))
          expect(broker_role.aasm_state).to eq 'active'
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to('/exchanges/hbx_profiles')
        end

        it "should have training as true in broker role attributes" do
          expect(broker_role.training).to eq true
        end
      end

      context 'when application is updated' do
        before :each do
          broker_role.update_attributes({ broker_agency_profile_id: @broker_agency_profile.id })
          broker_role.approve!
          put :update, params: {id: broker_role.person.id, update: true, person: { broker_role_attributes: { training: true, carrier_appointments: EnrollRegistry[:brokers].settings(:carrier_appointments).item }}}, format: :js
          broker_role.reload
        end

        it "should change applicant status to active" do
          expect(assigns(:broker_applicant))
          expect(broker_role.aasm_state).to eq 'active'
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to('/exchanges/hbx_profiles')
          expect(broker_role.carrier_appointments.symbolize_keys).to eq(EnrollRegistry[:brokers].settings(:carrier_appointments).item)
        end

        it "should have training as true in broker role attributes" do
          expect(broker_role.training).to eq true
        end
      end

      context 'when broker carrier appointments enabled and application is pending' do
        context 'when application is pending' do
          let(:carrier_appointments_hash) do
            ca = {}
            EnrollRegistry[:brokers].setting(:carrier_appointments).item.stringify_keys.each do |k, _v|
              ca[k] = "true"
            end
            ca
          end

          before :each do
            allow(Settings.aca).to receive(:broker_carrier_appointments_enabled).and_return(true)
            broker_role.update_attributes({ broker_agency_profile_id: @broker_agency_profile.id })
            put :update, params:{id: broker_role.person.id, pending: true, person:  { broker_role_attributes: { training: true , carrier_appointments: {}} }} , format: :js
            broker_role.reload
          end

          it "all broker carrier appointments should be true" do
            expect(broker_role.carrier_appointments).to eq(carrier_appointments_hash)
          end

          it "should change applicant status to broker_agency_pending" do
            expect(assigns(:broker_applicant))
            expect(broker_role.aasm_state).to eq 'broker_agency_pending'
            expect(response).to have_http_status(:redirect)
            expect(response).to redirect_to('/exchanges/hbx_profiles')
          end

          it "should have training as true in broker role attributes" do
            expect(broker_role.training).to eq true
          end
        end
      end

      context 'when broker carrier appointments disabled and application is pending' do
        context 'when application is pending' do
          let(:carrier_appointments_hash) do
            EnrollRegistry[:brokers].setting(:carrier_appointments).item.stringify_keys
          end
          before :each do
            person_hash = ActionController::Parameters.new({ broker_role_attributes: { training: true, carrier_appointments: carrier_appointments_hash } }).permit!
            Settings.aca.broker_carrier_appointments_enabled = false
            broker_role.update_attributes({ broker_agency_profile_id: @broker_agency_profile.id })
            put :update, params:{id: broker_role.person.id, pending: true, person: person_hash}, format: :js
            broker_role.reload
          end

          it "broker carrier appointments should be user selected" do
            expect(broker_role.carrier_appointments.find {|_k, v| v == "true" }).to eq(carrier_appointments_hash.find {|_k, v| v == "true" })
          end

          it "should change applicant status to broker_agency_pending" do
            expect(assigns(:broker_applicant))
            expect(broker_role.aasm_state).to eq 'broker_agency_pending'
            expect(response).to have_http_status(:redirect)
            expect(response).to redirect_to('/exchanges/hbx_profiles')
          end

          it "should have training as true in broker role attributes" do
            expect(broker_role.training).to eq true
          end
        end
      end

      context 'when application is decertified' do
        before :each do
          broker_role.update_attributes({ broker_agency_profile_id: @broker_agency_profile.id })
          broker_role.approve!
          put :update, params:{id: broker_role.person.id, decertify: true}, format: :js
          broker_role.reload
        end

        it "should change applicant status to decertified" do
          expect(assigns(:broker_applicant))
          expect(broker_role.aasm_state).to eq 'decertified'
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to('/exchanges/hbx_profiles')
        end
      end

      context 'when application is re-certified' do
        before :each do
          broker_role.update_attributes({ broker_agency_profile_id: @broker_agency_profile.id })
          broker_role.approve!
          broker_role.decertify!
          put :update, params:{id: broker_role.person.id, recertify: true}, format: :js
          broker_role.reload
        end

        it "should change applicant status to active" do
          expect(assigns(:broker_applicant))
          expect(broker_role.aasm_state).to eq 'active'
          expect(response).to have_http_status(:redirect)
          expect(response).to redirect_to('/exchanges/hbx_profiles')
        end
      end
    end
    context 'when broker invitation email is resent' do
      let(:invitation) { Invitation.new }
      before :each do
        allow(EnrollRegistry).to receive(:feature_enabled?).with(:resend_broker_email_button).and_return(true)
        allow(EnrollRegistry).to receive(:feature_enabled?).with(:prevent_concurrent_sessions).and_return(false)
        allow(EnrollRegistry).to receive(:feature_enabled?).with(:preferred_user_access).and_return(true)
        allow(EnrollRegistry).to receive(:feature_enabled?).with(:broker_role_consumer_enhancement).and_return(false)
        put :update, params: {id: broker_role.person.id, sendemail: true}, format: :js
      end

      it "should call send_broker_invitation" do
        allow(Invitation).to receive(:create).and_return invitation
        expect(invitation).to receive(:send_broker_invitation!)
        Invitation.invite_broker!(broker_role)
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to('/exchanges/hbx_profiles')
      end
    end
  end

  describe '#update' do
    context "when:
      - person A exists with broker role and broker agency staff role associated with broker agency A
      - person B exists with a Consumer Role
      - person B has a User
      - person B has a broker agency staff role for broker agency A
      - person B has a broker role and broker agency staff role associated with broker agency B
      - admin approves person B's Broker Application" do

      let(:site) do
        FactoryBot.create(
          :benefit_sponsors_site,
          :with_benefit_market,
          :as_hbx_profile,
          site_key: ::EnrollRegistry[:enroll_app].settings(:site_key).item
        )
      end

      let(:broker_agency_organization_A) { FactoryBot.create(:benefit_sponsors_organizations_general_organization, :with_broker_agency_profile, site: site) }

      let(:broker_agency_profile_A) { broker_agency_organization_A.broker_agency_profile }

      let(:person_A) { FactoryBot.create(:person, :with_consumer_role, :with_active_consumer_role) }

      let(:broker_role_A) { FactoryBot.create(:broker_role, person: person_A, benefit_sponsors_broker_agency_profile_id: broker_agency_profile_A.id) }

      let(:basr_1_A) do
        person_A.create_broker_agency_staff_role(
          benefit_sponsors_broker_agency_profile_id: broker_agency_profile_A.id
        )
      end

      let(:broker_agency_organization_B) { FactoryBot.create(:benefit_sponsors_organizations_general_organization, :with_broker_agency_profile, site: site) }

      let(:broker_agency_profile_B) { broker_agency_organization_B.broker_agency_profile }

      let(:person_B) do
        FactoryBot.create(:person, :with_consumer_role, :with_active_consumer_role, :with_hbx_staff_role)
      end

      let(:broker_role_B) { FactoryBot.create(:broker_role, person: person_B, benefit_sponsors_broker_agency_profile_id: broker_agency_profile_B.id) }

      let(:basr_2_A) do
        basf = person_B.create_broker_agency_staff_role(
          benefit_sponsors_broker_agency_profile_id: broker_agency_profile_A.id
        )
        basf.broker_agency_accept!
        basf
      end

      let(:basr_2_B) do
        person_B.create_broker_agency_staff_role(
          benefit_sponsors_broker_agency_profile_id: broker_agency_profile_B.id
        )
      end

      let(:user) { FactoryBot.create(:user, :with_hbx_staff_role, person: person_B) }

      let(:input_params) do
        {
          id: person_B.id,
          approve: true,
          person: {
            broker_role_attributes: {
              training: true,
              carrier_appointments: {}
            }
          }
        }
      end

      before :each do
        allow(EnrollRegistry).to receive(:feature_enabled?).and_call_original
        allow(EnrollRegistry).to receive(:feature_enabled?).with(:broker_role_consumer_enhancement).and_return(true)

        broker_agency_profile_A.update_attributes!(primary_broker_role_id: broker_role_A.id)
        basr_1_A

        broker_agency_profile_B.update_attributes!(primary_broker_role_id: broker_role_B.id)
        basr_2_A
        basr_2_B

        sign_in(user)
        put :update, params: input_params, format: :js
      end

      it 'approves the broker, broker agency profile and broker agency staff role' do
        expect(broker_role_B.reload.active?).to be_truthy
        expect(broker_agency_profile_B.reload.is_approved?).to be_truthy
        expect(basr_2_B.reload.active?).to be_truthy
      end
    end
  end
end
