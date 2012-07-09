=begin
Defines a Province and all the methods required to gather associated statistics 

#Schema Information
    Table name: provinces
    id         :integer(4)      not null, primary key
    name       :string(255)
    slug       :string(255)
    created_at :datetime        not null
    updated_at :datetime        not null
=end

class Province < ActiveRecord::Base
	include Reportable

	has_many :districts
	has_many :visitors, :through => :districts
	has_many :phone_entries, :through => :visitors

	extend FriendlyId
	friendly_id :name, use: :slugged
	
	def indicator_statistics(end_time, activities)
		self.statistics = Hash.new
		
		for activity in activities
			detail = activity.reflections[:detail].klass
			from_substring = "FROM `#{detail.table_name}` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `#{detail.table_name}`.`#{activity.reflections[:detail].foreign_key}` AND `phone_entries`.`type` IN ('#{activity.name}') WHERE (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)"
			self.statistics[activity.name] = detail.find_by_sql("SELECT DATE_FORMAT(start_time, '%b %y') as 'date' #{activity_fields(activity)} #{from_substring}")
		end
		
	end
		
	def districts_with_indicator_statistics(start_time,end_time,districts,activities) #returns stats on individual districts of a province 
		for activity in activities
			detail = activity.reflections[:detail].klass
			from_substring = "FROM `districts` INNER JOIN `visitors` ON `visitors`.`district_id` = `districts`.`id` LEFT OUTER JOIN `phone_entries` ON `phone_entries`.`device_id` = `visitors`.`device_id` AND `phone_entries`.`type` IN ('#{activity.name}') INNER JOIN `#{detail.table_name}` ON `phone_entries`.`id` = `#{detail.table_name}`.`#{activity.reflections[:detail].foreign_key}` WHERE `districts`.`id` IN (#{districts.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY districts.id"
			records = activity.find_by_sql("SELECT districts.district_name as 'name', Count(*) as 'count_total' #{activity_fields(activity)} #{from_substring}")
			assign_indicator_statistics(districts,records)
		end	
	end
	
=begin
Returns the expected entry counts for every district in a single query
@param [Integer] number_of_months number of months we need expected entries for. 
@return [Hash of expected entry counts with district id as key] The entry counts for a given District and entry type
=end	

	def expected_activity_statistics(number_of_months)
		units_assigned = Hash.new(0).merge(self.visitors.group("districts.id").sum("units_assigned"))
		units_assigned.each{ |key,val| units_assigned[key] = val*number_of_months }
	end
		
	def districts_with_compliance_statistics(start_time,end_time,number_of_months,districts) #returns stats on individual districts of a province
		activities_conducted = Hash.new(0).merge(self.phone_entries.group(["districts.id", :type]).where(:start_time=>(start_time..end_time.end_of_day)).count)
		units_assigned = self.expected_activity_statistics(number_of_months)
		
		assign_compliance_statistics(districts,activities_conducted,units_assigned,number_of_months)
		
		return districts
	end		

=begin
Returns stats on the individual districts of a province
@param [DateTime] start_time entries will be picked up for calculations if their start time is past this datetime. 
@param [DateTime] end_time entries will be picked up for calculations if their start time is before this datetime. 
@param [Array of district Objects] districts to which the calculated statistics will be attached via the build_statistics method defined in the PhoneEntry classes
@return [Array of district Objects] The districts with attached statistics 
@note Currently set to work only on Hafizabad and Okara
=end
	def self.districts_with_assessment_statistics(start_time,end_time,districts) #returns stats on individual districts of a province
		# I used active record explain to build the query and then customized it to aggergate multiple columns which is currently not featured as of writing
		assessment_records = District.find_by_sql("SELECT districts.district_name, districts.slug, Count(*) as 'assessment_count_total_c', SUM(assessment_details.average_monthly_consumption) as 'average_monthly_consumption_total_c', SUM(assessment_details.students_grade4) as 'students_grade4_total_c',SUM(assessment_details.students_grade5) as 'students_grade5_total_c', SUM(assessment_details.teachers_present) as 'teachers_present_total_c', SUM(assessment_details.tasks_identified) as 'tasks_identified_total_c', ROUND(AVG(assessment_details.average_monthly_consumption) as 'average_monthly_consumption_average_c', ROUND(AVG(assessment_details.students_grade4) as 'students_grade4_average_c',ROUND(AVG(assessment_details.students_grade5) as 'students_grade5_average_c', ROUND(AVG(assessment_details.teachers_present) as 'teachers_present_average_c', ROUND(AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `districts`.`id` IN (#{districts.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY districts.district_name")
		
		Assessment.build_statistics(assessment_records,districts)
		return districts
	end	

