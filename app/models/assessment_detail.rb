class AssessmentDetail < ActiveRecord::Base

	belongs_to :assessment
	belongs_to :school, :primary_key => :emiscode, :foreign_key => :emis_code

end
