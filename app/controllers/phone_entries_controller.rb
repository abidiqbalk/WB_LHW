class PhoneEntriesController < ApplicationController

	def index
		@start_time = Time.zone.parse(params[:start_time])
		@end_time = Time.zone.parse(params[:end_time])
		
		case params[:resource_type]
			when "District"
				@resource = District.find(params[:id])
			when "Visitor"
				@resource = Visitor.find(params[:id])
				params[:resource_type] = "Officer" 
		end
		
		if params[:entry_type]
			@phone_entries = @resource.phone_entries.includes(:visitor).where(:start_time=>(@start_time..@end_time.end_of_day),:type => params[:entry_type])
		else
			@phone_entries = @resource.phone_entries.includes(:visitor).where(:start_time=>(@start_time..@end_time.end_of_day))
		end
		
		if @phone_entries.size==0
			flash[:error] = "Oddly enough, no such entries were found."
			redirect_to root_url
			else if @phone_entries.size==1
				redirect_to phone_entry_path(@phone_entries[0])
			end
		end
	end
	
	def show
		@phone_entry = PhoneEntry.find(params[:id])
		unless @phone_entry.nil?
			@officer = @phone_entry.visitor
			if !@officer.nil?
				authorize! :view_compliance_reports, @officer.district
				@boundaries = District.get_boundaries(@officer.district)
			end
			@entry_detail = @phone_entry.detail
			@school = @entry_detail.try(:school)
			@cluster = nil
			define_school_legend
			
			unless @school.nil?
				@cluster = @school.try(:cluster).try(:school)
				@distance_of_school_to_ctsc = @school.distance_to_cluster
				@distance_of_entry_to_school = @phone_entry.distance_to_subject(@school)
				@distance_of_entry_to_ctsc = @phone_entry.distance_to_subject(@cluster)
			end
		else
			flash[:error] = "Can't find the specified report"
			redirect_to root_path
		end
	end
	
	
	
end
