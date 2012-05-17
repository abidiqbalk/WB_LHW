class ClustersController < ApplicationController

	def school_report
		@cluster = Cluster.find(params[:id])
		unless @cluster.nil?	
			@district = @cluster.district
			@school_sets = @cluster.schools.each_slice(15)
			authorize! :view_school_reports, @district
		else
			flash[:error] = "The specified cluster does not exist."
			redirect_to root_path
		end
	end

	def assessments_report
		if params[:time_filter].nil?
			@cluster = Cluster.find(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else 
			@cluster = Cluster.find(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])

			@end_time = @start_time.end_of_month

		end	
				
		unless @cluster.nil?	
			@district = @cluster.district
			authorize! :view_school_reports, @district
			@schools = @cluster.schools_with_assessment_statistics(@start_time,@end_time,@cluster.schools.order("school_name ASC"))
			@assessment_indicators = Assessment.indicators([@cluster.assessment_statistics(@start_time,@end_time,@schools),@district.assessment_statistics(@start_time,@end_time)])
			
			@assessment_indicators_by_month = Assessment.indicators([@cluster.assessment_statistics,@district.assessment_statistics])
			
			@indicators=[["assessment",@assessment_indicators,@assessment_indicators_by_month ]]
			@collection_names = [@cluster.name.titleize, @district.name.titleize]
			@school_sets = @schools.each_slice(15)
			respond_to do |format|
				format.js
			end
		else
			flash[:error] = "The specified district does not exist."
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"				
	end
	
	def mentorings_report
		if params[:time_filter].nil?
			@cluster = Cluster.find(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else 
			@cluster = Cluster.find(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])

			@end_time = @start_time.end_of_month

		end	
		
		unless @cluster.nil?	
			@district = @cluster.district
			authorize! :view_school_reports, @district
			@schools = @cluster.schools_with_mentoring_statistics(@start_time,@end_time,@cluster.schools.order("school_name ASC"))
			@mentoring_indicators = Mentoring.indicators([@district.mentoring_statistics(@start_time,@end_time,@clusters),@district.mentoring_statistics(@start_time,@end_time)])
			
			@mentoring_indicators_by_month = Mentoring.indicators([@cluster.mentoring_statistics,@district.mentoring_statistics])
			@indicators=[["mentoring",@mentoring_indicators,@mentoring_indicators_by_month ]]
			@collection_names = [@cluster.name.titleize, @district.name.titleize]
			@school_sets = @schools.each_slice(15)
			
			respond_to do |format|
				format.js
			end
		else
			flash[:error] = "The specified cluster does not exist."
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"				
	end

end
