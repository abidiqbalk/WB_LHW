class HealthFacilitiesController < ApplicationController

	def indicators_report
		if params[:time_filter].nil?
			@facility = HealthFacility.find(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@facility = HealthFacility.find(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter]["start_time(3i)"]+"-"+params[:time_filter]["start_time(2i)"]+"-"+params[:time_filter]["start_time(1i)"])
			@end_time = @start_time.end_of_month
		end	
		
		unless @facility.nil?
			@district = @facility.district
			authorize! :view_compliance_reports, @district 
			
			@activities = PhoneEntry.activities[0..6]
		
			@indicators = []
			@indicator_names= Hash.new
			@indicator_hooks= Hash.new
		
			for activity in @activities
				indicators = activity.indicators2.find_all{|indicator| indicator.indicator_type == "integer" }
				@indicator_names[activity.name] = indicators.collect {|indicator| indicator.full_name} 
				@indicator_hooks[activity.name] = indicators.collect {|indicator| indicator.indicator_activity.name+"_"+indicator.hook} 
				@indicators += indicators
			end
			
			gon.indicator_names = @indicator_names
			gon.indicator_hooks = @indicator_hooks		
			gon.flash_path = view_context.asset_path('copy_csv_xls_pdf.swf')
						
			@district.indicator_statistics_for_facilities(@end_time, @activities)
			@facility.indicator_statistics(@end_time, @activities)
			
			@phone_entries = @facility.phone_entries
			
		else
			flash[:error] = "The specified facility does not exist."
			redirect_to root_path
		end
	end

end
