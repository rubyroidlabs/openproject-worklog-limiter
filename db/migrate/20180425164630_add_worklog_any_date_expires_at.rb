class AddWorklogAnyDateExpiresAt < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :log_time_for_any_date_expires_at, :datetime
  end
end
