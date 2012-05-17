class CreateMaternalDetails < ActiveRecord::Migration
  def change
    create_table :maternal_details do |t|
      t.references:maternal
      t.integer:lhw_code
      t.string:name
      t.datetime:expected_date
      t.boolean:iron_intake
      t.integer:tt_vaccination_count
      t.datetime:tt_vaccination_date1
      t.datetime:tt_vaccination_date2
      t.integer:anc_count
      t.datetime:anc_date1
      t.datetime:anc_date2
      t.datetime:anc_date3
      t.datetime:anc_date4
      t.timestamps
    end
  end
end
