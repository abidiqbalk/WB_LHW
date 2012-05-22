class ProvincesController < ApplicationController

	def compliance_report
		if params[:time_filter].nil?
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])
			@end_time = @start_time.end_of_month
		end	
		
		@province = Province.find(1)
		@province.compliance_statistics(@end_time)
		@phone_entries = PhoneEntry.includes(:visitor).where(:start_time=>(@start_time..@end_time.end_of_day))
		@districts = @province.districts.order("district_name ASC")
		
		@number_of_months = (@end_time.year*12+@end_time.month) - (@start_time.year*12+@start_time.month) + 1
		
		@districts = @province.districts_with_compliance_statistics(@start_time,@end_time,@number_of_months,@districts)
		
		@districts.sort! { |p1, p2| p2.total_percentage <=> p1.total_percentage }
				
		@boundaries = District.get_boundaries(@districts)
		gon.districts = @districts.map(&:name)
		gon.your_int = @number_of_months	
		define_activity_legend
		define_details_images
		
		respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
			if request.xhr?
				format.js (render 'compliance_report.js.erb')
			else
				format.html (render 'compliance_report.html.erb')
			end
		end
		
		rescue ArgumentError
		puts "caught exception!!!~"	
	end

	def assessments_report
		if params[:time_filter].nil?
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])

			@end_time = @start_time.end_of_month

		end	
		authorize! :view_school_reports, District
		@districts = District.find_all_by_district_name(["Okara","Hafizabad"])
		@districts = Province.districts_with_assessment_statistics((@start_time),(@end_time),@districts)
		@collection_names = ["Provincial"]
		
		@assessment_indicators = Assessment.indicators([Province.assessment_statistics((@start_time),(@end_time))])
		@assessment_indicators_by_month = Assessment.indicators([Province.assessment_statistics])
		@indicators=[["assessment",@assessment_indicators,@assessment_indicators_by_month ]]
		
		respond_to do |format|
			format.js
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"	
	end
	
	def mentorings_report
		if params[:time_filter].nil?
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])

			@end_time = @start_time.end_of_month

		end	
		authorize! :view_school_reports, District
		@districts = District.find_all_by_district_name(["Okara","Hafizabad"])
		@districts = Province.districts_with_mentoring_statistics((@start_time),(@end_time),@districts)
		@collection_names = ["Provincial"]
		
		@mentoring_indicators = Mentoring.indicators([Province.mentoring_statistics((@start_time),(@end_time))])
		@mentoring_indicators_by_month = Mentoring.indicators([Province.mentoring_statistics])
		@indicators=[["mentoring",@mentoring_indicators,@mentoring_indicators_by_month ]]
		
		respond_to do |format|
			format.js
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"	
	end
	
	def school_report		
		if params[:time_filter].nil?
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])
			@end_time = @start_time.end_of_month
		end	
		authorize! :view_school_reports, District
		
		@province = Province.find(1)
		@districts = @province.districts.order("district_name ASC")
				
		@province.districts_with_indicator_statistics(@start_time,@end_time,@districts)
		
		@province.indicator_statistics(@end_time)
		@indicators = Assessment.indicators2
		
		respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
			if request.xhr?
				format.js (render 'school_report.js.erb')
			else
				format.html (render 'school_report.html.erb')
			end
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"	
		end

		
	end
