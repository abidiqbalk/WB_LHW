require 'open-uri'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE #otherwise it messes up looking for SSL certificate

class ChildHealthReport < PhoneEntry

	has_one :detail, :class_name => "ChildHealthReportDetail"	# so all phone-entries have a common interface

	def self.import_data
		puts "Importing child_health_report"
		ft = GData::Client::FusionTables.new 
		ft.clientlogin(Yetting.fusion_account,Yetting.fusion_password)		
		child_health_report_google_table = ft.show_tables[4]
		last_record = self.order("meta_submission_date").last
		
		if last_record.nil?
			puts "nil record case got run"
			new_records = child_health_report_google_table.select "*", "ORDER BY '*meta-submission-date*' ASC"
		else
			last_record = self.order("meta_submission_date").last
			search_after = last_record.meta_submission_date.strftime("%m/%d/%Y %H:%M:%S.%L")
			search_after.slice!(" UTC")
			puts "search after: " + search_after.to_s
			new_records = child_health_report_google_table.select "*", "WHERE '*meta-submission-date*' >= '#{search_after}' and '*meta-instance-id*' NOT EQUAL TO '#{last_record.meta_instance_id}' ORDER BY '*meta-submission-date*' ASC"
		end
		fields = child_health_report_google_table.describe
		success_count = 0
		fail_location = 0 
		fail_sim = 0
		duplicate_fail = 0
		records_to_insert=10
		puts "records caught:" + new_records.count.to_s
		#tried using describe to auto-do it but too much hassle. easier to do it explicitly
		for record in new_records 			
			begin
				if records_to_insert==0
					break
				end

				location = record["location".to_sym]
				unless location.nil?
					location.slice!("</coordinates></Point>")
					location.slice!("<Point><coordinates>")
					locations = location.split(",")
				end

				if locations.count!=3
					fail_location = fail_location + 1
				end
				if record["simid".downcase.to_sym].blank?
					fail_sim = fail_sim + 1
				end
				
				unless locations.count!=3 or record["simid".downcase.to_sym].blank?
					new_child_health_report = self.new(
						:meta_instance_id=>record[fields[0][:name].downcase.to_sym],
						:meta_model_version=>record[fields[1][:name].downcase.to_sym],			
						:meta_ui_version=>record[fields[2][:name].downcase.to_sym],			
						:meta_submission_date=>DateTime.strptime(record[fields[3][:name].downcase.to_sym],'%m/%d/%Y %H:%M:%S.%L'),			
						:meta_is_complete=>record[fields[4][:name].downcase.to_sym]	,		
						:meta_date_marked_as_complete=>DateTime.strptime(record[fields[5][:name].downcase.to_sym],'%m/%d/%Y %H:%M:%S.%L'),			
						:device_id=>record[fields[6][:name].downcase.to_sym],			
						:subscriber_id=>record[fields[7][:name].downcase.to_sym],			
						:sim_id=>record[fields[8][:name].downcase.to_sym],			
						:start_time=>record[fields[9][:name].downcase.to_sym].tr("T"," "),			
						:end_time=>record[fields[10][:name].downcase.to_sym].tr("T"," "),			
						:photo_url=>record["photo".to_sym],						
						:location_x=>locations[0],			
						:location_y=>locations[1],			
						:location_z=>locations[2],			
						:location_accuracy=>record["location:Accuracy".downcase.to_sym]			
					)
					new_child_health_report.build_detail(
						:lhw_code => record[fields[11][:name].downcase.to_sym],
						:name => record[fields[12][:name].downcase.to_sym],
						:age => record[fields[13][:name].downcase.to_sym],
						:muac => record[fields[14][:name].downcase.to_sym],
					)

					new_child_health_report.save!
					unless new_child_health_report.photo_url.nil?
						new_child_health_report.update_attribute(:photo,open(new_child_health_report.photo_url))
					end
				
					success_count = success_count + 1
					records_to_insert = records_to_insert -1
				end
			rescue ActiveRecord::RecordNotUnique # we check for duplicates by defining a unique index on device_id and end_time and let the db handle it
				duplicate_fail = duplicate_fail + 1
				puts "Duplicate record found. Not inserting."
			end				
		end
		puts "location_fail: " + fail_location.to_s
		puts "sim_fail: " + fail_sim.to_s
		puts "duplicate_fail: " + duplicate_fail.to_s
		puts "Imported " +  success_count.to_s + " of " + new_records.count.to_s + " child_health_report records."
	end
end
