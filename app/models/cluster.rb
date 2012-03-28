class Cluster < ActiveRecord::Base
	include Reportable

	has_many :schools
	belongs_to :district
	has_many :assessment_details, :through => :schools
	has_many :mentoring_details, :through => :schools
	
	alias_attribute :name, :school_name # need this to expose common interface to reporting modules
	
	def schools_with_statistics(start_time,end_time, schools) #returns stats on individual schools of a cluster

		assessment_records = Cluster.find_by_sql("SELECT schools.school_name, schools.id, Count(*) as 'assessment_count_total_c', SUM(assessment_details.students_grade3) as 'students_grade3_total_c', SUM(assessment_details.students_grade4) as 'students_grade4_total_c',SUM(assessment_details.students_grade5) as 'students_grade5_total_c', SUM(assessment_details.teachers_present) as 'teachers_present_total_c', SUM(assessment_details.tasks_identified) as 'tasks_identified_total_c', AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `schools` INNER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `schools`.`id` IN (#{schools.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY schools.school_name")
		
		Assessment.build_statistics(assessment_records,schools)
		
		mentoring_records = Cluster.find_by_sql("SELECT schools.school_name, schools.id, Count(*) as 'mentoring_count_total_c', SUM(mentoring_details.score_indicator1) as 'score_indicator1_total_c', SUM(mentoring_details.score_indicator2) as 'score_indicator2_total_c', SUM(mentoring_details.score_indicator3) as 'score_indicator3_total_c', SUM(mentoring_details.score_indicator4) as 'score_indicator4_total_c', SUM(mentoring_details.students_present) as 'students_present_total_c', SUM(mentoring_details.report_cards_issued) as 'report_cards_issued_total_c', SUM(mentoring_details.tasks_completed) as 'tasks_completed_total_c', SUM(mentoring_details.teachers_present) as 'teachers_present_total_m_c', AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `schools` INNER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `schools`.`id` IN (#{schools.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY schools.school_name")
		
		Mentoring.build_statistics(mentoring_records,schools)
		
		return schools
	end

	def assessment_statistics(*args) # returns cluster's school average from start_time to end_time
		if args.size < 2
			Cluster.find_by_sql("SELECT start_time as 'date_c', AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `clusters`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `clusters`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end
	
	def mentoring_statistics(*args) # returns cluster's school average from start_time to end_time
		if args.size < 2
			Cluster.find_by_sql("SELECT start_time as 'date_c', AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `clusters`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c'FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `clusters`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end

end
