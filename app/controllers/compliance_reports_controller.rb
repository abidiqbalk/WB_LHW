class ComplianceReportsController < ApplicationController

before_filter :authenticate_user!
# Doing CanCan calls by hand cause new to this and this a fairly complex usecase

	def district
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
			authorize! :view_compliance_reports, @district
			respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
				if request.xhr?
					format.js (render 'district.js.erb')
				else
					format.html (render 'district.html.erb')
				end
			end
		else
			flash[:error] = "Can't find the specified district"
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"	
		
	end
	
	def districts		
		if params[:time_filter].nil?
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@start_time = Time.zone.parse(params[:time_filter][:start_time])
			@end_time = Time.zone.parse(params[:time_filter][:end_time])
		end
		authorize! :view_compliance_reports, District
		respond_to do |format|
			format.html
			format.js
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"	
	end

	def officer
		if params[:time_filter].nil?
			@officer = Visitor.find(params[:id])
			@start_time = Time.now.prev_month.beginning_of_month
			@end_time = Time.now.prev_month.end_of_month
		else
			@officer = Visitor.find(params[:time_filter][:id])
			@start_time = Time.zone.parse(params[:time_filter][:start_time])
			@end_time = Time.zone.parse(params[:time_filter][:end_time])
		end	
		
		unless @officer.nil?			
			authorize! :view_compliance_reports, @officer.district 
			@a_count = @officer.assessments.where(:start_time=>(@start_time..@end_time.end_of_day)).count
			@m_count = @officer.mentorings.where(:start_time=>(@start_time..@end_time.end_of_day)).count
			@p_count = @officer.pd_psts.where(:start_time=>(@start_time..@end_time.end_of_day)).count
			@d_count = @officer.pd_dtes.where(:start_time=>(@start_time..@end_time.end_of_day)).count

			respond_to do |format| # why the hell do i need to pull a request.xhr check here...?
				if request.xhr?
					format.js (render 'officer.js.erb')
				else
					format.html (render 'officer.html.erb')
				end
			end
		else
			flash[:error] = "Can't find the specified officer"
			redirect_to root_path
		end
		
		rescue ArgumentError
			puts "caught exception!!!~"	
		
	end
end
