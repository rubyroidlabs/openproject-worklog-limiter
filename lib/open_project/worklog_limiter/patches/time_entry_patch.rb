module OpenProject
  module WorklogLimiter
    module Patches
      module TimeEntryPatch
        def self.included(base)
          base.class_eval do
            extend ClassMethods
            include InstanceMethods

            validate :spent_on_current_week, on: :create
          end
        end

        module ClassMethods
          BUFFER_TIME = 12.hours.freeze

          def available_for_time_log_range
            if Time.zone.now < Time.zone.now.beginning_of_week + BUFFER_TIME
              Date.today.beginning_of_week - 1.week .. Date.today
            else
              Date.today.beginning_of_week .. Date.today
            end
          end
        end

        module InstanceMethods
          private

          def spent_on_current_week
            if (!self.class.available_for_time_log_range.include?(spent_on) &&
                !user.allowed_to?(:log_time_for_any_date, project))
              errors.add(:spent_on, :after, date: self.class.available_for_time_log_range.first)
              errors.add(:spent_on, :before, date: self.class.available_for_time_log_range.last)
            end
          end
        end
      end
    end
  end
end

TimeEntry.send(:include, OpenProject::WorklogLimiter::Patches::TimeEntryPatch)
