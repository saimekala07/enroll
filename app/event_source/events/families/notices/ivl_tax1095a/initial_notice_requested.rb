# frozen_string_literal: true

module Events
  module Families
    module Notices
      module IvlTax1095a
        # This class will register event 'initial1095a_notice.requested'
        class InitialNoticeRequested < EventSource::Event
          publisher_path 'publishers.families.notices.ivl_tax1095a_notice_requested_publisher'

        end
      end
    end
  end
end

