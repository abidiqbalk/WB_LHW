require 'open-uri'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE #otherwise it messes up looking for SSL certificate

class Assessment < PhoneEntry

	has_one :detail, :class_name => "AssessmentDetail"	# so all phone-entries have a common interface

	def self.import_data
		puts "Importing assessment"
		ft = GData::Client::FusionTables.new 
		ft.clientlogin(Yetting.fusion_account,Yetting.fusion_password)		
		assessment_google_table = ft.show_tables[2]
		
		last_record = self.order("meta_submission_date").last
		
		if last_record.nil?
			puts "nil record case got run"
			new_records = assessment_google_table.select "*", "ORDER BY '*meta-submission-date*' ASC"
		else
			#we have to assign to because .slice must be the only string method to return the deleted string for some dumb reason...
			last_record = self.order("meta_submission_date").last
			search_after = last_record.meta_submission_date.strftime("%m/%d/%Y %H:%M:%S.%L")
			search_after.slice!(" UTC")
			puts "search after: " + search_after.to_s
			new_records = assessment_google_table.select "*", "WHERE '*meta-submission-date*' >= '#{search_after}' and '*meta-instance-id*' NOT EQUAL TO '#{last_record.meta_instance_id}' ORDER BY '*meta-submission-date*' ASC"
		end
		fields = assessment_google_table.describe
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
					new_assessment = self.new(
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
					new_assessment.build_detail(
						:emis_code => record[fields[11][:name].downcase.to_sym],
						:students_grade3 => record[fields[12][:name].downcase.to_sym],
						:students_grade4 => record[fields[13][:name].downcase.to_sym],
						:students_grade5 => record[fields[14][:name].downcase.to_sym],
						:teachers_present => record[fields[15][:name].downcase.to_sym],
						:tasks_identified => record[fields[16][:name].downcase.to_sym]
					)

					new_assessment.save!
					unless new_assessment.photo_url.nil?
						new_assessment.update_attribute(:photo,open(new_assessment.photo_url))
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
		puts "Imported " +  success_count.to_s + " of " + new_records.count.to_s + " assessment records."
	end
	
	def self.build_statistics(assessment_records,collection)
	
		# logger.fatal assessment_records[1].name
		# logger.fatal collection.find { |instance| instance.name == assessment_records[1].name }
		
		for unit in assessment_records
			instance = collection.find { |instance| instance.name == unit.name }
			#attr_accessor_with_default is deprecated :S
			instance.assessment_count_total = unit.assessment_count_total_c.to_i
			instance.students_grade3_total = unit.students_grade3_total_c.to_i
			instance.students_grade4_total = unit.students_grade4_total_c.to_i
			instance.students_grade5_total = unit.students_grade5_total_c.to_i
			instance.teachers_present_total = unit.teachers_present_total_c.to_i
			instance.tasks_identified_total = unit.tasks_identified_total_c.to_i
			instance.students_grade3_average = unit.students_grade3_average_c.to_f.round(1)
			instance.students_grade4_average = unit.students_grade4_average_c.to_f.round(1)
			instance.students_grade5_average = unit.students_grade5_average_c.to_f.round(1)
			instance.teachers_present_average = unit.teachers_present_average_c.to_f.round(1)
			instance.tasks_identified_average = unit.tasks_identified_average_c.to_f.round(1)
		end
		return collection
	end
	
	def self.indicators(averages)
		a=Indicator.new(:name=>"Students in Grade 3 appearing for paper",:hook => "students_grade3", :entry_type => AssessmentDetail, :statistics_set_array => averages, :alternate_name=>"Grade 3 Assessment")
		b=Indicator.new(:name=>"Students in Grade 4 appearing for paper", :hook => "students_grade4", :entry_type => AssessmentDetail, :statistics_set_array => averages, :alternate_name=>"Grade 4 Assessment")
		c=Indicator.new(:name=>"Students in Grade 5 appearing for paper", :hook => "students_grade5", :entry_type => AssessmentDetail, :statistics_set_array => averages, :alternate_name=>"Grade 5 Assessment")
		d=Indicator.new(:name=>"Teachers Present", :hook => "teachers_present", :entry_type => AssessmentDetail, :statistics_set_array => averages, :alternate_name=>"Teacher Attendance")
		e=Indicator.new(:name=>"Tasks Identified",:hook => "tasks_identified", :entry_type => AssessmentDetail, :statistics_set_array => averages, :alternate_name=>"Tasks Identified for HT")
		return [a,b,c,d,e]
	end

end
