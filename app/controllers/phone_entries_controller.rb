class PhoneEntriesController < ApplicationController
before_filter :authenticate_user!

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
			@officer = @phone_entry.visitor
			if !@officer.nil?
				authorize! :view_compliance_reports, @officer.district
				@boundaries = District.get_boundaries(@officer.district)
			end
			@entry_detail = @phone_entry.detail
			
		rescue ActiveRecord::RecordNotFound
			flash[:error] = "Can't find the specified entry"
			redirect_to root_path
	end
	
	def audio_attachment
		file = FpClientDetail.find(params[:id])
		send_file file.audio.path, :type => file.audio_content_type
	end
	
	
	
end
