# frozen_string_literal: true

module Operations
  module IvlOsseEligibilities
    # Overrides top level eligibility_configuration for ivl osse specific configurations
    class OsseEligibilityConfiguration < ::Operations::Eligible::EligibilityConfiguration
      def self.key
        :ivl_osse_eligibility
      end

      def self.title
        "Ivl Osse Eligibility"
      end

      def self.grants
        %i[
          childcare_subsidy_grant
        ]
      end
    end
  end
end