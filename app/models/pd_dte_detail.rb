class PdDteDetail < ActiveRecord::Base

	belongs_to :pd_dte

	def emis_code #to expose a common interface to all phone_entry details
		return nil
	end
	
	def school
		return nil
	end
	
end
