=begin
Stores Devices currently registed with the department
@todo Integrate with User model and restructure queries around this. This model is not really in use currently.
#Schema Information
    Table name: devices
    id          :integer(4)      not null, primary key
    device_id   :integer(4)
    name        :string(255)
    device_type :string(255)
    created_at  :datetime        not null
    updated_at  :datetime        not null
=end

class Device < ActiveRecord::Base
end
