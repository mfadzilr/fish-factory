class AddRefToSitePage < ActiveRecord::Migration[5.0]
  def change
    add_reference :site_pages,  :user
    add_reference :campaigns, :site_page
  end
end
