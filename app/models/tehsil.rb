# == Schema Information
#
# Table name: tehsils
#
#  id            :integer(4)      not null, primary key
#  tehsil_id     :string(4)
#  district_name :string(20)
#  tehsil_name   :string(20)
#  active        :string(1)
#  maxemis       :string(8)
#

class Tehsil < ActiveRecord::Base
	has_many :schools, :primary_key => "tehsil_id", :dependent => :destroy
end
