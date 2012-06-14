class CreateReportingFamilyPlanningDetails < ActiveRecord::Migration
  def change
    create_table :reporting_family_planning_details do |t|
      t.references:reporting_family_planning
	  t.string:facility_code
      t.integer:eligible_couples
      t.integer:new_clients
      t.integer:old_clients
      t.integer:old_clients_follow_up
      t.integer:clients_modern_method
      t.integer:condom_users
      t.integer:users_provided_condoms
      t.integer:ocp_users
      t.integer:users_provided_ocp
      t.integer:injection_users
      t.integer:users_provided_injections
      t.integer:women_using_iucd
      t.integer:women_using_iucd_current_month
      t.integer:clients_surgical_fp
      t.integer:clients_surgical_fp_current_month
      t.integer:fp_clients_referred
      t.timestamps
    end
  end
end
