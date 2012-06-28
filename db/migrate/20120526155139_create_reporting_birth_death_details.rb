class CreateReportingBirthDeathDetails < ActiveRecord::Migration
  def change
    create_table :reporting_birth_death_details do |t|
      t.references:reporting_birth_death
	  t.string:facility_code
      t.integer:live_births
      t.integer:number_of_iuds
      t.integer:Total_deaths
      t.integer:death_within_week
      t.integer:death_after_week
      t.integer:children_deaths
      t.integer:maternal_deaths
      t.timestamps
    end
  end
end
