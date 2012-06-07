module Reportable
attr_accessor :fp_clients_conducted, :fp_clients_expected, :fp_clients_percentage, :maternals_conducted, :maternals_expected, :maternals_percentage,
	:health_houses_conducted, :health_houses_expected, :health_houses_percentage,:support_group_meetings_conducted, :support_group_meetings_expected, :support_group_meetings_percentage, 
	:newborns_conducted, :child_healths_conducted, :special_tasks_conducted, :reporting_birth_deaths_conducted, :reporting_birth_deaths_expected, :reporting_birth_deaths_percentage,
	:reporting_child_healths_conducted, :reporting_child_healths_expected, :reporting_child_healths_percentage, :reporting_family_plannings_conducted, :reporting_family_plannings_expected, :reporting_family_plannings_percentage,
	:reporting_maternal_healths_conducted, :reporting_maternal_healths_expected, :reporting_maternal_healths_percentage, :reporting_treatments_conducted, :reporting_treatments_expected, :reporting_treatments_percentage,
	:reporting_community_meetings_conducted, :reporting_community_meetings_expected, :reporting_community_meetings_percentage, :reporting_facilities_conducted, :reporting_facilities_expected, :reporting_facilities_percentage,
	:monitoring_conducted,:monitoring_expected, :monitoring_percentage, :reporting_conducted,:reporting_expected, :reporting_percentage, :total_conducted,:total_expected, :total_percentage, :statistics
