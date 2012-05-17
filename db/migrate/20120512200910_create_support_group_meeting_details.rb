class CreateSupportGroupMeetingDetails < ActiveRecord::Migration
  def change
    create_table :support_group_meeting_details do |t|
      t.references:support_group_meeting
      t.integer:lhw_code
      t.integer:number_of_groups_formed
      t.integer:members_in_group_a
      t.integer:members_in_group_b
      t.integer:members_in_group_c
      t.integer:members_in_group_d
      t.datetime:last_support_group_meeting
       

      t.timestamps
    end
  end
end
