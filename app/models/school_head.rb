class SchoolHead < ActiveRecord::Base
 belongs_to :teacher_designation
 belongs_to :inspection
 
 validates :name, :presence => true, :length => { :minimum => 4 }
end
