class AdditionalInspectionInfo < ActiveRecord::Base
	belongs_to :inspection
	
	validates :students_without_furniture, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :teachers_without_furniture, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :total_sections_k12, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :total_classrooms_k12, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :teachers_in_ctsc, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true
	validates :bfm_recieved, :numericality => { :only_integer => true,:greater_than_or_equal_to => 0 }, :allow_blank => true

end
