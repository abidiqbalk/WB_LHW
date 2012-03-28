require 'rubygems'
require 'rufus/scheduler'  
scheduler = Rufus::Scheduler.start_new

x = 1 # simple semaphore construct to synchronize import calls. Only two threads will ever be in play here. Check and update of lock should atomic but 
# in this case i don't think it's needed. I hope...

scheduler.every("300s") do
	begin
	if x == 1
		x = 0 # get the lock
		Assessment.import_data
		Mentoring.import_data
		PdPst.import_data
		PdDte.import_data
		x = 1 #release the lock
	else
		puts "Skipping import. Previous cycle not yet complete."
	end
	rescue 
		puts "Something went wrong. Releasing lock."
		x = 1
	end
end