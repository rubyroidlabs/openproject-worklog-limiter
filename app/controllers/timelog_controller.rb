class TimelogController < ApplicationController
  def create
    service = TimeEntries::CreateService.new user: current_user, project: @project, work_package: @issue
    result = service.call(attributes: permitted_params.time_entry.to_h)
    @time_entry = service.time_entry

    call_hook(:controller_timelog_edit_before_save, params: params, time_entry: @time_entry)
    respond_for_saving result.success?
  end
end
