class Tehsil < ActiveRecord::Base
	has_many :schools, :primary_key => "tehsil_id", :dependent => :destroy
end
