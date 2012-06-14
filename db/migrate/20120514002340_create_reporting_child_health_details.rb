class CreateReportingChildHealthDetails < ActiveRecord::Migration
  def change
    create_table :reporting_child_health_details do |t|
      t.references:reporting_child_health
	  t.string:facility_code
      t.integer:newborns_weighed
      t.integer:low_birth_weighed
      t.integer:newborn_received_breast_milk
      t.integer:newborns_immunization_started
      t.integer:children_under_six_months
      t.integer:children_under_six_months_breast_feeding
      t.integer:children_under_12_to_23_month
      t.integer:children_under_12_to_23_immunized
      t.integer:children_under_3_years
      t.integer:children_under_3_years_growth_monitored
      t.integer:children_under_3_years_under_weight
      t.integer:children_under_5_years
      t.integer:children_under_5_years_muac_measured
      t.integer:children_under_5_years_muac_less
      t.timestamps
    end
  end
end
