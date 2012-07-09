=begin
Defines a District and all the methods required to gather associated statistics 

#Schema Information
    Table name: districts
    id             :integer(4)      not null, primary key
    district_id    :string(3)       default(""), not null
    province_id    :integer(4)      not null
    district_name  :string(20)
    district_short :string(3)
    active         :string(1)
    pop_flag       :string(1)
    stipend        :string(1)
    division_id    :string(2)
    slug           :string(255)
    boundaries     :text(2147483647 default(""), not null
=end

class District < ActiveRecord::Base
	include Reportable
	
	belongs_to :province
	has_many :health_facilities
	has_many :visitors 
	has_many :phone_entries, :through => :visitors
	has_many :district_boundary_points
	has_and_belongs_to_many :users	
	
	
	alias_attribute :name, :district_name # need this to expose common interface to reporting modules


	extend FriendlyId
	friendly_id :district_name, use: :slugged

	# District Stats
	
=begin
Returns the entry counts of each type of PhoneEntry possible for every visitor in a single query
@param [DateTime] start_time entries will be picked up for calculations if their start time is past this datetime. 
@param [DateTime] end_time entries will be picked up for calculations if their start time is before this datetime. 
@return [Hash of entry counts with visitor id and entry type as key] The entry counts for a given visitor and entry type
=end

	
	def indicator_statistics_for_visitors(end_time, activities)
		
		self.statistics = Hash.new
		
		for activity in activities
			detail = activity.reflections[:detail].klass			
			from_substring = "FROM `districts` INNER JOIN `visitors` ON `visitors`.`district_id` = `districts`.`id` LEFT OUTER JOIN `phone_entries` ON `phone_entries`.`device_id` = `visitors`.`device_id` AND `phone_entries`.`type` IN ('#{activity.name}') INNER JOIN `#{detail.table_name}` ON `phone_entries`.`id` = `#{detail.table_name}`.`#{activity.reflections[:detail].foreign_key}` WHERE `districts`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)"
			self.statistics[activity.name] = detail.find_by_sql("SELECT DATE_FORMAT(start_time, '%b %y') as 'date' #{activity_fields(activity)} #{from_substring}")
		end
		
	end
	
	def indicator_statistics_for_facilities(end_time, activities)
		
	self.statistics = Hash.new

		for activity in activities
			detail = activity.reflections[:detail].klass			
			from_substring = "FROM `districts` INNER JOIN `visitors` ON `visitors`.`district_id` = `districts`.`id` LEFT OUTER JOIN `phone_entries` ON `phone_entries`.`device_id` = `visitors`.`device_id` AND `phone_entries`.`type` IN ('#{activity.name}') INNER JOIN `#{detail.table_name}` ON `phone_entries`.`id` = `#{detail.table_name}`.`#{activity.reflections[:detail].foreign_key}` WHERE `districts`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)"
			self.statistics[activity.name] = detail.find_by_sql("SELECT DATE_FORMAT(start_time, '%b %y') as 'date' #{activity_fields(activity)} #{from_substring}")
		end
		
	end
	
	def visitors_with_indicator_statistics(start_time,end_time,visitors,activities) #returns stats on individual visitors of a district 
		for activity in activities
			detail = activity.reflections[:detail].klass
			from_substring = "FROM `visitors` LEFT OUTER JOIN `phone_entries` ON `phone_entries`.`device_id` = `visitors`.`device_id` AND `phone_entries`.`type` IN ('#{activity.name}') INNER JOIN `#{detail.table_name}` ON `phone_entries`.`id` = `#{detail.table_name}`.`#{activity.reflections[:detail].foreign_key}` WHERE `visitors`.`id` IN (#{visitors.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY visitors.id"
			records = activity.find_by_sql("SELECT visitors.name as 'name', Count(*) as 'count_total' #{activity_fields(activity)} #{from_substring}")
			assign_indicator_statistics(visitors,records)
		end	
		
	end

	def facilities_with_indicator_statistics(start_time,end_time,facilities,activities) #returns stats on individual facilities of a district 
		
		for activity in activities
			detail = activity.reflections[:detail].klass
			from_substring = "FROM `districts` INNER JOIN `health_facilities` ON `health_facilities`.`district_id` = `districts`.`id` LEFT OUTER JOIN `#{detail.table_name}` ON `#{detail.table_name}`.`facility_code` = `health_facilities`.`facility_code` LEFT OUTER JOIN `phone_entries` ON `phone_entries`.`id` = `#{detail.table_name}`.`#{activity.reflections[:detail].foreign_key}` WHERE `phone_entries`.`type` IN ('#{activity.name}') AND `health_facilities`.`id` IN (#{health_facilities.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY health_facilities.id"
			records = activity.find_by_sql("SELECT health_facilities.name as 'name', Count(*) as 'count_total' #{activity_fields(activity)} #{from_substring}")
			assign_indicator_statistics(facilities,records)
		end	
		
	end
	
=begin
Returns the expected entry counts for every district in a single query
@param [Integer] number_of_months number of months we need expected entries for. 
@return [Hash of expected entry counts with district id as key] The entry counts for a given District and entry type
=end	

	def expected_activity_statistics(number_of_months)
		units_assigned = Hash.new(0).merge(self.visitors.group("visitors.id").sum("units_assigned"))
		units_assigned.each{ |key,val| units_assigned[key] = val*number_of_months }
	end
		
	def officers_with_compliance_statistics(start_time,end_time,number_of_months,districts) #returns stats on individual officers of a district
		activities_conducted = Hash.new(0).merge(self.phone_entries.group(["visitors.id", :type]).where(:start_time=>(start_time..end_time.end_of_day)).count)
		units_assigned = self.expected_activity_statistics(number_of_months)
		assign_compliance_statistics(districts,activities_conducted,units_assigned,number_of_months)
		
		return districts
	end		
=begin
Returns stats on the individual clusters of a district
@param [DateTime] start_time entries will be picked up for calculations if their start time is past this datetime. 
@param [DateTime] end_time entries will be picked up for calculations if their start time is before this datetime. 
@param [Array of Cluster Objects] clusters to which the calculated statistics will be attached via the build_statistics method defined in the PhoneEntry classes
@return [Array of Cluster Objects] The clusters with attached statistics 
=end
	def clusters_with_assessment_statistics(start_time,end_time, clusters) 
		# It turned out to be 10x faster to fetch clusters and look them up directly rather than fetching them via district join.
		assessment_records = Cluster.find_by_sql("SELECT clusters.school_name, clusters.id, Count(*) as 'assessment_count_total_c', SUM(assessment_details.average_monthly_consumption) as 'average_monthly_consumption_total_c', SUM(assessment_details.students_grade4) as 'students_grade4_total_c',SUM(assessment_details.students_grade5) as 'students_grade5_total_c', SUM(assessment_details.teachers_present) as 'teachers_present_total_c', SUM(assessment_details.tasks_identified) as 'tasks_identified_total_c', AVG(assessment_details.average_monthly_consumption) as 'average_monthly_consumption_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `clusters`.`id` IN (#{clusters.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY clusters.school_name")
		
		Assessment.build_statistics(assessment_records,clusters)
		
		return clusters
	end
	
=begin
(see #clusters_with_assessment_statistics)
=end	
	def clusters_with_mentoring_statistics(start_time,end_time, clusters) #returns stats on individual clusters of a district
		mentoring_records = Cluster.find_by_sql("SELECT clusters.school_name, clusters.id, Count(*) as 'mentoring_count_total_c', SUM(mentoring_details.score_indicator1) as 'score_indicator1_total_c', SUM(mentoring_details.score_indicator2) as 'score_indicator2_total_c', SUM(mentoring_details.score_indicator3) as 'score_indicator3_total_c', SUM(mentoring_details.score_indicator4) as 'score_indicator4_total_c', SUM(mentoring_details.students_present) as 'students_present_total_c', SUM(mentoring_details.report_cards_issued) as 'report_cards_issued_total_c', SUM(mentoring_details.tasks_completed) as 'tasks_completed_total_c', SUM(mentoring_details.teachers_present) as 'teachers_present_total_m_c', AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `clusters`.`id` IN (#{clusters.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY clusters.school_name")
		
		Mentoring.build_statistics(mentoring_records,clusters)
		
		return clusters
	end

=begin
Returns stats on the district itself. Pass no args to get month-wise results. 
@param [DateTime] start_time (optional) entries will be picked up for calculations if their start time is past this datetime. 
@param [DateTime] end_time (optional) entries will be picked up for calculations if their start time is before this datetime. 
@return [District] District statistics suitable to build Indicator objects with 
=end
	def assessment_statistics(*args) # returns district's cluster average from start_time to end_time
		if args.size < 2
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.average_monthly_consumption) as 'average_monthly_consumption_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `districts`.`district_name` = '#{self.district_name}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.average_monthly_consumption) as 'average_monthly_consumption_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `districts`.`district_name` = '#{self.district_name}' AND (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end
=begin
(see #assessment_statistics)
=end
	def mentoring_statistics(*args) # returns district's cluster average from start_time to end_time
		if args.size < 2
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `districts`.`district_name` = '#{self.district_name}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(mentoring_details.score_indicator1) as 'score_indicator1_average_c', AVG(mentoring_details.score_indicator2) as 'score_indicator2_average_c', AVG(mentoring_details.score_indicator3) as 'score_indicator3_average_c', AVG(mentoring_details.score_indicator4) as 'score_indicator4_average_c', AVG(mentoring_details.students_present) as 'students_present_average_c', AVG(mentoring_details.report_cards_issued) as 'report_cards_issued_average_c', AVG(mentoring_details.tasks_completed) as 'tasks_completed_average_c', AVG(mentoring_details.teachers_present) as 'teachers_present_m_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `districts`.`district_name` = '#{self.district_name}' AND (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
		end
	end

=begin
returns the set of points that comprise the boundary polygon of a district. Useful for maps.
@return [Array of DistrictBoundaryPoints] set of boundary points making up the district polygon
=end
	def boundary
		boundary_polygon = []
		for point in self.district_boundary_points.order("id")
			boundary_polygon << { :lng => point.longitude, :lat => point.latitude}
		end
		return boundary_polygon
	end

=begin
returns the set of boundary polygons un json format for a set of districts. Useful for maps.
@param [collection of District objects] districts set of districts whose polygon is required. 
@return [Json of DistrictBoundaryPoints] json of polygons making up the district boundaries
@todo refactor to Province.rb
=end
	def self.get_boundaries(districts)
		boundaries = []
		[*districts].each do |district|
			boundaries << district.boundary
		end
		boundaries.to_json
	end
	
	
	
=begin	Compute district boundary points from longtext blob
	def self.get_boundaries
	districts = District.all
	for district in districts
		points = district.boundaries.split(" ")
		for point in points
			point_data = point.split(",")
			DistrictBoundaryPoint.create(:district_id => district.id, :longitude => point_data[0], :latitude => point_data[1],:altitude => point_data[2])
		end
	end
	
	end
=end
end
