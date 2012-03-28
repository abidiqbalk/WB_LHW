class Visitor < ActiveRecord::Base
	has_many :pd_psts, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :pd_dtes, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :assessments, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :mentorings, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :phone_entries, :primary_key => :device_id, :foreign_key => :device_id 
	belongs_to :district
end
