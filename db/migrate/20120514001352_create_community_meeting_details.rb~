class CreateCommunityMeetingDetails < ActiveRecord::Migration
  def change
    create_table :community_meeting_details do |t|
      t.references:community_meeting
      t.integer:lhw_code
      t.integer:health_committee_meeting
      t.integer:support_group_meeting
      t.integer:health_education_session_in_schools
      t.timestamps
    end
  end
end
