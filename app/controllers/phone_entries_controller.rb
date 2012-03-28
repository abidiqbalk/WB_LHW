class PhoneEntriesController < ApplicationController

	def show
		@phone_entry = PhoneEntry.find(params[:id])
		unless @phone_entry.nil?
			@officer = @phone_entry.visitor
			authorize! :view_compliance_reports, @officer.district
			@entry_detail = @phone_entry.detail
			@school = @entry_detail.school
		else
			flash[:error] = "Can't find the specified report"
			redirect_to root_path
		end
	end
	
end
