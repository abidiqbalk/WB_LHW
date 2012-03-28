class Stipend < ActiveRecord::Base
	belongs_to :inspection
	
	validates :enrolled_6, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :enrolled_7, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :enrolled_8, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :enrolled_9, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :enrolled_10, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :eligible_6, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :eligible_7, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :eligible_8, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :eligible_9, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :eligible_10, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :not_received_6, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :not_received_7, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :not_received_8, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :not_received_9, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :not_received_10, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
end
