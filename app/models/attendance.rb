class Attendance < ActiveRecord::Base
	belongs_to :inspection
	
	validates :sanctioned_post, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :filled_post, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :physically_present, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :sanctioned_leave, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :official_duty, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :unauthorized_absence, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :late_comer, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true	
end
