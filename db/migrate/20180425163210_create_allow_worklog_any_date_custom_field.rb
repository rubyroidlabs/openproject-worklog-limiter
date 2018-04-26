class CreateAllowWorklogAnyDateCustomField < ActiveRecord::Migration[5.0]
  def up
    CustomField.create(params)
  end

  def down
    CustomField.find_by(name: params[:name]).destroy
  end

  private

  def params
    {
      type: 'UserCustomField',
      field_format: 'bool', 
      default_value: '1',
      name: UserCustomField::ALLOW_LOG_TIME_FOR_ANY_DATE_LABEL
    }
  end
end
