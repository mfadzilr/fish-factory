class CreateReportSources < ActiveRecord::Migration[5.0]
  def change
    create_table :report_sources do |t|
      t.belongs_to :report, foreign_key: true
      t.belongs_to :campaign, foreign_key: true

      t.timestamps
    end
  end
end
