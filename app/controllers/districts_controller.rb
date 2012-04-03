class DistrictsController < ApplicationController

before_filter :authenticate_user!
# Doing CanCan calls by hand cause new to this and this a fairly complex usecase

	def compliance_report
		if params[:time_filter].nil?
			@district = District.find_by_district_name(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@district = District.find_by_district_name(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter][:start_time])
			@end_time = Time.zone.parse(params[:time_filter][:end_time])
		end	
				
		unless @district.nil?	
			authorize! :view_school_reports, @district
			@visitors = @district.visitors
			@temp_expectation_visits = 2
			
			respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
				if request.xhr?
					format.js (render 'compliance_report.js.erb')
				else
					format.html (render 'compliance_report.html.erb')
				end
			end
		else
			flash[:error] = "The specified district does not exist."
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"			
	end
	
	def activities_report
		if params[:time_filter].nil?
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@start_time = Time.zone.parse(params[:time_filter][:start_time])
			@end_time = Time.zone.parse(params[:time_filter][:end_time])
		end	
	
		@districts = District.find_all_by_district_name(["Okara","Hafizabad"])
		authorize! :view_compliance_reports, District
		respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
			if request.xhr?
				format.js (render 'activities_report.js.erb')
			else
				format.html (render 'activities_report.html.erb')
			end
		end
		
		rescue ArgumentError
		puts "caught exception!!!~"	
	end

	def school_report
		if params[:time_filter].nil?
			@district = District.find_by_district_name(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else 
			@district = District.find_by_district_name(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter][:start_time])
			@end_time = Time.zone.parse(params[:time_filter][:end_time])
		end	
				
		unless @district.nil?	
			authorize! :view_school_reports, @district
			@clusters = @district.clusters_with_statistics(@start_time,@end_time,@district.clusters.order("school_name ASC"))
			@assessment_indicators = Assessment.indicators([@district.assessment_statistics(@start_time,@end_time,@clusters),District.assessment_statistics((@start_time),(@end_time))])
			@mentoring_indicators = Mentoring.indicators([@district.mentoring_statistics(@start_time,@end_time,@clusters),District.mentoring_statistics((@start_time),(@end_time))])
			
			@assessment_indicators_by_month = Assessment.indicators([@district.assessment_statistics,District.assessment_statistics])
			@mentoring_indicators_by_month = Mentoring.indicators([@district.mentoring_statistics,District.mentoring_statistics])
			
			@collection_names = ["District", "Provincial"]
			@cluster_sets = @clusters.each_slice(15)
			
			#@school = @district.assessment_details.where('phone_entries.start_time' => time_range)
			# School.find_by_emiscode(39330003).assessment_details[0].assessment
			respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
				if request.xhr?
					format.js (render 'school_report.js.erb')
				else
					format.html (render 'school_report.html.erb')
				end
			end
		else
			flash[:error] = "The specified district does not exist."
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"			
	end
	
	def overall_schools_report		
		if params[:time_filter].nil?
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@start_time = Time.zone.parse(params[:time_filter][:start_time])
			@end_time = Time.zone.parse(params[:time_filter][:end_time])
		end	
		authorize! :view_school_reports, District
		@districts = District.find_all_by_district_name(["Okara","Hafizabad"])
		@districts = District.districts_with_statistics((@start_time),(@end_time),@districts)
		@collection_names = ["Provincial"]
		@assessment_indicators = Assessment.indicators([District.assessment_statistics((@start_time),(@end_time))])
		@mentoring_indicators = Mentoring.indicators([District.mentoring_statistics((@start_time),(@end_time))])
		
		@assessment_indicators_by_month = Assessment.indicators([District.assessment_statistics])
		@mentoring_indicators_by_month = Mentoring.indicators([District.mentoring_statistics])
		
		respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
			if request.xhr?
				format.js (render 'overall_schools_report.js.erb')
			else
				format.html (render 'overall_schools_report.html.erb')
			end
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"			
	end

end
