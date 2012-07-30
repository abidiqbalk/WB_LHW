require 'rubygems'
require 'rufus/scheduler'  
scheduler = Rufus::Scheduler.start_new

fp_lock = 1 # simple semaphore construct to synchronize import calls. Only two threads will ever be in play here. Check and update of lock should atomic but 
# in this case i don't think it's needed. I hope...

scheduler.every("300s") do
	begin
	if fp_lock == 1
		fp_lock = 0 # get the lock

		ChildHealth.import_data
		HealthHouse.import_data
		Maternal.import_data 
		Newborn.import_data 
		SpecialTask.import_data
		SupportGroupMeeting.import_data
	 	FpClient.import_data
		
		ReportingCommunityMeeting.import_data
		ReportingFacility.import_data
		ReportingBirthDeath.import_data
 		ReportingChildHealth.import_data
		ReportingFamilyPlanning.import_data 
		ReportingMaternalHealth.import_data
                ReportingTreatment.import_data
		
		fp_lock = 1 #release the lock
	else
		puts "Skipping import. Previous cycle not yet complete."
	end
	rescue Exception => exc
		fp_lock = 1
		puts "Message for the log file #{exc.message}"
		puts exc.backtrace.join("\n")
	end
end
