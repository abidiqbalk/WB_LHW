class InspectionCount < ActiveRecord::Base
	validates :unadmitted, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_zero, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_one, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_two, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_three, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_four, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_five, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_six, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_seven, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_eight, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_nine, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_ten, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_eleven, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :class_twelve, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
end
