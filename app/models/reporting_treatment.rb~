require 'open-uri'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE #otherwise it messes up looking for SSL certificate
=begin
Wraps data-collection functionality for reporting_treatments.

#Schema Information
    Table name: phone_entries
	id                           :integer(4)      not null, primary key
	type                         :string(255)
	meta_instance_id             :string(41)
	meta_model_version           :string(10)
	meta_ui_version              :string(10)
	meta_submission_date         :timestamp
	meta_is_complete             :string(4)
	meta_date_marked_as_complete :timestamp
	device_id                    :string(15)
	subscriber_id                :string(15)
	sim_id                       :string(20)
	start_time                   :timestamp
	end_time                     :timestamp
	location_x                   :decimal(14, 10) not null
	location_y                   :decimal(14, 10) not null
	location_z                   :decimal(14, 10) not null
	location_accuracy            :decimal(14, 10)
	created_at                   :datetime        not null
	updated_at                   :datetime        not null
	photo_file_name              :string(255)
	photo_content_type           :string(255)
	photo_file_size              :integer(4)
	photo_updated_at             :datetime
	photo_url                    :string(255)
=end
class ReportingTreatment < PhoneEntry

	has_one :detail, :class_name =>  "ReportingTreatmentDetail"	# so all phone-entries have a common interface
	acts_as_gmappable :lat => 'location_y', :lng => 'location_x', :process_geocoding => false

