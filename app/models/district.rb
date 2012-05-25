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

	def compliance_statistics(end_time)
		self.total_conducted = self.phone_entries.group(" DATE_FORMAT(start_time, '%b %y')").order("start_time ASC").where(:start_time=>(end_time.beginning_of_month-1.year..end_time.end_of_day)).count
		self.total_expected = self.visitors.sum("schools_assigned")*2 + self.visitors.count
		self.total_percentage = self.total_conducted.each_with_object({}) {|(k, v), h| h[k] = v > self.total_expected ? 100 : ((v.to_f/self.total_expected.to_f)*100).round(1) } 
	end
	
	def indicator_statistics(end_time)
		self.statistics = Hash.new
		self.statistics["Assessment"] = AssessmentDetail.find_by_sql("SELECT DATE_FORMAT(start_time, '%b %y') as 'date', ROUND(AVG(assessment_details.students_grade3), 1) as 'students_grade3_average', ROUND(AVG(assessment_details.students_grade4),1) as 'students_grade4_average',ROUND(AVG(assessment_details.students_grade5),1) as 'students_grade5_average', ROUND(AVG(assessment_details.teachers_present),1) as 'teachers_present_average', ROUND(AVG(assessment_details.tasks_identified),1) as 'tasks_identified_average' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `districts`.`district_name` = '#{self.name}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		self.statistics["Mentoring"] = 	MentoringDetail.find_by_sql("SELECT DATE_FORMAT(start_time, '%b %y') as 'date',ROUND(AVG(mentoring_details.score_indicator1),1) as 'score_indicator1_average', ROUND(AVG(mentoring_details.score_indicator2),1) as 'score_indicator2_average', ROUND(AVG(mentoring_details.score_indicator3),1) as 'score_indicator3_average', ROUND(AVG(mentoring_details.score_indicator4),1) as 'score_indicator4_average', ROUND(AVG(mentoring_details.students_present),1) as 'students_present_average', ROUND(AVG(mentoring_details.report_cards_issued),1) as 'report_cards_issued_average', ROUND(AVG(mentoring_details.tasks_completed),1) as 'tasks_completed_average', ROUND(AVG(mentoring_details.teachers_present),1) as 'teachers_present_average' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `districts`.`district_name` = '#{self.name}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
	end
	
	def clusters_with_indicator_statistics(start_time,end_time,clusters) #returns stats on individual clusters of a district 
		assessment_records = Assessment.find_by_sql("SELECT clusters.school_name as 'name', Count(*) as 'assessment_count_total', SUM(assessment_details.students_grade3) as 'students_grade3_total', SUM(assessment_details.students_grade4) as 'students_grade4_total',SUM(assessment_details.students_grade5) as 'students_grade5_total', SUM(assessment_details.teachers_present) as 'teachers_present_total', SUM(assessment_details.tasks_identified) as 'tasks_identified_total', ROUND(AVG(assessment_details.students_grade3),1) as 'students_grade3_average', ROUND(AVG(assessment_details.students_grade4),1) as 'students_grade4_average',ROUND(AVG(assessment_details.students_grade5),1) as 'students_grade5_average', ROUND(AVG(assessment_details.teachers_present),1) as 'teachers_present_average', ROUND(AVG(assessment_details.tasks_identified),1) as 'tasks_identified_average' FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `clusters`.`id` IN (#{clusters.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY clusters.school_name")
		assign_indicator_statistics(clusters,assessment_records)
		
		mentoring_records = Mentoring.find_by_sql("SELECT clusters.school_name as 'name', Count(*) as 'mentoring_count_total', SUM(mentoring_details.score_indicator1) as 'score_indicator1_total', SUM(mentoring_details.score_indicator2) as 'score_indicator2_total', SUM(mentoring_details.score_indicator3) as 'score_indicator3_total', SUM(mentoring_details.score_indicator4) as 'score_indicator4_total', SUM(mentoring_details.students_present) as 'students_present_total', SUM(mentoring_details.report_cards_issued) as 'report_cards_issued_total', SUM(mentoring_details.tasks_completed) as 'tasks_completed_total', SUM(mentoring_details.teachers_present) as 'teachers_present_total', ROUND(AVG(mentoring_details.score_indicator1),1) as 'score_indicator1_average', ROUND(AVG(mentoring_details.score_indicator2),1) as 'score_indicator2_average', ROUND(AVG(mentoring_details.score_indicator3),1) as 'score_indicator3_average', ROUND(AVG(mentoring_details.score_indicator4),1) as 'score_indicator4_average', ROUND(AVG(mentoring_details.students_present),1) as 'students_present_average', ROUND(AVG(mentoring_details.report_cards_issued),1) as 'report_cards_issued_average', ROUND(AVG(mentoring_details.tasks_completed),1) as 'tasks_completed_average', ROUND(AVG(mentoring_details.teachers_present),1) as 'teachers_present_average' FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `mentoring_details` ON `mentoring_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `mentoring_details`.`mentoring_id` AND `phone_entries`.`type` IN ('Mentoring') WHERE `clusters`.`id` IN (#{clusters.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY clusters.school_name")
		assign_indicator_statistics(clusters,mentoring_records)		
	end

=begin
Returns the expected entry counts for every district in a single query
@param [Integer] number_of_months number of months we need expected entries for. 
@return [Hash of expected entry counts with district id as key] The entry counts for a given District and entry type
=end	

	def expected_activity_statistics(number_of_months)
		schools_assigned = Hash.new(0).merge(self.visitors.group("visitors.id").sum("schools_assigned"))
		schools_assigned.each{ |key,val| schools_assigned[key] = val*number_of_months }
	end
		
	def officers_with_compliance_statistics(start_time,end_time,number_of_months,districts) #returns stats on individual officers of a district
		activities_conducted = Hash.new(0).merge(self.phone_entries.group(["visitors.id", :type]).where(:start_time=>(start_time..end_time.end_of_day)).count)
		schools_assigned = self.expected_activity_statistics(number_of_months)
		
		assign_compliance_statistics(districts,activities_conducted,schools_assigned,number_of_months)
		
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
		assessment_records = Cluster.find_by_sql("SELECT clusters.school_name, clusters.id, Count(*) as 'assessment_count_total_c', SUM(assessment_details.students_grade3) as 'students_grade3_total_c', SUM(assessment_details.students_grade4) as 'students_grade4_total_c',SUM(assessment_details.students_grade5) as 'students_grade5_total_c', SUM(assessment_details.teachers_present) as 'teachers_present_total_c', SUM(assessment_details.tasks_identified) as 'tasks_identified_total_c', AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `clusters` INNER JOIN `schools` ON `schools`.`cluster_id` = `clusters`.`id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `clusters`.`id` IN (#{clusters.map(&:id).join(",")}) AND (`phone_entries`.`start_time` BETWEEN '#{start_time}' AND '#{end_time}') Group BY clusters.school_name")
		
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
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `districts`.`district_name` = '#{self.district_name}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)")
		else
			Cluster.find_by_sql("SELECT start_time as 'date_c',AVG(assessment_details.students_grade3) as 'students_grade3_average_c', AVG(assessment_details.students_grade4) as 'students_grade4_average_c',AVG(assessment_details.students_grade5) as 'students_grade5_average_c', AVG(assessment_details.teachers_present) as 'teachers_present_average_c', AVG(assessment_details.tasks_identified) as 'tasks_identified_average_c' FROM `districts` INNER JOIN `schools` ON `schools`.`district_id` = `districts`.`district_id` LEFT OUTER JOIN `assessment_details` ON `assessment_details`.`emis_code` = `schools`.`emiscode` INNER JOIN `phone_entries` ON `phone_entries`.`id` = `assessment_details`.`assessment_id` AND `phone_entries`.`type` IN ('Assessment') WHERE `districts`.`district_name` = '#{self.district_name}' AND (`phone_entries`.`start_time` BETWEEN '#{args[0]}' AND '#{args[1]}')")
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
