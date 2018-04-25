module OpenProject
  module WorklogLimiter
    module Patches
      module TimeEntryPatch
        def self.included(base)
          base.class_eval do
            include InstanceMethods

            validate :spent_on_current_week, on: :create
          end
        end

        module InstanceMethods
          private

          BUFFER_TIME = 12.hours.freeze

          def spent_on_current_week
            if !allowed_to_log_time_range.include?(spent_on)
              errors.add(:spent_on, :after, date: allowed_to_log_time_range.first)
              errors.add(:spent_on, :before, date: allowed_to_log_time_range.last)
            end            
          end

          def allowed_to_log_time_range
            if Time.zone.now < Time.zone.now.beginning_of_week + BUFFER_TIME
              Date.today.beginning_of_week - 1.week .. Date.today
            else
              Date.today.beginning_of_week .. Date.today
            end
          end
        end
      end
    end
  end
end

TimeEntry.send(:include, OpenProject::WorklogLimiter::Patches::TimeEntryPatch)
