class HealthFacility < ActiveRecord::Base
include Reportable
belongs_to :district

has_many :reporting_birth_death_details, :foreign_key => :facility_code, :primary_key =>:facility_code, :include => :reporting_birth_death
has_many :reporting_birth_death, :through => :reporting_birth_death_details
has_many :reporting_child_health_details, :foreign_key => :facility_code, :primary_key =>:facility_code, :include => :reporting_child_health
has_many :reporting_child_health, :through => :reporting_child_health_details
has_many :reporting_community_meeting_details, :foreign_key => :facility_code, :primary_key =>:facility_code, :include => :reporting_community_meeting
has_many :reporting_community_meeting, :through => :reporting_community_meeting_details
has_many :reporting_facility_details, :foreign_key => :facility_code, :primary_key =>:facility_code, :include => :reporting_facility
has_many :reporting_facility, :through => :reporting_facility_details
has_many :reporting_family_planning_details, :foreign_key => :facility_code, :primary_key =>:facility_code, :include => :reporting_family_planning
has_many :reporting_family_planning, :through => :reporting_family_planning_details
has_many :reporting_maternal_health_details, :foreign_key => :facility_code, :primary_key =>:facility_code, :include => :reporting_maternal_health
has_many :reporting_maternal_health, :through => :reporting_maternal_health_details
has_many :reporting_treatment_details, :foreign_key => :facility_code, :primary_key =>:facility_code, :include => :reporting_treatment
has_many :reporting_treatment, :through => :reporting_treatment_details


	def indicator_statistics(end_time, activities)
		self.statistics = Hash.new
		
		for activity in activities
			detail = activity.reflections[:detail].klass			
			from_substring = "FROM `#{detail.table_name}` INNER JOIN `health_facilities` ON `health_facilities`.`facility_code` = `#{detail.table_name}`.`facility_code` LEFT OUTER JOIN `phone_entries` ON `phone_entries`.`id` = `#{detail.table_name}`.`#{activity.reflections[:detail].foreign_key}` WHERE `health_facilities`.`id` = '#{self.id}' AND `phone_entries`.`type` IN ('#{activity.name}') AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)"
			self.statistics[activity.name] = detail.find_by_sql("SELECT DATE_FORMAT(start_time, '%b %y') as 'date' #{activity_fields(activity)} #{from_substring}")
		end
	end

	def phone_entries
		self.reporting_birth_death.order("start_time DESC") + self.reporting_child_health.order("start_time DESC") + self.reporting_community_meeting.order("start_time DESC") + self.reporting_facility.order("start_time DESC") + self.reporting_family_planning.order("start_time DESC") + self.reporting_maternal_health.order("start_time DESC") + self.reporting_treatment.order("start_time DESC") 
	end

end
