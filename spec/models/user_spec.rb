require 'spec_helper'

describe User, type: :model do
  let(:user) { FactoryGirl.create(:allowed_to_log_time_for_any_date_user) }

  describe 'which allowed to log time for any date' do
    it 'can log time for any date for 1 day' do
      expect(user.log_time_for_any_date_expires_at).to be_truthy
    end
  end
end
