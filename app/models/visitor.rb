# == Schema Information
#
# Table name: visitors
#
#  id               :integer(4)      not null, primary key
#  device_id        :string(15)      not null
#  name             :string(255)     not null
#  district_id      :integer(4)      not null
#  designation      :string(255)     not null
#  units_assigned :integer(4)      not null
#

class Visitor < ActiveRecord::Base
	include Reportable

	has_many :pd_psts, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :pd_dtes, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :assessments, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :mentorings, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :phone_entries, :primary_key => :device_id, :foreign_key => :device_id 
	belongs_to :district
		
	def assessments_required(number_of_months)
		self.units_assigned*number_of_months
	end
	
	def mentorings_required(number_of_months)
		self.units_assigned*number_of_months
	end
	
	def pdpsts_required(number_of_months)
		number_of_months
	end
	
	def pddtes_required(number_of_months)
		number_of_months
	end
	
	def visitors
		[1]
	end

	def compliance_statistics(end_time)
		self.total_conducted = self.phone_entries.counts_for_compliance.group(" DATE_FORMAT(start_time, '%b %y')").order("start_time ASC").where(:start_time=>(end_time.beginning_of_month-1.year..end_time.end_of_day)).count
		self.total_expected = (self.units_assigned*4) + 7
		self.total_percentage = self.total_conducted.each_with_object({}) {|(k, v), h| h[k] = v > self.total_expected ? 100 : ((v.to_f/self.total_expected.to_f)*100).round(1) } 
	end
	
		
	def indicator_statistics(end_time, activities)
		self.statistics = Hash.new
		
		for activity in activities
			detail = activity.reflections[:detail].klass			
			from_substring = "FROM `visitors` LEFT OUTER JOIN `phone_entries` ON `phone_entries`.`device_id` = `visitors`.`device_id` AND `phone_entries`.`type` IN ('#{activity.name}') INNER JOIN `#{detail.table_name}` ON `phone_entries`.`id` = `#{detail.table_name}`.`#{activity.reflections[:detail].foreign_key}` WHERE `visitors`.`id` = '#{self.id}' AND (`phone_entries`.`start_time` >= '2012-01-01 00:00:00') Group BY MONTH(start_time)"
			self.statistics[activity.name] = detail.find_by_sql("SELECT DATE_FORMAT(start_time, '%b %y') as 'date' #{activity_fields(activity)} #{from_substring}")
		end
	end
	
end
