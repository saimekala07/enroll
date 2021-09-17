# frozen_string_literal: true

require 'dry/monads'
require 'dry/monads/do'

module FinancialAssistance
  module Operations
    module Applications
      # This Operation processes all the date change events based on the date.
      class ProcessDateChangeEvents
        include Dry::Monads[:result, :do]
        include Acapi::Notifiers

        # @param [Hash] opts The options to submit renewal_draft application
        # @option opts [Date] :events_execution_date (required)
        # @option opts [Logger] :logger (required)
        # @option opts [Integer] :renewal_year (required)
        # @return [Dry::Monads::Result]
        def call(params)
          # adv_day_logger = Logger.new("#{Rails.root}/log/fa_application_advance_day_#{TimeKeeper.date_of_record.strftime('%Y_%m_%d')}.log")
          # { events_execution_date: TimeKeeper.date_of_record, logger: adv_day_logger, renewal_year: TimeKeeper.date_of_record.year.next }
          _validated_params = yield validate_input_params(params)
          _renewals_result  = yield process_renewals

          Success('Successfully processed all the date change events.')
        end

        private

        def validate_input_params(params)
          return Failure('Missing events_execution_date key') unless params.key?(:events_execution_date)
          return Failure('Missing logger key') unless params.key?(:logger)
          return Failure('Missing renewal_year key') unless params.key?(:renewal_year)
          return Failure("Invalid value: #{params[:events_execution_date]} for key events_execution_date, must be a Date object") if params[:events_execution_date].nil? || !params[:events_execution_date].is_a?(Date)
          return Failure("Invalid value: #{params[:logger]} for key logger, must be a Logger object") if params[:logger].nil? || !params[:logger].is_a?(Logger)
          return Failure("Invalid value: #{params[:renewal_year]} for key renewal_year, must be an Integer") if params[:renewal_year].nil? || !params[:renewal_year].is_a?(Integer)

          @new_date = params[:events_execution_date]
          @logger = params[:logger]
          @renewal_year = params[:renewal_year]
          Success(params)
        end

        def process_renewals
          @logger.info 'Started process_renewals process'
          # create_application_renewal_requests if can_generate_draft_renewals?
          # publish_submit_renewal_drafts if can_submit_renewal_drafts?
          @logger.info 'Ended process_renewals process'
          Success('Processed application renewals successfully')
        end

        def can_generate_draft_renewals?
          FinancialAssistanceRegistry.feature_enabled?(:generate_draft_renewals) &&
            TimeKeeper.date_of_record == date_of_draft_renewals_generation
        end

        def can_submit_renewal_drafts?
          FinancialAssistanceRegistry.feature_enabled?(:submit_renewal_drafts) &&
            TimeKeeper.date_of_record == date_of_submit_renewal_drafts
        end

        def create_application_renewal_requests
          @logger.info 'Started create_application_renewal_requests process'
          ::FinancialAssistance::Operations::Applications::MedicaidGateway::CreateApplicationRenewalRequest.new.call(renewal_year: @renewal_year)
          @logger.info 'Ended create_application_renewal_requests process'
        rescue StandardError => e
          @logger.info "Failed to execute create_application_renewal_requests, error: #{e.backtrace}"
        end

        # def create_renewal_application_submit_requests
        #   @logger.info 'Started create_renewal_application_submit_requests process'
        #   ::FinancialAssistance::Operations::Applications::MedicaidGateway::CreateRenewalApplicationSubmitRequest.new.call(renewal_year: @renewal_year)
        #   @logger.info 'Ended create_renewal_application_submit_requests process'
        # rescue StandardError => e
        #   @logger.info "Failed to execute create_renewal_application_submit_requests, error: #{e.backtrace}"
        # end

        def generate_bulk_draft_renewals
          @logger.info 'Started generate_bulk_draft_renewals process'
          family_ids = FinancialAssistance::Application.where(assistance_year: @renewal_year.pred).distinct(:family_id).uniq
          @logger.info "Total number of families with fa_applications: #{family_ids.count}"
          family_ids.inject([]) do |_arr, family_id|
            @logger.info '-' * 20
            payload = { family_id: family_id.to_s, renewal_year: @renewal_year }
            result = ::FinancialAssistance::Operations::Applications::CreateRenewalDraft.new.call(payload)
            @logger.info "Successfully generated renewal draft, with payload: #{payload}" if result.success?
            @logger.info "Failed to generate renewal draft, with payload: #{payload}, failure: #{result.failure}" if result.failure?
          rescue StandardError, SystemStackError => e
            @logger.info "Errored out while generating renewal draft, with payload: #{payload}, error_message: #{e.message}, backtrace: #{e.backtrace}"
          end

          @logger.info 'Ended generate_bulk_draft_renewals process'
        rescue StandardError => e
          @logger.info "Failed to execute generate_bulk_draft_renewals, error: #{e.backtrace}"
        end

        def submit_bulk_renewal_drafts
          @logger.info 'Started submit_bulk_renewal_drafts process'
          applications = FinancialAssistance::Application.renewal_draft.where(assistance_year: @renewal_year)
          @logger.info "Total number of renewal_draft applications with assistance_year: #{@renewal_year.pred} are #{applications.count}"

          applications.inject([]) do |_arr, application|
            @logger.info '-' * 20
            payload = { application_hbx_id: application.hbx_id.to_s }
            result = ::FinancialAssistance::Operations::Applications::Renew.new.call(payload)
            @logger.info "Successfully submitted renewal_draft, with payload: #{payload}" if result.success?
            @logger.info "Failed to submit renewal_draft, with payload: #{payload}, failure: #{result.failure}" if result.failure?
          rescue StandardError, SystemStackError => e
            @logger.info "Errored out while submitting renewal draft, with payload: #{payload}, error_message: #{e.message}, backtrace: #{e.backtrace}"
          end

          @logger.info 'Ended submit_bulk_renewal_drafts process'
        rescue StandardError => e
          @logger.info "Failed to execute submit_bulk_renewal_drafts, error: #{e.backtrace}"
        end

        def date_of_draft_renewals_generation
          day = FinancialAssistanceRegistry[:generate_draft_renewals].settings(:draft_renewal_generation_day).item
          month = FinancialAssistanceRegistry[:generate_draft_renewals].settings(:draft_renewal_generation_month).item
          Date.new(TimeKeeper.date_of_record.year, month, day)
        end

        def date_of_submit_renewal_drafts
          day = FinancialAssistanceRegistry[:submit_renewal_drafts].settings(:renewal_draft_submission_day).item
          month = FinancialAssistanceRegistry[:submit_renewal_drafts].settings(:renewal_draft_submission_month).item
          Date.new(TimeKeeper.date_of_record.year, month, day)
        end
      end
    end
  end
end
