class RecipientGroup < ApplicationRecord

  belongs_to  :user
  has_many    :recipients, dependent: :destroy
  has_many    :campaign_sources, dependent: :destroy
  has_many    :campaigns, through: :campaign_sources

  validates :name, presence: true
  validates_uniqueness_of :name, presence: true, scope: :user_id, uniqueness: { case_sensitive: false }

  def self.import(file,recipient_group)
    begin
      spreadsheet = open_spreadsheet(file)
      (2..spreadsheet.last_row).each do |i|
        recipient = Recipient.new
        row = spreadsheet.row(i)
        row = row.each.map{ |e| e ? (e.strip):''}
        recipient.full_name = row[0]
        recipient.designation = row[1]
        recipient.department = row[2]
        recipient.email_to = row[3]
        recipient.recipient_group_id = recipient_group.id
        begin
          recipient.save!
        rescue
        end
      end
    rescue
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path, packed: false, file_warning: :ignore)
    when ".xls" then  Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
    when ".xlsx" then  Roo::Excel.new(file.path, packed: false, file_warning: :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

end
