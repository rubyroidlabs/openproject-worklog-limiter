module OpenProject
  module WorklogLimiter
    module Patches
      module UserPatch
        def self.included(base)
          base.class_eval do
            include InstanceMethods
          end
        end

        module InstanceMethods
          ALLOW_LOG_TIME_FOR_ANY_DATE_FOR =  1.day.freeze

          def allow_log_time_for_any_date_option_present?
            field = UserCustomField.find_by(name: UserCustomField::ALLOW_LOG_TIME_FOR_ANY_DATE_LABEL)
            custom_value = custom_values.find { |custom_value| custom_value.custom_field == field }
            custom_value && custom_value.value == 't'
          end

          def set_log_time_for_any_date_expires_at
            expires_at = if allow_log_time_for_any_date_option_present?
              Time.zone.now + User::ALLOW_LOG_TIME_FOR_ANY_DATE_FOR
            else
              nil
            end
            update(log_time_for_any_date_expires_at: expires_at)
          end
        end
      end
    end
  end
end

User.send(:include, OpenProject::WorklogLimiter::Patches::UserPatch)