#attr_accessor_with_default is deprecated :S
	
	def assign_compliance_statistics(collection,activities_conducted=Hash.new(0),units_assigned=Hash.new(0),number_of_months=1)
		for unit in [*collection]
			#monitoring
			unit.fp_clients_conducted = activities_conducted[[unit.id,"FpClient"]]
			unit.fp_clients_expected = units_assigned[unit.id]
			unit.fp_clients_percentage = ((unit.fp_clients_conducted.to_f/unit.fp_clients_expected.to_f)*100).round(1)
			unit.maternals_conducted = activities_conducted[[unit.id,"Maternal"]]
			unit.maternals_expected = units_assigned[unit.id]
			unit.maternals_percentage = ((unit.maternals_conducted.to_f/unit.maternals_expected.to_f)*100).round(1)
			unit.health_houses_conducted = activities_conducted[[unit.id,"HealthHouse"]]
			unit.health_houses_expected = units_assigned[unit.id]
			unit.health_houses_percentage = ((unit.health_houses_conducted.to_f/unit.health_houses_expected.to_f)*100).round(1)
			unit.support_group_meetings_conducted = activities_conducted[[unit.id,"SupportGroupMeeting"]]
			unit.support_group_meetings_expected = units_assigned[unit.id]
			unit.support_group_meetings_percentage = ((unit.support_group_meetings_conducted.to_f/unit.support_group_meetings_expected.to_f)*100).round(1)
			unit.newborns_conducted = activities_conducted[[unit.id,"Newborn"]]
			unit.child_healths_conducted = activities_conducted[[unit.id,"ChildHealth"]]
			unit.special_tasks_conducted = activities_conducted[[unit.id,"SpecialTask"]]
			
			#reporting
			
			if unit.class.name=="Visitor"
				reports_required = unit.reports_required*number_of_months
			else
				reports_required = unit.visitors.submits_reports.count*number_of_months
			end
			
			unit.reporting_birth_deaths_conducted = activities_conducted[[unit.id,"ReportingBirthDeath"]]
			unit.reporting_birth_deaths_expected = reports_required
			unit.reporting_birth_deaths_percentage = ((unit.reporting_birth_deaths_conducted.to_f/unit.reporting_birth_deaths_expected.to_f)*100).round(1)
			unit.reporting_child_healths_conducted = activities_conducted[[unit.id,"ReportingChildHealth"]]
			unit.reporting_child_healths_expected = reports_required
			unit.reporting_child_healths_percentage = ((unit.reporting_child_healths_conducted.to_f/unit.reporting_child_healths_expected.to_f)*100).round(1)
			unit.reporting_family_plannings_conducted = activities_conducted[[unit.id,"ReportingFamilyPlanning"]]
			unit.reporting_family_plannings_expected = reports_required
			unit.reporting_family_plannings_percentage = ((unit.reporting_family_plannings_conducted.to_f/unit.reporting_family_plannings_expected.to_f)*100).round(1)
			unit.reporting_maternal_healths_conducted = activities_conducted[[unit.id,"ReportingMaternalHealth"]]
			unit.reporting_maternal_healths_expected = reports_required
			unit.reporting_maternal_healths_percentage = ((unit.reporting_maternal_healths_conducted.to_f/unit.reporting_maternal_healths_expected.to_f)*100).round(1)
			unit.reporting_treatments_conducted = activities_conducted[[unit.id,"ReportingTreatment"]]
			unit.reporting_treatments_expected = reports_required
			unit.reporting_treatments_percentage = ((unit.reporting_treatments_conducted.to_f/unit.reporting_treatments_expected.to_f)*100).round(1)
			unit.reporting_community_meetings_conducted = activities_conducted[[unit.id,"ReportingCommunityMeeting"]]
			unit.reporting_community_meetings_expected = reports_required
			unit.reporting_community_meetings_percentage = ((unit.reporting_community_meetings_conducted.to_f/unit.reporting_community_meetings_expected.to_f)*100).round(1)
			unit.reporting_facilities_conducted = activities_conducted[[unit.id,"ReportingFacility"]]
			unit.reporting_facilities_expected = reports_required
			unit.reporting_facilities_percentage = ((unit.reporting_facilities_conducted.to_f/unit.reporting_facilities_expected.to_f)*100).round(1)
			
			#totals
			unit.monitoring_conducted = unit.fp_clients_conducted+unit.maternals_conducted + unit.health_houses_conducted + unit.support_group_meetings_conducted
			unit.monitoring_expected = unit.fp_clients_expected+unit.maternals_expected + unit.health_houses_expected + unit.support_group_meetings_expected
			unit.monitoring_percentage = unit.monitoring_expected.zero? ? 0 : ((unit.monitoring_conducted.to_f/unit.monitoring_expected.to_f)*100).round(1)

			unit.reporting_conducted = unit.reporting_birth_deaths_conducted + unit.reporting_child_healths_conducted + unit.reporting_family_plannings_conducted + unit.reporting_maternal_healths_conducted + unit.reporting_treatments_conducted + unit.reporting_facilities_conducted + unit.reporting_community_meetings_conducted
			unit.reporting_expected = unit.reporting_birth_deaths_expected + unit.reporting_child_healths_expected + unit.reporting_family_plannings_expected + unit.reporting_maternal_healths_expected + unit.reporting_treatments_expected + unit.reporting_facilities_expected + unit.reporting_community_meetings_expected
			unit.reporting_percentage = unit.reporting_expected.zero? ? 0 : ((unit.reporting_conducted.to_f/unit.reporting_expected.to_f)*100).round(1) 

			unit.total_conducted = 	unit.monitoring_conducted + unit.reporting_conducted
			unit.total_expected = unit.monitoring_expected + unit.reporting_expected
			unit.total_percentage = unit.total_expected.zero? ? 0 :((unit.total_conducted.to_f/unit.total_expected.to_f)*100).round(1)
		end
	end
	
	def compliance_statistics(end_time)
		self.total_conducted = self.phone_entries.counts_for_compliance.group(" DATE_FORMAT(start_time, '%b %y')").order("start_time ASC").where(:start_time=>(end_time.beginning_of_month-1.year..end_time.end_of_day)).count
		self.total_expected = (self.visitors.sum("units_assigned")*4) + (self.visitors.count*7)
		self.total_percentage = self.total_conducted.each_with_object({}) {|(k, v), h| h[k] = v > self.total_expected ? 100 : ((v.to_f/self.total_expected.to_f)*100).round(1) } 
	end
	
	def assign_indicator_statistics(collection,statistic_records)
		for unit in statistic_records
			instance = collection.find { |instance| instance.name == unit.name }
			unless instance.statistics
				instance.statistics = Hash.new 
			end
			instance.statistics[unit.class.name] = unit
		end
		return collection
	end

	def get_indicator_value(indicator, type="average")
		statistics = self.statistics
		
		if type=="total"
			value = statistics ? self.statistics[indicator.indicator_activity.to_s].try(indicator.call_total_method) : nil
		else
			value = statistics ? self.statistics[indicator.indicator_activity.to_s].try(indicator.call_average_method) : nil
		end
		
		value ? value.to_f : 0
	end
	
	def get_indicator_values(indicator)
		data = Hash.new(0)
		for entry in self.statistics[indicator.indicator_activity.to_s]
			data[entry.date] = entry.try(indicator.call_average_method).to_f
		end
		return data
	end
	
	def activity_fields(activity)
		detail = activity.reflections[:detail].klass
		indicators = activity.indicators2.find_all{|indicator| indicator.indicator_type == "integer" }
		query_string = ""
		for indicator in indicators
			query_string += ", ROUND(AVG(#{detail.table_name}.#{indicator.hook}), 1) as '#{indicator.hook}_average', SUM(#{detail.table_name}.#{indicator.hook}) as '#{indicator.hook}_total'"
		end
		return query_string 
	end

end
