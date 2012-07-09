class ProvincesController < ApplicationController
before_filter :authenticate_user!

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

	def indicators_report
			puts "I GOT RUN!!!!"
			HealthHouse.import_data

		if params[:time_filter].nil?
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])
			@end_time = @start_time.end_of_month
		end	
		authorize! :view_indicators_reports, District
		
		indicators_init

		@province = Province.find(1)
		@districts = @province.districts.order("district_name ASC")
		@province.districts_with_indicator_statistics(@start_time,@end_time,@districts, @activities)
		@province.indicator_statistics(@end_time, @activities)
		
		respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
			if request.xhr?
				format.js (render 'indicators_report.js.erb')
			else
				format.html (render 'indicators_report.html.erb')
			end
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"	
	end

	
end
