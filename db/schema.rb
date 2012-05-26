# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120526155139) do

  create_table "child_health_details", :force => true do |t|
    t.integer  "child_health_id"
    t.integer  "lhw_code"
    t.string   "name_of_child"
    t.integer  "age_in_month"
    t.decimal  "mid_upper_arm_circumference", :precision => 10, :scale => 0
    t.decimal  "weight",                      :precision => 10, :scale => 0
    t.datetime "epi_polio_bcg"
    t.datetime "penta1_polio"
    t.datetime "penta2_polio"
    t.datetime "penta3_polio"
    t.datetime "measles1"
    t.datetime "measles2"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "designations", :force => true do |t|
    t.string "type",                         :null => false
    t.string "designation_id", :limit => 2
    t.string "name",           :limit => 32
    t.string "active",         :limit => 1
  end

  create_table "devices", :force => true do |t|
    t.integer  "device_id"
    t.string   "name"
    t.string   "device_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "devices_users", :id => false, :force => true do |t|
    t.integer  "device_id"
    t.integer  "user_id"
    t.datetime "assigned_on"
    t.datetime "assigned_till"
  end

  create_table "district_boundary_points", :force => true do |t|
    t.integer "district_id"
    t.decimal "longitude",   :precision => 14, :scale => 10
    t.decimal "latitude",    :precision => 14, :scale => 10
    t.decimal "altitude",    :precision => 14, :scale => 10
  end

  add_index "district_boundary_points", ["district_id"], :name => "district_id"

  create_table "districts", :force => true do |t|
    t.string  "district_id",    :limit => 3,          :default => "", :null => false
    t.integer "province_id",                                          :null => false
    t.string  "district_name",  :limit => 20
    t.string  "district_short", :limit => 3
    t.string  "active",         :limit => 1
    t.string  "pop_flag",       :limit => 1
    t.string  "stipend",        :limit => 1
    t.string  "division_id",    :limit => 2
    t.string  "slug"
    t.text    "boundaries",     :limit => 2147483647,                 :null => false
  end

  add_index "districts", ["district_id"], :name => "district_id", :unique => true

  create_table "districts_users", :id => false, :force => true do |t|
    t.integer "district_id"
    t.integer "user_id"
  end

  create_table "divisions", :force => true do |t|
    t.string "division_id",   :limit => 2, :default => "", :null => false
    t.string "division_name"
  end

  add_index "divisions", ["division_id"], :name => "division_id", :unique => true

  create_table "fp_client_details", :force => true do |t|
    t.integer  "fp_client_id"
    t.integer  "lhw_code"
    t.string   "name"
    t.string   "mobile_number"
    t.string   "method_used"
    t.integer  "average_monthly_consumption"
    t.string   "source"
    t.string   "receiving_supplies"
    t.string   "feedback_url"
    t.datetime "date_of_visit"
    t.string   "audio_file_name"
    t.string   "audio_content_type"
    t.integer  "audio_file_size"
    t.datetime "audio_updated_at"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "health_house_details", :force => true do |t|
    t.integer  "health_house_id"
    t.integer  "lhw_code"
    t.string   "catchment_area"
    t.boolean  "community_chart"
    t.text     "diary"
    t.integer  "pregnent_women_new"
    t.integer  "pregnent_women_old"
    t.integer  "live_births"
    t.integer  "number_of_children"
    t.integer  "number_of_eligible_fp_clients"
    t.integer  "new_fp_clients"
    t.integer  "condom_stock"
    t.integer  "oral_contraceptive_pill_stock"
    t.integer  "injection_stock"
    t.integer  "paracetamol_stock"
    t.integer  "ors_stock"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "indicators", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "markazs", :force => true do |t|
    t.string "markaz_id",   :limit => 6
    t.string "markaz_name", :limit => 30
    t.string "active",      :limit => 1
  end

  add_index "markazs", ["markaz_id"], :name => "markaz_id", :unique => true

  create_table "maternal_details", :force => true do |t|
    t.integer  "maternal_id"
    t.integer  "lhw_code"
    t.string   "name"
    t.datetime "expected_date"
    t.boolean  "iron_intake"
    t.integer  "tt_vaccination_count"
    t.datetime "tt_vaccination_date1"
    t.datetime "tt_vaccination_date2"
    t.integer  "anc_count"
    t.datetime "anc_date1"
    t.datetime "anc_date2"
    t.datetime "anc_date3"
    t.datetime "anc_date4"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "newborn_details", :force => true do |t|
    t.integer  "newborn_id"
    t.integer  "lhw_code"
    t.string   "name"
    t.string   "mobile_number"
    t.datetime "date_of_birth"
    t.datetime "date_of_visit"
    t.integer  "anti_natal_care"
    t.boolean  "tt_vaccination"
    t.string   "birth_attendant"
    t.string   "place_of_delivery"
    t.boolean  "post_natal_care"
    t.float    "weight_of_newborn"
    t.boolean  "breast_feeding"
    t.boolean  "bcg_given"
    t.datetime "bcg_date"
    t.boolean  "polio_status"
    t.datetime "polio_date"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_url"
  end

  create_table "phone_entries", :force => true do |t|
    t.string    "type"
    t.string    "meta_instance_id",             :limit => 41
    t.string    "meta_model_version",           :limit => 10
    t.string    "meta_ui_version",              :limit => 10
    t.timestamp "meta_submission_date"
    t.string    "meta_is_complete",             :limit => 4
    t.timestamp "meta_date_marked_as_complete"
    t.string    "device_id",                    :limit => 15
    t.string    "subscriber_id",                :limit => 15
    t.string    "sim_id",                       :limit => 20
    t.timestamp "start_time"
    t.timestamp "end_time"
    t.decimal   "location_x",                                 :precision => 14, :scale => 10,                  :null => false
    t.decimal   "location_y",                                 :precision => 14, :scale => 10,                  :null => false
    t.decimal   "location_z",                                 :precision => 14, :scale => 10,                  :null => false
    t.decimal   "distance",                                   :precision => 16, :scale => 8,  :default => 0.0
    t.decimal   "location_accuracy",                          :precision => 14, :scale => 10
    t.datetime  "created_at",                                                                                  :null => false
    t.datetime  "updated_at",                                                                                  :null => false
    t.string    "photo_file_name"
    t.string    "photo_content_type"
    t.integer   "photo_file_size"
    t.datetime  "photo_updated_at"
    t.string    "photo_url"
  end

  add_index "phone_entries", ["device_id", "end_time"], :name => "idx1", :unique => true
  add_index "phone_entries", ["distance"], :name => "distance"
  add_index "phone_entries", ["type"], :name => "type"

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reporting_birth_death_details", :force => true do |t|
    t.integer  "reporting_birth_death_id"
    t.integer  "live_births"
    t.integer  "number_of_iuds"
    t.integer  "Total_deaths"
    t.integer  "death_within_week"
    t.integer  "death_after_week"
    t.integer  "children_deaths"
    t.integer  "maternal_deaths"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "reporting_child_health_details", :force => true do |t|
    t.integer  "reporting_child_health_id"
    t.integer  "newborns_weighed"
    t.integer  "low_birth_weighed"
    t.integer  "newborn_received_breast_milk"
    t.integer  "newborns_immunization_started"
    t.integer  "children_under_six_months"
    t.integer  "children_under_six_months_breast_feeding"
    t.integer  "children_under_12_to_23_month"
    t.integer  "children_under_12_to_23_immunized"
    t.integer  "children_under_3_years"
    t.integer  "children_under_3_years_growth_monitored"
    t.integer  "children_under_3_years_under_weight"
    t.integer  "children_under_5_years"
    t.integer  "children_under_5_years_muac_measured"
    t.integer  "children_under_5_years_muac_less"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  create_table "reporting_community_meeting_details", :force => true do |t|
    t.integer  "reporting_community_meeting_id"
    t.integer  "lhw_code"
    t.integer  "health_committee_meeting"
    t.integer  "support_group_meeting"
    t.integer  "health_education_session_in_schools"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "reporting_facility_details", :force => true do |t|
    t.integer  "reporting_facility_id"
    t.integer  "catchment_population"
    t.integer  "population_registered_by_lhw"
    t.integer  "hf_attached_lhws"
    t.integer  "submitted_report_by_lhws"
    t.integer  "left_working_by_lhws"
    t.integer  "hf_attached_lhss"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "reporting_family_planning_details", :force => true do |t|
    t.integer  "reporting_family_planning_id"
    t.integer  "eligible_couples"
    t.integer  "new_clients"
    t.integer  "old_clients"
    t.integer  "old_clients_follow_up"
    t.integer  "clients_modern_method"
    t.integer  "condom_users"
    t.integer  "users_provided_condoms"
    t.integer  "ocp_users"
    t.integer  "users_provided_ocp"
    t.integer  "injection_users"
    t.integer  "users_provided_injections"
    t.integer  "women_using_iucd"
    t.integer  "women_using_iucd_current_month"
    t.integer  "clients_surgical_fp"
    t.integer  "clients_surgical_fp_current_month"
    t.integer  "fp_clients_referred"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "reporting_maternal_health_details", :force => true do |t|
    t.integer  "reporting_maternal_health_id"
    t.integer  "pregnent_woman_enrolled_current_month"
    t.integer  "pregnent_women_total"
    t.integer  "Pregnent_women_anc"
    t.integer  "pregnent_women_iron_tablet"
    t.integer  "miscarriages"
    t.integer  "delivered_women_more_than_4_anc"
    t.integer  "delivered_woman_tt_completed"
    t.integer  "deliveries_by_sba"
    t.integer  "delivered_woman_examined_in_24_hour"
    t.integer  "refered_to_health_facility"
    t.integer  "deliveries_public_hospital"
    t.integer  "deliveries_private_hospital"
    t.integer  "deliveries_home"
    t.integer  "deliveries_cmw_home"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "reporting_treatment_details", :force => true do |t|
    t.integer  "reporting_treatment_id"
    t.integer  "diarrhea_under5"
    t.integer  "diarrhea_under5_provided_med"
    t.integer  "diarrhea_over5"
    t.integer  "diarrhea_over5_provided_med"
    t.integer  "respiratory_disease_under5"
    t.integer  "respiratory_disease_under5_provided_med"
    t.integer  "respiratory_disease_over5"
    t.integer  "respiratory_disease_over5_provided_med"
    t.integer  "fever_under5"
    t.integer  "fever_under5_Provided_med"
    t.integer  "fever_over5"
    t.integer  "fever_over5_provided_med"
    t.integer  "anemia_under5"
    t.integer  "anemia_under5_provided_med"
    t.integer  "anemia_over5"
    t.integer  "anemia_over5_provided_med"
    t.integer  "referred_to_hf_under5"
    t.integer  "referred_to_hf_over5"
    t.integer  "eye_disease_weakness"
    t.integer  "eye_disease_red_eye"
    t.integer  "eye_disease_conjunctivitis"
    t.integer  "eye_disease_cataract"
    t.integer  "eye_disease_provided_med"
    t.integer  "eye_disease_referred"
    t.integer  "suspected_tb_cases"
    t.integer  "diagnosed_tb_cases"
    t.integer  "lhw_assisted_cases"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "role_id"
  add_index "roles_users", ["user_id"], :name => "user_id"

  create_table "special_task_details", :force => true do |t|
    t.integer  "special_task_id"
    t.string   "dpiu_visited"
    t.string   "lhs_visited"
    t.string   "lhw_visited"
    t.string   "task_assigned"
    t.text     "report"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "support_group_meeting_details", :force => true do |t|
    t.integer  "support_group_meeting_id"
    t.integer  "lhw_code"
    t.integer  "number_of_groups_formed"
    t.integer  "members_in_group_a"
    t.integer  "members_in_group_b"
    t.integer  "members_in_group_c"
    t.integer  "members_in_group_d"
    t.datetime "last_support_group_meeting"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "photo_url"
  end

  create_table "tehsils", :force => true do |t|
    t.string "tehsil_id",     :limit => 4
    t.string "district_name", :limit => 20
    t.string "tehsil_name",   :limit => 20
    t.string "active",        :limit => 1
    t.string "maxemis",       :limit => 8
  end

  add_index "tehsils", ["tehsil_id"], :name => "Tehsil_Id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name",                                     :null => false
    t.integer  "district_id",                              :null => false
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "is_active",              :default => true, :null => false
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "username"
  end

  add_index "users", ["district_id"], :name => "district_id"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "visitors", :force => true do |t|
    t.string  "device_id",        :limit => 15, :null => false
    t.string  "name",                           :null => false
    t.integer "district_id",                    :null => false
    t.string  "designation",                    :null => false
    t.integer "schools_assigned",               :null => false
  end

  add_index "visitors", ["device_id"], :name => "Device_id", :unique => true

end
