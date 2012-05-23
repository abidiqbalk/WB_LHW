class NewbornDetail < ActiveRecord::Base

	belongs_to :newborn
	has_attached_file :photo, :styles => { :thumb => "300x240>"}
end
