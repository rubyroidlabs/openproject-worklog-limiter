require 'spec_helper'

describe TimeEntry, type: :model do
  let(:work_package) { FactoryGirl.create(:work_package) }
  let(:project) { work_package.project }

  describe '#current_week_dates' do
    let(:time_entry) { FactoryGirl.build(:time_entry, work_package: work_package, project: project) }

    before do
      time_entry.spent_on = spent_on
      time_entry.save
    end

    context 'when spent on previous week date' do
      context 'and created at Monday' do
        context 'before 12:00' do
          let(:spent_on) { spent_on = Date.parse('27-04-2018') }

          before do
            allow(Time.zone).to receive(:now).
              and_return(DateTime.parse('30-04-2018T11:00:00+03:00'))
          end

          it 'should be valid' do
            expect(time_entry).to be_valid
          end
        end

        context 'after 12:00' do
          let(:spent_on) { spent_on = Date.parse('27-04-2018') }

          before do
            allow(Time.zone).to receive(:now).
              and_return(DateTime.parse('30-04-2018T13:00:00+03:00'))
          end

          it 'should be invalid' do
            expect(time_entry).to be_invalid
            
            errors = time_entry.errors.messages[:spent_on].join(', ')
            expect(errors).to include('must be after')
            expect(errors).to include('must be before')
          end
        end
      end
    end

    context 'when spent on current week date' do
      before do
        allow(Time.zone).to receive(:now).
          and_return(DateTime.parse('02-05-2018T11:00:00+03:00'))
      end

      context 'in the past' do
        let(:spent_on) { spent_on = Date.parse('30-04-2018') }

        it 'should be valid' do
          expect(time_entry).to be_valid
        end
      end

      context 'in the future' do
        let(:spent_on) { spent_on = Date.parse('03-05-2018') }

        it 'should be invalid' do
          expect(time_entry).to be_invalid
          
          errors = time_entry.errors.messages[:spent_on].join(', ')
          expect(errors).to include('must be after')
          expect(errors).to include('must be before')
        end
      end
    end
  end
end