=begin
(see #districts_with_assessment_statistics)
=end		
	def self.districts_with_mentoring_statistics(start_time,end_time,districts) #returns stats on individual districts of a province
		mentoring_records = District.find_by_sql("SELECT districts.district_name, districts.slug, Count(*) as 'mentoring_count_total_c', SUM(mentoring_details.score_indicator1) as 'score_indicator1_total_c', SUM(mentoring_details.score_indicator2) as 'score_indicator2_total_c', SUM(mentoring_details.score_indicator3) as 'score_indicator3_total_c', SUM(mentoring_details.score_indicator4) as 'score_indicator4_total_c', SUM(mentoring_details.students_present) as 'students_present_total_c', SUM(mentoring_details.report_cards_issued) as 'report_cards_issued_total_c', SUM(mentoring_details.tasks_completed) as 'tasks_completed_total_c', SUM(mentoring_details.teachers_present) as 'teachers_present_total_m_c', ROUND(AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', ROUND(AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', ROUND(AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', ROUND(AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', ROUND(AVG(mentoring_details.students_present) as 'students_present_average_c', ROUND(AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', ROUND(AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', ROUND(AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `districts`.`id` IN (#{districts.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY districts.district_name")
		
		Mentoring.build_statistics(mentoring_records,districts)
		return districts
	end	

=begin
Returns stats on the Province itself. Pass no args to get month-wise results. 
@param [DateTime] start_time (optional) entries will be picked up for calculations if their start time is past this datetime. 
@param [DateTime] end_time (optional) entries will be picked up for calculations if their start time is before this datetime. 
@return [Province] Province statistics suitable to build Indicator objects with 
=end
	def self.assessment_statistics(*args) #Returns Province statistics from start_time to end_time or grouped by month
		if args.size < 2
			District.find_by_sql("SELECT start_time as 'date_c',ROUND(AVG(assessment_details.average_monthly_consumption) as 'average_monthly_consumption_average_c', ROUND(AVG(assessment_details.students_grade4) as 'students_grade4_average_c',ROUND(AVG(assessment_details.students_grade5) as 'students_grade5_average_c', ROUND(AVG(assessment_details.teachers_present) as 'teachers_present_average_c', ROUND(AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `assessment_details` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			District.find_by_sql("SELECT start_time as 'date_c',ROUND(AVG(assessment_details.average_monthly_consumption) as 'average_monthly_consumption_average_c', ROUND(AVG(assessment_details.students_grade4) as 'students_grade4_average_c',ROUND(AVG(assessment_details.students_grade5) as 'students_grade5_average_c', ROUND(AVG(assessment_details.teachers_present) as 'teachers_present_average_c', ROUND(AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `assessment_details` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE  (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end

=begin
(see #assessment_statistics)
=end
	def self.mentoring_statistics(*args) #Returns Province statistics from start_time to end_time
		if args.size < 2
			District.find_by_sql("SELECT start_time as 'date_c',ROUND(AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', ROUND(AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', ROUND(AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', ROUND(AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', ROUND(AVG(mentoring_details.students_present) as 'students_present_average_c', ROUND(AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', ROUND(AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', ROUND(AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `mentoring_details` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE  (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			District.find_by_sql("SELECT start_time as 'date_c',ROUND(AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', ROUND(AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', ROUND(AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', ROUND(AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', ROUND(AVG(mentoring_details.students_present) as 'students_present_average_c', ROUND(AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', ROUND(AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', ROUND(AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `mentoring_details` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end

end
