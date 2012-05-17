=begin
Stores Designations.
@note Not currently in use in DSD

#Schema Information
	Table name: designations
    id             :integer(4)      not null, primary key
    type           :string(255)     not null
    designation_id :string(2)
    name           :string(32)
    active         :string(1)
=end

class Designation < ActiveRecord::Base
end
