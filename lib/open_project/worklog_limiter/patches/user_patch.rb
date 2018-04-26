module OpenProject
  module WorklogLimiter
    module Patches
      module UserPatch
        def self.included(base)
          base.class_eval do
            include InstanceMethods

            before_save :set_add_worklog_any_date_expires_at,
              if: :log_time_for_any_date_changed?
          end
        end

        module InstanceMethods
          ALLOW_LOG_TIME_FOR_ANY_DATE_FOR =  1.day.freeze

          def allow_log_time_for_any_date_option_present?
            field = UserCustomField.find_by(name: UserCustomField::ALLOW_LOG_TIME_FOR_ANY_DATE_LABEL)
            custom_value = custom_values.find { |custom_value| custom_value.custom_field == field }
            custom_value && custom_value.value == 't'
          end

          private

          def set_add_worklog_any_date_expires_at
            self.log_time_for_any_date_expires_at = if allow_log_time_for_any_date_option_present?
              Time.zone.now + ALLOW_LOG_TIME_FOR_ANY_DATE_FOR
            else
              nil
            end
          end
        end

        def log_time_for_any_date_changed?
          custom_value = custom_values.find do |custom_value|
            custom_field = custom_value.custom_field
            custom_field.name == UserCustomField::ALLOW_LOG_TIME_FOR_ANY_DATE_LABEL
          end
          custom_value && custom_value.value_changed?
        end
      end
    end
  end
end

User.send(:include, OpenProject::WorklogLimiter::Patches::UserPatch)
