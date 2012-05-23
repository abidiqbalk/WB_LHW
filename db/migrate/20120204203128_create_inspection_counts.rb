class CreateInspectionCounts < ActiveRecord::Migration
  def change
    create_table :inspection_counts do |t|
		t.references :inspection, :null=> false
		t.string :type
		t.integer   "class_zero"
		t.integer   "class_one"
		t.integer   "class_two"
		t.integer   "class_three"
		t.integer   "class_four"
		t.integer   "class_five"
		t.integer   "class_six"
		t.integer   "class_seven"
		t.integer   "class_eight"
		t.integer   "class_nine"
		t.integer   "class_ten"
		t.integer   "class_eleven"
		t.integer   "class_twelve"
		t.text   "reason_for_excess_charges"

      t.timestamps
    end
  end
end
