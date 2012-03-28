class AbsenceDetail < ActiveRecord::Base
	validates :month_leave, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :month_duty, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :month_absent, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :year_leave, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :year_duty, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :year_absent, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
end
