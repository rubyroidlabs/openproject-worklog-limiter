module OpenProject
  module WorklogLimiter
    module Patches
      module Authorization
        module UserAllowedServicePatch
          def self.included(base)
            base.prepend(InstanceMethods)
          end

          module InstanceMethods
            def allowed_to_in_project?(action, project, _options = {})
              if action.is_a?(Hash)
                return super
              end

              case action.to_sym
              when :log_time_for_any_date
                super &&
                user.allow_log_time_for_any_date_option_present? &&
                user.log_time_for_any_date_expires_at.present? &&
                Time.zone.now < user.log_time_for_any_date_expires_at
              else
                super
              end              
            end
          end
        end
      end
    end
  end
end

Authorization::UserAllowedService.send(:include, OpenProject::WorklogLimiter::Patches::Authorization::UserAllowedServicePatch)
