class FpClientDetail < ActiveRecord::Base

	belongs_to :fp_client
	has_attached_file :audio, :path => ":rails_root/public/:attachment/:id/:style/recording.amr"
end
