class CreateDistrictBoundaryPoints < ActiveRecord::Migration
  def change
    create_table :district_boundary_points do |t|
	t.references :district
	t.float :longitude
	t.float :latitude
	t.float :altitude
    end
  end
end
