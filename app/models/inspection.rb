class Inspection < ActiveRecord::Base
  attr_accessor :school_name, :district, :markaz, :tehsil, :mauza, :school_level, :school_gender, 
  :uc_number, :pp_number, :na_number, :uc_name, :school_location, :illegal_occupation_attributes, 
  :illegal_fee_attributes, :contract_teacher_attendance_attributes, :regular_teacher_attendance_attributes,
  :contract_non_teacher_attendance_attributes, :regular_non_teacher_attendance_attributes, :school_head_attributes,
  :teacher_attendance_detail_attributes, :non_teacher_attendance_detail_attributes, :previous_inspections_attributes,
  :students_enrolled_attributes, :students_present_attributes, :stipend_attributes, :additional_inspection_info_attributes,
  :ft_fund_attributes, :school_council_attributes, :received_textbook_set_attributes, :surplus_textbook_set_attributes,
  :students_without_textbook_set_attributes, :additional_inspection_info_attributes

  
  belongs_to :school
  belongs_to :user
  has_one :illegal_occupation
  has_one :students_present
  has_one :students_enrolled
  has_one :illegal_fee
  has_one :school_council
  has_one :ft_fund
  has_one :school_head
  has_one :regular_teacher_attendance
  has_one :regular_non_teacher_attendance
  has_one :contract_teacher_attendance
  has_one :contract_non_teacher_attendance
  has_one :additional_inspection_info
  has_one :stipend
  has_one :received_textbook_set
  has_one :surplus_textbook_set
  has_one :students_without_textbook_set
  has_one :additional_inspection_info
  has_many :teacher_attendance_details
  has_many :non_teacher_attendance_details
  has_many :previous_inspections
  
  accepts_nested_attributes_for :illegal_occupation, :reject_if => lambda { |a| !a[:illegal_occupation_check][0].eql? "Building under illegal occupation" }, :allow_destroy => true
  accepts_nested_attributes_for :illegal_fee
  accepts_nested_attributes_for :school_head
  accepts_nested_attributes_for :students_present
  accepts_nested_attributes_for :students_enrolled
  accepts_nested_attributes_for :regular_teacher_attendance
  accepts_nested_attributes_for :regular_non_teacher_attendance
  accepts_nested_attributes_for :contract_teacher_attendance
  accepts_nested_attributes_for :contract_non_teacher_attendance
  accepts_nested_attributes_for :teacher_attendance_details , :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :non_teacher_attendance_details , :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :previous_inspections , :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :stipend
  accepts_nested_attributes_for :additional_inspection_info
  accepts_nested_attributes_for :ft_fund
  accepts_nested_attributes_for :school_council
  accepts_nested_attributes_for :received_textbook_set
  accepts_nested_attributes_for :surplus_textbook_set
  accepts_nested_attributes_for :students_without_textbook_set
  accepts_nested_attributes_for :additional_inspection_info
  #, :reject_if => :all_blank, :allow_destroy => true

  #has_one :district, :through => :school
  #has_one :tehsil, :through => :school
  #has_one :markaz, :through => :school
  
   validates :mea_name, :aeo_name, :officer_id, :presence => true, :length => { :minimum => 4 }
#   validates :emiscode, :length => { :minimum => 8 }, :emis_found => true, :presence => true
   validates_datetime :arrival_date, :before => lambda { Time.now }, :before_message => "can't be in the future"
   validates_datetime :departure_date, :before => lambda { Time.now }
  
  def arrival_date_string
    if self.new_record?
      I18n.l(Time.current, :format => "%d-%m-%Y %H:%M")
    else
      I18n.l(arrival_date, :format => "%d-%m-%Y %H:%M")
    end
end

def arrival_date_string=(arrival_date_str)
   self.arrival_date = Time.zone.parse(arrival_date_str)
  rescue ArgumentError
    @arrival_date_invalid = true
end


  def departure_date_string
    if self.new_record?
      I18n.l(Time.current, :format => "%d-%m-%Y %H:%M")
    else
      I18n.l(arrival_date, :format => "%d-%m-%Y %H:%M")
    end
end

def departure_date_string=(departure_date_str)
   self.departure_date = Time.zone.parse(departure_date_str)
  rescue ArgumentError
    @departure_date_invalid = true
end

def validate
    errors.add(:arrival_date, "is invalid") if @arrival_date_invalid
    errors.add(:departure_date, "is invalid") if @departure_date_invalid
end 

def self.do_something
    puts "something"
  end
  
end