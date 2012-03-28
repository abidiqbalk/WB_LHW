class CreateSchoolLocations < ActiveRecord::Migration
  def change
    create_table :school_locations do |t|

      t.timestamps
    end
  end
end
