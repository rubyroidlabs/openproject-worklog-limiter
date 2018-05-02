module OpenProject
  module WorklogLimiter
    module Patches
      module CustomValuePatch
        def self.included(base)
          base.class_eval do
            include InstanceMethods

            after_save -> { customized.set_log_time_for_any_date_expires_at },
              if: :allow_log_time_for_any_date_value_changed?
          end
        end

        module InstanceMethods

          private

          def allow_log_time_for_any_date_value_changed?
            customized.is_a?(User) &&
            custom_field &&
            custom_field.name == UserCustomField::ALLOW_LOG_TIME_FOR_ANY_DATE_LABEL &&
            value_changed?
          end
          
        end
      end
    end
  end
end

CustomValue.send(:include, OpenProject::WorklogLimiter::Patches::CustomValuePatch)
