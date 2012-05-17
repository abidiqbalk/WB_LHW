=begin
Defines a District and all the methods required to gather associated statistics 
@note Not really used in DSD
#Schema Information
    Table name: divisions
    id            :integer(4)      not null, primary key
    division_id   :string(2)       default(""), not null
    division_name :string(255)
=end

class Division < ActiveRecord::Base
end
