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

ActiveRecord::Schema.define(:version => 20120414155513) do

  create_table "assessment_details", :force => true do |t|
    t.integer "assessment_id",    :null => false
    t.integer "emis_code"
    t.integer "students_grade3"
    t.integer "students_grade4"
    t.integer "students_grade5"
    t.integer "teachers_present"
    t.integer "tasks_identified"
  end

  add_index "assessment_details", ["assessment_id"], :name => "phone_entry_id"

  create_table "banks", :force => true do |t|
    t.string "bank_id",   :limit => 5
    t.string "bank_desc", :limit => 64
  end

  create_table "clusters", :force => true do |t|
    t.integer "emiscode"
    t.string  "school_name", :limit => 63
    t.string  "district_id", :limit => 17
  end

  add_index "clusters", ["district_id"], :name => "district_id"

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
    t.float   "longitude"
    t.float   "latitude"
    t.float   "altitude"
  end

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

  create_table "markazs", :force => true do |t|
    t.string "markaz_id",   :limit => 6
    t.string "markaz_name", :limit => 30
    t.string "active",      :limit => 1
  end

  add_index "markazs", ["markaz_id"], :name => "markaz_id", :unique => true

  create_table "mentoring_details", :force => true do |t|
    t.integer "mentoring_id",        :null => false
    t.integer "emis_code"
    t.integer "teachers_present"
    t.integer "students_present"
    t.integer "score_indicator1"
    t.integer "score_indicator2"
    t.integer "score_indicator3"
    t.integer "score_indicator4"
    t.integer "tasks_completed"
    t.integer "report_cards_issued"
  end

  add_index "mentoring_details", ["mentoring_id"], :name => "phone_entry_id"

  create_table "pd_dte_details", :force => true do |t|
    t.integer "pd_dte_id",                           :null => false
    t.string  "conducted_at",          :limit => 24
    t.string  "education_officer",     :limit => 22
    t.string  "dtsc_head_te",          :limit => 22
    t.integer "present_dtes"
    t.integer "present_ltes"
    t.string  "activity_monitored_by", :limit => 10
  end

  add_index "pd_dte_details", ["pd_dte_id"], :name => "phone_entry_id"

  create_table "pd_pst_details", :force => true do |t|
    t.integer "pd_pst_id",                            :null => false
    t.string  "emis_code",              :limit => 8
    t.integer "teachers_present"
    t.integer "teachers_absent"
    t.integer "present_dtes"
    t.string  "conducted_by_ctsc_head", :limit => 3
    t.string  "activity_monitored_by",  :limit => 10
  end

  add_index "pd_pst_details", ["pd_pst_id"], :name => "phone_entry_id"

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
    t.decimal   "location_x",                                 :precision => 14, :scale => 10, :null => false
    t.decimal   "location_y",                                 :precision => 14, :scale => 10, :null => false
    t.decimal   "location_z",                                 :precision => 14, :scale => 10, :null => false
    t.decimal   "location_accuracy",                          :precision => 14, :scale => 10
    t.datetime  "created_at",                                                                 :null => false
    t.datetime  "updated_at",                                                                 :null => false
    t.string    "photo_file_name"
    t.string    "photo_content_type"
    t.integer   "photo_file_size"
    t.datetime  "photo_updated_at"
    t.string    "photo_url"
  end

  add_index "phone_entries", ["device_id", "end_time"], :name => "idx1", :unique => true
  add_index "phone_entries", ["type"], :name => "type"

  create_table "provinces", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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

  create_table "school_locations", :force => true do |t|
    t.integer "school_location"
    t.string  "school_location_description"
  end

  create_table "school_statuses", :force => true do |t|
    t.string "school_status",      :limit => 1
    t.string "status_description", :limit => 32
  end

  create_table "schools", :force => true do |t|
    t.string    "emiscode",               :limit => 8
    t.string    "school_name",            :limit => 96
    t.string    "district_id",            :limit => 3
    t.string    "markaz_id",              :limit => 6
    t.string    "mauza",                  :limit => 32
    t.string    "address"
    t.string    "village_mohallah",       :limit => 128
    t.string    "uc_name",                :limit => 32
    t.string    "uc_number",              :limit => 8
    t.decimal   "pp_number",                             :precision => 10, :scale => 0
    t.decimal   "na_number",                             :precision => 10, :scale => 0
    t.string    "head_name",              :limit => 32
    t.string    "nidc_no",                :limit => 13
    t.string    "head_charge",            :limit => 1
    t.string    "head_grade",             :limit => 2
    t.string    "resident_phone",         :limit => 16
    t.string    "mobile_phone",           :limit => 16
    t.string    "school_phone",           :limit => 16
    t.string    "Contact_No",             :limit => 16
    t.decimal   "school_status",                         :precision => 10, :scale => 0
    t.timestamp "non_func_date",                                                        :null => false
    t.timestamp "merge_date",                                                           :null => false
    t.decimal   "non_func_reason",                       :precision => 10, :scale => 0
    t.decimal   "school_shift",                          :precision => 10, :scale => 0
    t.decimal   "school_location",                       :precision => 10, :scale => 0
    t.decimal   "gender_register",                       :precision => 10, :scale => 0
    t.string    "school_gender",          :limit => 6
    t.decimal   "gender_studying",                       :precision => 10, :scale => 0
    t.string    "school_level",           :limit => 7
    t.decimal   "school_type",                           :precision => 10, :scale => 0
    t.decimal   "est_year",                              :precision => 10, :scale => 0
    t.decimal   "upgrade_year_pri",                      :precision => 10, :scale => 0
    t.decimal   "upgrade_year_mid",                      :precision => 10, :scale => 0
    t.decimal   "upgrade_year_high",                     :precision => 10, :scale => 0
    t.decimal   "upgrade_year_hsec",                     :precision => 10, :scale => 0
    t.decimal   "bldg_status",                           :precision => 10, :scale => 0
    t.decimal   "bldg_ownship",                          :precision => 10, :scale => 0
    t.decimal   "place_status",                          :precision => 10, :scale => 0
    t.decimal   "construct_type",                        :precision => 10, :scale => 0
    t.decimal   "bldg_condition",                        :precision => 10, :scale => 0
    t.decimal   "area_kanal",                            :precision => 10, :scale => 0
    t.decimal   "area_marla",                            :precision => 10, :scale => 0
    t.decimal   "covered_area",                          :precision => 10, :scale => 0
    t.decimal   "uncover_kanal",                         :precision => 10, :scale => 0
    t.decimal   "uncover_marla",                         :precision => 10, :scale => 0
    t.string    "po_bank_name",           :limit => 64
    t.string    "sc_ac_no",               :limit => 16
    t.timestamp "ac_open_date",                                                         :null => false
    t.decimal   "govt_receive",                          :precision => 10, :scale => 0
    t.decimal   "non_govt_receive",                      :precision => 10, :scale => 0
    t.decimal   "amount_before",                         :precision => 10, :scale => 0
    t.decimal   "amount_after",                          :precision => 10, :scale => 0
    t.decimal   "expenses",                              :precision => 10, :scale => 0
    t.decimal   "sc_meetings",                           :precision => 10, :scale => 0
    t.decimal   "sc_total",                              :precision => 10, :scale => 0
    t.decimal   "sc_women",                              :precision => 10, :scale => 0
    t.decimal   "sc_men",                                :precision => 10, :scale => 0
    t.decimal   "parent_member",                         :precision => 10, :scale => 0
    t.decimal   "teacher_member",                        :precision => 10, :scale => 0
    t.decimal   "general_member",                        :precision => 10, :scale => 0
    t.decimal   "chair_member",                          :precision => 10, :scale => 0
    t.decimal   "new_construct",                         :precision => 10, :scale => 0
    t.decimal   "ft_fund_06",                            :precision => 10, :scale => 0
    t.decimal   "ft_fund_07",                            :precision => 10, :scale => 0
    t.decimal   "ft_expenditure",                        :precision => 10, :scale => 0
    t.decimal   "classrooms",                            :precision => 10, :scale => 0
    t.decimal   "sections",                              :precision => 10, :scale => 0
    t.decimal   "openair_class",                         :precision => 10, :scale => 0
    t.decimal   "drink_water",                           :precision => 10, :scale => 0
    t.decimal   "drink_water_type",                      :precision => 10, :scale => 0
    t.decimal   "electricity",                           :precision => 10, :scale => 0
    t.decimal   "electricity_reasons",                   :precision => 10, :scale => 0
    t.decimal   "toilets",                               :precision => 10, :scale => 0
    t.decimal   "toilets_total",                         :precision => 10, :scale => 0
    t.decimal   "toilet_usable",                         :precision => 10, :scale => 0
    t.decimal   "toilet_needrepair",                     :precision => 10, :scale => 0
    t.decimal   "toilet_teachers",                       :precision => 10, :scale => 0
    t.decimal   "boundary_wall",                         :precision => 10, :scale => 0
    t.decimal   "bwall_complete",                        :precision => 10, :scale => 0
    t.decimal   "main_gate",                             :precision => 10, :scale => 0
    t.decimal   "sewerage",                              :precision => 10, :scale => 0
    t.decimal   "play_ground",                           :precision => 10, :scale => 0
    t.decimal   "circket",                               :precision => 10, :scale => 0
    t.decimal   "football",                              :precision => 10, :scale => 0
    t.decimal   "hockey",                                :precision => 10, :scale => 0
    t.decimal   "badminton",                             :precision => 10, :scale => 0
    t.decimal   "volleyball",                            :precision => 10, :scale => 0
    t.decimal   "table_tennis",                          :precision => 10, :scale => 0
    t.decimal   "other",                                 :precision => 10, :scale => 0
    t.decimal   "teacher_nofurniture",                   :precision => 10, :scale => 0
    t.decimal   "student_nofurniture",                   :precision => 10, :scale => 0
    t.decimal   "library",                               :precision => 10, :scale => 0
    t.decimal   "if_yes",                                :precision => 10, :scale => 0
    t.decimal   "total_books",                           :precision => 10, :scale => 0
    t.decimal   "physics_lab",                           :precision => 10, :scale => 0
    t.decimal   "biology_lab",                           :precision => 10, :scale => 0
    t.decimal   "chemistry_lab",                         :precision => 10, :scale => 0
    t.decimal   "homeconomics_lab",                      :precision => 10, :scale => 0
    t.decimal   "combine_lab",                           :precision => 10, :scale => 0
    t.decimal   "physics_instrument",                    :precision => 10, :scale => 0
    t.decimal   "biology_instrument",                    :precision => 10, :scale => 0
    t.decimal   "chemistry_instrument",                  :precision => 10, :scale => 0
    t.decimal   "home_instrument",                       :precision => 10, :scale => 0
    t.decimal   "com_lab_morning",                       :precision => 10, :scale => 0
    t.decimal   "com_no_morning",                        :precision => 10, :scale => 0
    t.decimal   "useable_morning",                       :precision => 10, :scale => 0
    t.decimal   "student_morning",                       :precision => 10, :scale => 0
    t.decimal   "com_lab_evening",                       :precision => 10, :scale => 0
    t.decimal   "student_evening",                       :precision => 10, :scale => 0
    t.decimal   "nchd_attached_school",                  :precision => 10, :scale => 0
    t.decimal   "if_yes_attached",                       :precision => 10, :scale => 0
    t.decimal   "if_no_attached",                        :precision => 10, :scale => 0
    t.decimal   "nchd_teacher",                          :precision => 10, :scale => 0
    t.decimal   "if_yes_teacher",                        :precision => 10, :scale => 0
    t.decimal   "kachi_boys",                            :precision => 10, :scale => 0
    t.decimal   "kachi_girls",                           :precision => 10, :scale => 0
    t.decimal   "one_boys",                              :precision => 10, :scale => 0
    t.decimal   "one_girls",                             :precision => 10, :scale => 0
    t.decimal   "two_boys",                              :precision => 10, :scale => 0
    t.decimal   "two_girls",                             :precision => 10, :scale => 0
    t.decimal   "three_boys",                            :precision => 10, :scale => 0
    t.decimal   "three_girls",                           :precision => 10, :scale => 0
    t.decimal   "four_boys",                             :precision => 10, :scale => 0
    t.decimal   "four_girls",                            :precision => 10, :scale => 0
    t.decimal   "five_boys",                             :precision => 10, :scale => 0
    t.decimal   "five_girls",                            :precision => 10, :scale => 0
    t.decimal   "Sanctioned",                            :precision => 10, :scale => 0
    t.decimal   "Filled",                                :precision => 10, :scale => 0
    t.string    "MEA_NAME",               :limit => 75
    t.string    "Degrade_Level",          :limit => 7
    t.decimal   "Degrade_Year",                          :precision => 10, :scale => 0
    t.decimal   "chair_parent_member",                   :precision => 10, :scale => 0
    t.decimal   "chair_teacher_memeber",                 :precision => 10, :scale => 0
    t.decimal   "chair_general_member",                  :precision => 10, :scale => 0
    t.string    "non_functional_remarks", :limit => 128
    t.string    "reason",                 :limit => 64
    t.string    "census_flag",            :limit => 1
    t.string    "user_code",              :limit => 8
    t.timestamp "doc",                                                                  :null => false
    t.integer   "class_number",           :limit => 1
    t.string    "town_id",                :limit => 6
    t.string    "town_name",              :limit => 64
    t.string    "tehsil_id",              :limit => 4
    t.integer   "cluster_id",                                                           :null => false
    t.decimal   "ENROL",                                 :precision => 10, :scale => 0
    t.string    "Pec_Teh_id",             :limit => 4
    t.float     "latitude",                                                             :null => false
    t.float     "longitude",                                                            :null => false
    t.float     "altitude",                                                             :null => false
  end

  add_index "schools", ["cluster_id"], :name => "cluster_id"
  add_index "schools", ["district_id"], :name => "district_id"
  add_index "schools", ["emiscode"], :name => "emiscode", :unique => true

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
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "visitors", :force => true do |t|
    t.string  "device_id",            :limit => 15, :null => false
    t.string  "name",                               :null => false
    t.integer "district_id",                        :null => false
    t.string  "designation",                        :null => false
    t.integer "ranking",                            :null => false
    t.integer "expected_assessments",               :null => false
  end

  add_index "visitors", ["device_id"], :name => "Device_id", :unique => true

end
