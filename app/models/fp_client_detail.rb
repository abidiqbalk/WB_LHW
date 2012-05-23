class FpClientDetail < ActiveRecord::Base

	belongs_to :fp_client
	has_attached_file :audio
end
