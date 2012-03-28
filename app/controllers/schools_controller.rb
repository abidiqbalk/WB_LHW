class SchoolsController < ApplicationController

	def show
	if params[:time_filter].nil?
			@school = School.find(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else 
			@school = School.find(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter][:start_time])
			@end_time = Time.zone.parse(params[:time_filter][:end_time])
		end	
				
		unless @school.nil?	
		
			@district = @school.district
			@cluster = @school.cluster
	
			authorize! :view_school_reports, @district
			
			@school_assessment_averages = @school.assessment_statistics(@start_time, @end_time)[0]
			@school_mentoring_averages = @school.mentoring_statistics(@start_time, @end_time)[0]
			@latest_assessment = @school.assessments.order("start_time DESC").first.try(:detail)
			@latest_mentoring = @school.mentorings.order("start_time DESC").first.try(:detail)
			
			
			@assessment_indicators_by_month = Assessment.indicators([@school.assessment_statistics,@cluster.assessment_statistics])
			@mentoring_indicators_by_month = Mentoring.indicators([@school.mentoring_statistics,@cluster.mentoring_statistics])
			
			@collection_names = ["School", "Cluster"]
			
			respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
				if request.xhr?
					format.js (render 'show.js.erb')
				else
					format.html (render 'show.html.erb')
				end
			end
		else
			flash[:error] = "The specified cluster does not exist."
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"
	end
end
