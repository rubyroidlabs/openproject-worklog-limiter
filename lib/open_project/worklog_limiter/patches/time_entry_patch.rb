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

          def current_week_dates
            now = Time.zone.now

            first_date = if now < now.beginning_of_week + BUFFER_TIME
              now.to_date.beginning_of_week - 1.week
            else
              now.to_date.beginning_of_week
            end

            first_date..now.to_date
          end
        end

        module InstanceMethods
          private

          def spent_on_current_week
            return if user.blank? || project.blank?

            if (!self.class.current_week_dates.include?(spent_on) &&
                !user.allowed_to?(:log_time_for_any_date, project))
              errors.add(:spent_on, :after, date: self.class.current_week_dates.first)
              errors.add(:spent_on, :before, date: self.class.current_week_dates.last)
            end
          end
        end
      end
    end
  end
end

TimeEntry.send(:include, OpenProject::WorklogLimiter::Patches::TimeEntryPatch)
