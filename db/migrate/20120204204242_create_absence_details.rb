class CreateAbsenceDetails < ActiveRecord::Migration
  def change
    create_table :absence_details do |t|
	  t.references :inspection, :null=> false
	  t.string :type
	  t.string :cnic
	  t.references :designations
	  t.string :employment_type
	  t.integer :month_leave
	  t.integer :month_duty
	  t.integer :month_absent
	  t.integer :year_leave
	  t.integer :year_duty
	  t.integer :year_absent
	  t.string :reason_today
      t.timestamps
    end
  end
end
