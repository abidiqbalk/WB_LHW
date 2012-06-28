class CreateReportingCommunityMeetingDetails < ActiveRecord::Migration
  def change
    create_table :reporting_community_meeting_details do |t|
      t.references:reporting_community_meeting
      t.string:facility_code
	  t.integer:lhw_code
      t.integer:health_committee_meeting
      t.integer:support_group_meeting
      t.integer:health_education_session_in_schools
      t.timestamps
    end
  end
end
