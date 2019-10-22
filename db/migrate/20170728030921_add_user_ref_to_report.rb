class AddUserRefToReport < ActiveRecord::Migration[5.0]
  def change
    add_reference   :reports, :user
  end
end
