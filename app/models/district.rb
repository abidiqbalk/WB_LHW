class District < ActiveRecord::Base
	include Reportable
	
	#has_many :schools, :primary_key => "district_id", :dependent => :destroy
	has_many :visitors 
	has_many :assessments, :through => :visitors, :include => :detail
	has_many :phone_entries, :through => :visitors
	#has_many :assessment_details, :through => :schools
	has_and_belongs_to_many :users	
	
	
	alias_attribute :name, :district_name # need this to expose common interface to reporting modules


	extend FriendlyId
	friendly_id :district_name, use: :slugged

end
