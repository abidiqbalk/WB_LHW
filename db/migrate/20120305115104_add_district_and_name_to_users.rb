class AddDistrictAndNameToUsers < ActiveRecord::Migration
	def change
		def up
			change_table :users do |t|
				t.references :district_id, :null => false, :default => "345"
				t.string :name
			end
		end
	end
end