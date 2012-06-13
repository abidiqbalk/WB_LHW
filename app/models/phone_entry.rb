=begin
Abstract Class that wraps all phone related activities together.

#Schema Information
    Table name: phone_entries
	id                           :integer(4)      not null, primary key
	type                         :string(255)
	meta_instance_id             :string(41)
	meta_model_version           :string(10)
	meta_ui_version              :string(10)
	meta_submission_date         :timestamp
	meta_is_complete             :string(4)
	meta_date_marked_as_complete :timestamp
	device_id                    :string(15)
	subscriber_id                :string(15)
	sim_id                       :string(20)
	start_time                   :timestamp
	end_time                     :timestamp
	location_x                   :decimal(14, 10) not null
	location_y                   :decimal(14, 10) not null
	location_z                   :decimal(14, 10) not null
	location_accuracy            :decimal(14, 10)
	created_at                   :datetime        not null
	updated_at                   :datetime        not null
	photo_file_name              :string(255)
	photo_content_type           :string(255)
	photo_file_size              :integer(4)
	photo_updated_at             :datetime
	photo_url                    :string(255)
=end

class PhoneEntry < ActiveRecord::Base
	has_attached_file :photo, :styles => { :thumb => "300x240>"}
	belongs_to :visitor, :primary_key => :device_id, :foreign_key => :device_id
	scope :counts_for_compliance, where("type NOT IN (?)", ["Newborn","ChildHealth","SpecialTask"])	
	acts_as_gmappable :lat => 'location_y', :lng => 'location_x', :process_geocoding => false
	reverse_geocoded_by 'location_y', 'location_x'
	
=begin
returns school emiscode of entry if available
@return [Integer] the school emiscode or nil if the entry has no emiscode
=end	
	def emiscode #returns school emiscode if available
		return self.detail.emis_code
	end

=begin
Returns distance between phone entry to subject in meters
@param [Object] subject the target whose distance_to we want. Subject must be reverse geocoded. 
@return [float] distance in meters
=end
	def distance_to_subject(subject)
		unless subject.nil?
			self.distance_to(subject,:km)*1000
		end
	end
	
	def save_distance_to_school			
		entry_detail = self.detail
		school = entry_detail.try(:school)
		if !school.nil?
			distance_of_entry_to_school = self.distance_to_subject(school)
		else
			if self.type != "PdDte"
				distance_of_entry_to_school = -1
			end
		end
		self.update_attribute(:distance, distance_of_entry_to_school)
	end

=begin
Returns whether the entry refers to a valid school or not and whether the entry is within the specified meter distance.
@param [float] maximum_distance the maximum distance from school to entry before we flag the entry. 
@return [string,float] whether an array containing a string stating whether the entry is a "pass", "fail" (school not found) or warning (exceeds max distance) along with the calculated distance used to make this determination.
=end
	def validate_entry(maximum_distance)
		["pass"]
		# if !self.detail.school.nil?
			# distance = distance_to_subject(self.detail.school)
			# if (distance- location_accuracy) >= maximum_distance # we account for gps inaccuracy here by going for the best case scenario for the entry maker.
				# return ["warning", distance]
			# else
				# return ["pass", distance]
			# end
		# else
			# return ["fail"]
		# end
	end

	def self.activities
		[ReportingBirthDeath,ReportingChildHealth,ReportingCommunityMeeting,ReportingFacility,ReportingFamilyPlanning,ReportingMaternalHealth,ReportingTreatment,ChildHealth,HealthHouse,FpClient,Maternal,Newborn,SupportGroupMeeting,SpecialTask]
	end
	
end
