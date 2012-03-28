class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
	  t.references :inspection, :null => false
	  t.string :type
	  t.integer :sanctioned_post
	  t.integer :filled_post
	  t.integer :physically_present
	  t.integer :sanctioned_leave
	  t.integer :official_duty
	  t.integer :unauthorized_absence
	  t.integer :late_comer	  
      t.timestamps
    end
  end
end
