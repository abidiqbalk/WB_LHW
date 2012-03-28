class MentoringDetail < ActiveRecord::Base

	belongs_to :mentoring
	belongs_to :school, :primary_key => :emiscode, :foreign_key => :emis_code

end
