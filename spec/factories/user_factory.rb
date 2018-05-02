FactoryGirl.define do
  factory :allowed_to_log_time_for_any_date_user, class: User do
    firstname 'Bob'
    lastname 'Bobbit'
    sequence(:login) do |n| "bob#{n}" end
    sequence(:mail) do |n| "bob#{n}.bobbit@bob.com" end

    after :create do |user|
      log_time_for_any_date_custom_field = create(:user_custom_field,
        name: UserCustomField::ALLOW_LOG_TIME_FOR_ANY_DATE_LABEL)
      user.custom_values.build build(:principal_custom_value,
        custom_field: log_time_for_any_date_custom_field,
        customized: user,
        value: 't').attributes
      user.save
      user.reload
    end
  end
end
