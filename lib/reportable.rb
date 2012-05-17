module Reportable
attr_accessor :assessment_count_total, :students_grade3_total, :students_grade4_total, :students_grade5_total, :teachers_present_total, :tasks_identified_total,
	:students_grade3_average, :students_grade4_average, :students_grade5_average, :teachers_present_average, :tasks_identified_average,
	:mentoring_count_total, :score_indicator1_total, :score_indicator2_total, :score_indicator3_total, :score_indicator4_total,:students_present_total,
	:teachers_present_m_total,:tasks_completed_total,:report_cards_issued_total, :score_indicator1_average, :score_indicator2_average, :score_indicator3_average, :score_indicator4_average,:students_present_average, :teachers_present_m_average,:tasks_completed_average,:report_cards_issued_average,
	:assessments_conducted, :assessments_expected, :assessments_percentage, :mentorings_conducted, :mentorings_expected, :mentorings_percentage,
	:pdpsts_conducted, :pdpsts_expected, :pdpsts_percentage,:pddtes_conducted, :pddtes_expected, :pddtes_percentage, :total_conducted,
	:total_expected, :total_percentage, :adjusted_total_percentage, :location_accuracy, :statistics
#attr_accessor_with_default is deprecated :S
	
	def assign_compliance_statistics(collection,activities_conducted=Hash.new(0),adjusted_activities_conducted=Hash.new(0),schools_assigned=Hash.new(0),number_of_months=1)
		for unit in [*collection]
			unit.assessments_conducted = activities_conducted[[unit.id,"Assessment"]]
			unit.assessments_expected = schools_assigned[unit.id]
			unit.assessments_percentage = ((unit.assessments_conducted.to_f/unit.assessments_expected.to_f)*100).round(1)
			unit.mentorings_conducted = activities_conducted[[unit.id,"Mentoring"]]
			unit.mentorings_expected = schools_assigned[unit.id]
			unit.mentorings_percentage = ((unit.mentorings_conducted.to_f/unit.mentorings_expected.to_f)*100).round(1)
			unit.pdpsts_conducted = activities_conducted[[unit.id,"PdPst"]]
			unit.pdpsts_expected = unit.visitors.count*number_of_months
			unit.pdpsts_percentage = ((unit.pdpsts_conducted.to_f/unit.pdpsts_expected.to_f)*100).round(1)
			unit.pddtes_conducted = activities_conducted[[unit.id,"PdDte"]]
			unit.pddtes_expected = unit.visitors.count*number_of_months
			unit.pddtes_percentage = ((unit.pddtes_conducted.to_f/unit.pddtes_expected.to_f)*100).round(1)
			unit.total_conducted = unit.assessments_conducted+unit.mentorings_conducted + unit.pdpsts_conducted + unit.pddtes_conducted
			unit.total_expected = unit.assessments_expected+unit.mentorings_expected + unit.pdpsts_expected + unit.pddtes_expected
			unit.total_percentage = ((unit.total_conducted.to_f/unit.total_expected.to_f)*100).round(1)
			unit.adjusted_total_percentage = (adjusted_activities_conducted[unit.id].to_f/(unit.total_expected.to_f.nonzero? || 1))*100
			unit.location_accuracy = (adjusted_activities_conducted[unit.id].to_f/(unit.total_conducted.to_f.nonzero? || 1))*100
		end
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

	def get_indicator_value(indicator)
		statistics = self.statistics
		value = statistics ? self.statistics[indicator.indicator_activity.to_s].try(indicator.call_average_method) : nil
		value ? value.to_f.round(1) : 0
	end
end