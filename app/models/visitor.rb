class Visitor < ActiveRecord::Base
	has_many :child_health_reports, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :household_reports, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :fp_clients, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :maternals, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :newborns, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :support_meetings, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :phone_entries, :primary_key => :device_id, :foreign_key => :device_id 
	belongs_to :district
end
