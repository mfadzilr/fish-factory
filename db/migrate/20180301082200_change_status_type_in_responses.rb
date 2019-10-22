class ChangeStatusTypeInResponses < ActiveRecord::Migration[5.0]
  def change
  	change_column :responses, :status, :integer
  end
end
