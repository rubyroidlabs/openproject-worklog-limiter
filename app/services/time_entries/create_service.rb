class TimeEntries::CreateService
  attr_accessor :user, :time_entry, :project, :work_package

  def initialize(user:, project:, work_package:)
    self.user = user
    self.project = project
    self.work_package = work_package
    self.time_entry = new_time_entry
  end

  def call(attributes: {})
    set_attributes attributes

    success = validate_and_save
    ServiceResult.new success: success, errors: time_entry.errors, result: time_entry
  end

  private

  def new_time_entry
    TimeEntry.new(project: project,
      work_package: work_package,
      user: User.current,
      spent_on: User.current.today)
  end

  def set_attributes(attributes)
    time_entry.attributes = attributes
  end

  def validate_and_save
    validate_spent_on_current_week

    if time_entry.errors.empty?
      time_entry.save
    else
      false
    end
  end

  def validate_visible_work_package
    if time_entry.work_package
      time_entry.errors.add :work_package_id, :invalid unless time_entry.work_package.visible?(user)
    end
  end

  def validate_spent_on_current_week
    if !allowed_to_log_time_range.include?(time_entry.spent_on)
      time_entry.errors.add :spent_on, :after, date: allowed_to_log_time_range.first
      time_entry.errors.add :spent_on, :before, date: allowed_to_log_time_range.last
    end
  end

  def allowed_to_log_time_range
    if Time.zone.now < Time.zone.now.beginning_of_week + 12.hours
      Date.today.beginning_of_week - 1.week .. Date.today
    else
      Date.today.beginning_of_week .. Date.today
    end
  end
end
