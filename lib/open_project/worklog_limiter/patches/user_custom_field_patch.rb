module OpenProject
  module WorklogLimiter
    module Patches
      module UserCustomFieldPatch
        def self.included(base)
          base.class_eval do
            include Constants
          end
        end

        module Constants
          ALLOW_LOG_TIME_FOR_ANY_DATE_LABEL = 'Allow log time for any date'.freeze
        end
      end
    end
  end
end

UserCustomField.send(:include, OpenProject::WorklogLimiter::Patches::UserCustomFieldPatch)
