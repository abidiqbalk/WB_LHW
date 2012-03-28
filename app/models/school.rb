class School < ActiveRecord::Base
	include Reportable

	belongs_to :district, :primary_key => :district_id, :dependent => :destroy
	belongs_to :cluster
	belongs_to :tehsil, :primary_key => :tehsil_id, :dependent => :destroy
	belongs_to :markaz, :primary_key => :markaz_id, :dependent => :destroy
	belongs_to :school_location, :foreign_key => :school_location
	
	has_many :assessment_details, :foreign_key => :emis_code, :primary_key =>:emiscode, :include => :assessment
	has_many :assessments, :through => :assessment_details
	has_many :mentoring_details, :foreign_key => :emis_code, :primary_key =>:emiscode, :include => :mentoring
	has_many :mentorings, :through => :mentoring_details
	scope :mapped, where("latitude > 0")
	
	alias_attribute :name, :school_name # need this to expose common interface to reporting modules
	
	acts_as_gmappable
	
	def assessment_statistics(*args) # returns cluster's school average from start_time to end_time
		if args.size < 2
			School.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `schools` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `schools`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			School.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `schools` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `schools`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end
	
	def mentoring_statistics(*args) # returns cluster's school average from start_time to end_time
		if args.size < 2
			School.find_by_sql("SELECT start_time as 'date_c', AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `schools` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `schools`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			School.find_by_sql("SELECT start_time as 'date_c', AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `schools` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `schools`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end
	
	def gmaps4rails_infowindow
		"#{self.school_name}"
    end
end
