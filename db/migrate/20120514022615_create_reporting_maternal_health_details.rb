class CreateReportingMaternalHealthDetails < ActiveRecord::Migration
  def change
    create_table :reporting_maternal_health_details do |t|
      t.references :reporting_maternal_health
	  t.string:facility_code
      t.integer:pregnent_woman_enrolled_current_month
      t.integer:pregnent_women_total
      t.integer:Pregnent_women_anc
      t.integer:pregnent_women_iron_tablet
      t.integer:miscarriages
      t.integer:delivered_women_more_than_4_anc
      t.integer:delivered_woman_tt_completed
      t.integer:deliveries_by_sba
      t.integer:delivered_woman_examined_in_24_hour
      t.integer:refered_to_health_facility
      t.integer:deliveries_public_hospital
      t.integer:deliveries_private_hospital
      t.integer:deliveries_home
      t.integer:deliveries_cmw_home
      t.timestamps
    end
  end
end
