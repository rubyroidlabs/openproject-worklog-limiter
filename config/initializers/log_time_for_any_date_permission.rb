Redmine::AccessControl.map do |map|
  map.project_module(:time_tracking) do |time|
    time.permission :log_time_for_any_date,
      { timelog: [:new, :create, :edit, :update] },
      require: :loggedin
  end
end

Role.all.each { |role| role.add_permission!(:log_time_for_any_date) }
