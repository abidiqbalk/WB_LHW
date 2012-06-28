class CreateReportingFacilityDetails < ActiveRecord::Migration
  def change
    create_table :reporting_facility_details do |t|
      t.references:reporting_facility
	  t.string:facility_code
      t.integer:catchment_population
      t.integer:population_registered_by_lhw
      t.integer:hf_attached_lhws
      t.integer:submitted_report_by_lhws
      t.integer:left_working_by_lhws
      t.integer:hf_attached_lhss
      t.timestamps
    end
  end
end