=begin
Imports records from google fusion tables via [fusion table gem](https://github.com/troy/fusion-tables). 
Also fetches corresponding phone-entry image from app-spot and saves it via [paperclip](https://github.com/thoughtbot/paperclip)
@note This method is called periodically from the scheduler
=end
	def self.import_data
		puts  "Importing reporting_treatment on #{Time.now}"
		ft = GData::Client::FusionTables.new 
		ft.clientlogin(Yetting.fusion_account,Yetting.fusion_password)		

		reporting_treatment_google_table = ft.show_tables[7]

		



		reporting_treatment_google_table = ft.show_tables[ft.show_tables.index{|x|x.name=="Reporting - Treatment"}]

		
		last_record = self.order("meta_submission_date").last
		
		for table in ft.show_tables
			puts table.name
		end

		if last_record.nil?
			puts  "nil record case got run"
			new_records = reporting_treatment_google_table.select "*", "ORDER BY '*meta-submission-date*' ASC"
		else
			#we have to assign to because .slice must be the only string method to return the deleted string for some dumb reason...
			last_record = self.order("meta_submission_date").last
			search_after = last_record.meta_submission_date.in_time_zone('UTC').strftime("%m/%d/%Y %H:%M:%S")
			search_after.slice!(" UTC")
			puts  "search after: " + search_after.to_s
			new_records = reporting_treatment_google_table.select "*", "WHERE '*meta-submission-date*' >= '#{search_after}' and '*meta-instance-id*' NOT EQUAL TO '#{last_record.meta_instance_id}' ORDER BY '*meta-submission-date*' ASC"
		end

		fields = reporting_treatment_google_table.describe
		success_count = 0
		fail_location = 0 
		fail_sim = 0
		duplicate_fail = 0
		records_to_insert=50
		puts  "records caught:" + new_records.count.to_s
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
					new_reporting_treatment = self.new(
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
						#:photo_url=>record["photo".to_sym],						
						:location_x=>locations[0],			
						:location_y=>locations[1],			
						:location_z=>locations[2],			
						:location_accuracy=>record["location:Accuracy".downcase.to_sym]			
					)
					
					new_reporting_treatment.build_detail(
						:facility_code => record[fields[11][:name].downcase.to_sym],
						:diarrhea_under5 => record[fields[12][:name].downcase.to_sym],
						:diarrhea_under5_provided_med => record[fields[13][:name].downcase.to_sym],
						:diarrhea_over5 => record[fields[14][:name].downcase.to_sym],
						:diarrhea_over5_provided_med => record[fields[15][:name].downcase.to_sym],
						:respiratory_disease_under5=> record[fields[16][:name].downcase.to_sym],
						:respiratory_disease_under5_provided_med=> record[fields[17][:name].downcase.to_sym],
						:respiratory_disease_over5 => record[fields[18][:name].downcase.to_sym],
						:respiratory_disease_over5_provided_med => record[fields[19][:name].downcase.to_sym],
						:fever_under5 => record[fields[20][:name].downcase.to_sym],
						:fever_under5_Provided_med => record[fields[21][:name].downcase.to_sym],
						:fever_over5 => record[fields[22][:name].downcase.to_sym],
						:fever_over5_provided_med => record[fields[23][:name].downcase.to_sym],
						:anemia_under5 => record[fields[24][:name].downcase.to_sym],
						:anemia_under5_provided_med => record[fields[25][:name].downcase.to_sym],
						:anemia_over5 => record[fields[26][:name].downcase.to_sym],
						:anemia_over5_provided_med => record[fields[27][:name].downcase.to_sym],
						:referred_to_hf_under5 => record[fields[28][:name].downcase.to_sym],
						:referred_to_hf_over5 => record[fields[29][:name].downcase.to_sym],
						:eye_disease_weakness => record[fields[30][:name].downcase.to_sym],
						:eye_disease_red_eye => record[fields[31][:name].downcase.to_sym],
						:eye_disease_conjunctivitis => record[fields[32][:name].downcase.to_sym],
						:eye_disease_cataract=> record[fields[33][:name].downcase.to_sym],
						:eye_disease_provided_med=> record[fields[34][:name].downcase.to_sym],
						:eye_disease_referred=> record[fields[35][:name].downcase.to_sym],
						:suspected_tb_cases=> record[fields[36][:name].downcase.to_sym],
						:diagnosed_tb_cases=> record[fields[37][:name].downcase.to_sym],
						:lhw_assisted_cases=> record[fields[38][:name].downcase.to_sym]
					)

					new_reporting_treatment.save!
					#puts record.to_yaml
					#puts new_reporting_treatment.detail.epi_polio_bcg
					#puts record[fields[16][:name].downcase.to_sym].tr("T"," ")

					#unless new_reporting_treatment.photo_url.nil?
					#	new_reporting_treatment.update_attribute(:photo,open(new_reporting_treatment.photo_url))
					#end
				
					success_count = success_count + 1
					records_to_insert = records_to_insert -1
				end
			rescue ActiveRecord::RecordNotUnique # we check for duplicates by defining a unique index on device_id and end_time and let the db handle it
				duplicate_fail = duplicate_fail + 1
				puts  "Duplicate record found. Not inserting."
			end				
		end
		puts  "location_fail: " + fail_location.to_s
		puts  "sim_fail: " + fail_sim.to_s
		puts  "duplicate_fail: " + duplicate_fail.to_s
		puts  "Imported " +  success_count.to_s + " of " + new_records.count.to_s + " reporting_treatment records."
	end
	
=begin
Attaches calculated statistics such as averages and totals to a collection of objects implementing the Reportable Module.
@param [Array of Objects implementing Reportable Module] collection these objects will have the statistics attached to them. 
@param [Array of Objects holding the statistics] reporting_treatment_records these objects contain the necessary statistics that will be attached. 
@return [Array of Objects implementing Reportable Module] the collection object with attached statistics 
=end
	def self.build_statistics(reporting_treatment_records,collection)
		for unit in reporting_treatment_records
			instance = collection.find { |instance| instance.name == unit.name }
			#attr_accessor_with_default is deprecated :S
			instance.reporting_treatment_count_total = unit.reporting_treatment_count_total_c.to_i
			instance.average_monthly_consumption_total = unit.average_monthly_consumption_total_c.to_i
			instance.students_grade4_total = unit.students_grade4_total_c.to_i
			instance.students_grade5_total = unit.students_grade5_total_c.to_i
			instance.teachers_present_total = unit.teachers_present_total_c.to_i
			instance.tasks_identified_total = unit.tasks_identified_total_c.to_i
			instance.average_monthly_consumption_average = unit.average_monthly_consumption_average_c.to_f.round(1)
			instance.students_grade4_average = unit.students_grade4_average_c.to_f.round(1)
			instance.students_grade5_average = unit.students_grade5_average_c.to_f.round(1)
			instance.teachers_present_average = unit.teachers_present_average_c.to_f.round(1)
			instance.tasks_identified_average = unit.tasks_identified_average_c.to_f.round(1)
		end
		return collection
	end

=begin
Builds Indicators associated with activity for a report
@param [Array of statistics] averages a Hash containing statistics (monthly and for a defined time-period) to be used for reporting overall statistics. 
@return [Array of Indicator Objects] An array of indicators associated with the report or activity
=end
	def self.indicators2
		a=Indicator2.new(:hook => "diarrhea_under5", :indicator_activity=>self)
		b=Indicator2.new(:hook => "diarrhea_under5_provided_med", :indicator_activity=>self)
		c=Indicator2.new(:hook => "diarrhea_over5", :indicator_activity=>self)
		d=Indicator2.new(:hook => "diarrhea_over5_provided_med", :indicator_activity=>self)
		e=Indicator2.new(:hook => "respiratory_disease_under5", :indicator_activity=>self)
		f=Indicator2.new(:hook => "respiratory_disease_under5_provided_med", :indicator_activity=>self)
		g=Indicator2.new(:hook => "respiratory_disease_over5",  :indicator_activity=>self)
		h=Indicator2.new(:hook => "respiratory_disease_over5_provided_med", :indicator_activity=>self)
		i=Indicator2.new(:hook => "fever_under5", :indicator_activity=>self)
		j=Indicator2.new(:hook => "fever_under5_Provided_med",  :indicator_activity=>self)
		k=Indicator2.new(:hook => "fever_over5", :indicator_activity=>self)
		l=Indicator2.new(:hook => "fever_over5_provided_med", :indicator_activity=>self)
		m=Indicator2.new(:hook => "anemia_under5", :indicator_activity=>self)
		n=Indicator2.new(:hook => "anemia_under5_provided_med", :indicator_activity=>self)
		o=Indicator2.new(:hook => "anemia_over5", :indicator_activity=>self)
		p=Indicator2.new(:hook => "anemia_over5_provided_med", :indicator_activity=>self)
		q=Indicator2.new(:hook => "referred_to_hf_under5", :indicator_activity=>self)
		r=Indicator2.new(:hook => "referred_to_hf_over5", :indicator_activity=>self)
		s=Indicator2.new(:hook => "eye_disease_weakness", :indicator_activity=>self)
		t=Indicator2.new(:hook => "eye_disease_red_eye", :indicator_activity=>self)
		u=Indicator2.new(:hook => "eye_disease_conjunctivitis", :indicator_activity=>self)
		v=Indicator2.new(:hook => "eye_disease_cataract", :indicator_activity=>self)
		w=Indicator2.new(:hook => "eye_disease_provided_med", :indicator_activity=>self)
		x=Indicator2.new(:hook => "eye_disease_referred", :indicator_activity=>self)
		y=Indicator2.new(:hook => "suspected_tb_cases", :indicator_activity=>self)
		z=Indicator2.new(:hook => "diagnosed_tb_cases", :indicator_activity=>self)
		ab=Indicator2.new(:hook => "lhw_assisted_cases", :indicator_activity=>self)		
		return [a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,ab]
	end
end
