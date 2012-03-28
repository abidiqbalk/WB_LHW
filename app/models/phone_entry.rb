class PhoneEntry < ActiveRecord::Base
	has_attached_file :photo, :styles => { :thumb => "260x180>"}
	belongs_to :visitor, :primary_key => :device_id, :foreign_key => :device_id
	
	def emiscode
		return self.detail.emis_code
	end
	
end
