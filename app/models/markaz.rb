=begin
Defines a Markaz and all the methods required to gather associated statistics 
@note Not used in DSD

#Schema Information
    Table name: markazs
    id          :integer(4)      not null, primary key
    markaz_id   :string(6)
    markaz_name :string(30)
    active      :string(1)
=end

class Markaz < ActiveRecord::Base
	has_many :schools, :primary_key => "markaz_id", :dependent => :destroy
end
