# == Schema Information
#
# Table name: visitors
#
#  id               :integer(4)      not null, primary key
#  device_id        :string(15)      not null
#  name             :string(255)     not null
#  district_id      :integer(4)      not null
#  designation      :string(255)     not null
#  schools_assigned :integer(4)      not null
#

class Visitor < ActiveRecord::Base
	include Reportable

	has_many :pd_psts, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :pd_dtes, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :assessments, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :mentorings, :primary_key => :device_id, :foreign_key => :device_id 
	has_many :phone_entries, :primary_key => :device_id, :foreign_key => :device_id 
	belongs_to :district
		
	def assessments_required(number_of_months)
		self.schools_assigned*number_of_months
	end
	
	def mentorings_required(number_of_months)
		self.schools_assigned*number_of_months
	end
	
	def pdpsts_required(number_of_months)
		number_of_months
	end
	
	def pddtes_required(number_of_months)
		number_of_months
	end
	
	def visitors
		[1]
	end
	
end
