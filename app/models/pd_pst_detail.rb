class PdPstDetail < ActiveRecord::Base

	belongs_to :pd_pst
	belongs_to :school, :primary_key => :emiscode, :foreign_key => :emis_code

end
