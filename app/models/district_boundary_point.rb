=begin
Defines a single point in the polygon of a district boundary. Useful for Maps.
#Schema Information
    Table name: district_boundary_points
    id          :integer(4)      not null, primary key
    district_id :integer(4)
    longitude   :decimal(14, 10)
    latitude    :decimal(14, 10)
    altitude    :decimal(14, 10)
=end
class DistrictBoundaryPoint < ActiveRecord::Base
	belongs_to :district
end
