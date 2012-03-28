class Markaz < ActiveRecord::Base
	has_many :schools, :primary_key => "markaz_id", :dependent => :destroy
end
