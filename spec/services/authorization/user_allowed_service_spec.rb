require 'spec_helper'

describe Authorization::UserAllowedService do
  describe 'log time for any date authorization' do
    context 'when user marked as able to log time for any date' do
      let(:authorized_user) { FactoryGirl.create(:allowed_to_log_time_for_any_date_user) }
      let(:work_package) { FactoryGirl.create(:work_package, author: authorized_user) }
      let(:project) { work_package.project }
      let(:role) { FactoryGirl.create(:role, name: 'Member') }

      before do
        role.add_permission!(:log_time_for_any_date)
      end
      
      context 'when authorization expiration time is not expired' do
        it 'user can log time for any date' do
          project.add_member!(authorized_user, role)
          expect(authorized_user.allowed_to?(:log_time_for_any_date, project)).to be_truthy
        end
      end

      context 'when authorization expiration time is expired' do
        before do
          authorized_user.update(log_time_for_any_date_expires_at: Date.yesterday)
        end

        it 'user cannot log time for any date' do
          project.add_member!(authorized_user, role)
          expect(authorized_user.allowed_to?(:log_time_for_any_date, project)).to be_falsy
        end
      end

      context 'when authorization expiration time is not set' do
        before do
          authorized_user.update(log_time_for_any_date_expires_at: nil)
        end

        it 'user cannot log time for any date' do
          project.add_member!(authorized_user, role)
          expect(authorized_user.allowed_to?(:log_time_for_any_date, project)).to be_falsy
        end
      end
    end

    context 'when user is not marked as able to log time for any date' do
      let(:not_authorized_user) { FactoryGirl.create(:user) }
      let(:work_package) { FactoryGirl.create(:work_package, author: not_authorized_user) }
      let(:project) { work_package.project }
      let(:role) { FactoryGirl.create(:role, name: 'Member') }

      before do
        role.add_permission!(:log_time_for_any_date)
      end

      context 'when authorization expiration time is not expired' do
        it 'user cannot log time for any date' do
          project.add_member!(not_authorized_user, role)
          expect(not_authorized_user.allowed_to?(:log_time_for_any_date, project)).to be_falsy
        end
      end

      context 'when authorization expiration time is expired' do
        it 'user cannot log time for any date' do
          project.add_member!(not_authorized_user, role)
          expect(not_authorized_user.allowed_to?(:log_time_for_any_date, project)).to be_falsy
        end
      end

      context 'when authorization expiration time is not set' do
        it 'user cannot log time for any date' do
          project.add_member!(not_authorized_user, role)
          expect(not_authorized_user.allowed_to?(:log_time_for_any_date, project)).to be_falsy
        end
      end
    end
  end
end
