class District < ActiveRecord::Base
	include Reportable
	
	has_many :schools, :primary_key => "district_id", :dependent => :destroy
	has_many :visitors 
	has_many :clusters
	has_many :assessments, :through => :visitors, :include => :detail
	has_many :mentorings, :through => :visitors 
	has_many :pd_dtes, :through => :visitors 
	has_many :pd_psts, :through => :visitors 
	has_many :phone_entries, :through => :visitors
	has_many :assessment_details, :through => :schools
	has_many :mentoring_details, :through => :schools
	has_and_belongs_to_many :users	
	
	
	alias_attribute :name, :district_name # need this to expose common interface to reporting modules


	extend FriendlyId
	friendly_id :district_name, use: :slugged

	# District Stats
	
	def clusters_with_statistics(start_time,end_time, clusters) #returns stats on individual clusters of a district

		# It turned out to be 10x faster to fetch clusters and look them up directly rather than fetching them via district join.
		assessment_records = Cluster.find_by_sql("SELECT clusters.school_name, clusters.id, Count(*) as 'assessment_count_total_c', SUM(assessment_details.students_grade3) as 'students_grade3_total_c', SUM(assessment_details.students_grade4) as 'students_grade4_total_c',SUM(assessment_details.students_grade5) as 'students_grade5_total_c', SUM(assessment_details.teachers_present) as 'teachers_present_total_c', SUM(assessment_details.tasks_identified) as 'tasks_identified_total_c', AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `clusters`.`id` IN (#{clusters.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY clusters.school_name")
		
		Assessment.build_statistics(assessment_records,clusters)
		
		mentoring_records = Cluster.find_by_sql("SELECT clusters.school_name, clusters.id, Count(*) as 'mentoring_count_total_c', SUM(mentoring_details.score_indicator1) as 'score_indicator1_total_c', SUM(mentoring_details.score_indicator2) as 'score_indicator2_total_c', SUM(mentoring_details.score_indicator3) as 'score_indicator3_total_c', SUM(mentoring_details.score_indicator4) as 'score_indicator4_total_c', SUM(mentoring_details.students_present) as 'students_present_total_c', SUM(mentoring_details.report_cards_issued) as 'report_cards_issued_total_c', SUM(mentoring_details.tasks_completed) as 'tasks_completed_total_c', SUM(mentoring_details.teachers_present) as 'teachers_present_total_m_c', AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `clusters`.`id` IN (#{clusters.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY clusters.school_name")
		
		Mentoring.build_statistics(mentoring_records,clusters)
		
		return clusters
	end
	
	def assessment_statistics(*args) # returns district's cluster average from start_time to end_time
		if args.size < 2
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `districts`.`district_name` = '#{self.district_name}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `districts`.`district_name` = '#{self.district_name}' AND (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end
	
	def mentoring_statistics(*args) # returns district's cluster average from start_time to end_time
		if args.size < 2
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `districts`.`district_name` = '#{self.district_name}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `districts`.`district_name` = '#{self.district_name}' AND (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end
	# Overall Stats

	def self.districts_with_statistics(start_time,end_time,districts) #returns stats on individual districts of a province
		# I used active record explain to build the query and then customized it to aggergate multiple columns which is currently not featured as of writing
		assessment_records = District.find_by_sql("SELECT districts.district_name, districts.slug, Count(*) as 'assessment_count_total_c', SUM(assessment_details.students_grade3) as 'students_grade3_total_c', SUM(assessment_details.students_grade4) as 'students_grade4_total_c',SUM(assessment_details.students_grade5) as 'students_grade5_total_c', SUM(assessment_details.teachers_present) as 'teachers_present_total_c', SUM(assessment_details.tasks_identified) as 'tasks_identified_total_c', AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `districts`.`id` IN (#{districts.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY districts.district_name")
		
		Assessment.build_statistics(assessment_records,districts)
		
		mentoring_records = District.find_by_sql("SELECT districts.district_name, districts.slug, Count(*) as 'mentoring_count_total_c', SUM(mentoring_details.score_indicator1) as 'score_indicator1_total_c', SUM(mentoring_details.score_indicator2) as 'score_indicator2_total_c', SUM(mentoring_details.score_indicator3) as 'score_indicator3_total_c', SUM(mentoring_details.score_indicator4) as 'score_indicator4_total_c', SUM(mentoring_details.students_present) as 'students_present_total_c', SUM(mentoring_details.report_cards_issued) as 'report_cards_issued_total_c', SUM(mentoring_details.tasks_completed) as 'tasks_completed_total_c', SUM(mentoring_details.teachers_present) as 'teachers_present_total_m_c', AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `districts`.`id` IN (#{districts.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY districts.district_name")
		Mentoring.build_statistics(mentoring_records,districts)
		return districts
	end	
	
	def self.assessment_statistics(*args) #Returns Province statistics from start_time to end_time or grouped by month
		if args.size < 2
			District.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `assessment_details` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			District.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `assessment_details` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE  (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end
	
	def self.mentoring_statistics(*args) #Returns Province statistics from start_time to end_time
		if args.size < 2
			District.find_by_sql("SELECT start_time as 'date_c',AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `mentoring_details` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE  (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			District.find_by_sql("SELECT start_time as 'date_c',AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `mentoring_details` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end
	
end
