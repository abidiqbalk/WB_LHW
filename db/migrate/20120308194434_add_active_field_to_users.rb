class AddActiveFieldToUsers < ActiveRecord::Migration
	def change
		def up
			change_table :users do |t|
				t.boolean is_active, :default=> true
			end
		end
	end
end