class AddPhotourlToSgmeetingAndNewborn < ActiveRecord::Migration
  def change
	add_column :newborn_details, :photo_url, :string
	add_column :support_group_meeting_details, :photo_url, :string
  end
end
