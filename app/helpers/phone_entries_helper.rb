module PhoneEntriesHelper
	
	def generate_entry_markers(entries)
		@json = entries.to_gmaps4rails do |entry, marker|
		marker.infowindow render(:partial => "/phone_entries/infowindow", :locals => { :entry => entry})
		 
		case entry.type
			when "Assessment"
			  picture_path = image_path("phones-red.png")
			when "Mentoring"
			  picture_path = image_path("phones-green.png")
			when "PdPst"
			  picture_path = image_path("phones-yellow.png")
			when "PdDte"
			  picture_path = image_path("phones-teal.png")
			else
			  picture_path = image_path("phones-default.png")
			end
		marker.picture({
				:picture => picture_path,
				:width   => 32,
				:height  => 37
			 })
		  marker.title   "#{entry.type} entry on #{entry.start_time.strftime("%A, %B #{entry.start_time.day.ordinalize} %Y at %I:%M %p")}"
		  marker.sidebar entry.type #worthless hack to store entry type but whatever.
		end
	end
	
	def generate_school_markers(entries) #gives us the markers for entry+school+ctsc in that order. Brain can't come up with a better way right now.
		counter = 0
		@json = entries.compact.to_gmaps4rails do |entry, marker|
			counter +=1
			if counter ==1
				marker.picture({
						:picture => image_path("phones-default.png"),
						:width   => 32,
						:height  => 37
					 })
				marker.title   "#{entry.type} entry on #{entry.start_time.strftime("%A, %B #{entry.start_time.day.ordinalize} %Y at %I:%M %p")}"
				marker.sidebar "Entry"
			end
			
			if counter ==2
				if entries[1]==entries[2] #if the school is the ctsc
					picture_path = image_path("star-yellow.png")
					marker.sidebar "CTSC"
				else
					picture_path = image_path("university.png")
					marker.sidebar "School"
				end
				marker.picture({
						:picture => picture_path,
						:width   => 32,
						:height  => 37
					 })
				marker.title   "School - #{entry.name}"
			end
			
			if counter ==3
				marker.picture({
						:picture => image_path("star-yellow.png"),
						:width   => 32,
						:height  => 37
					 })
				marker.title   "CTSC - #{entry.name}"
				marker.sidebar "CTSC"
			end
		end
	end

	def	generate_entry_status(status)
		case status[0]
			when "fail"
			  '<span class="poppable label label-important" rel="popover" title="Unknown EMIS Code" data-content="The entry refers to a school that does not exist in our database">Invalid-Emis</span>'
			when "warning"
				temp = "This entry is atleast #{number_to_human(status[1], :units => :distance)} away from its school"
				'<span class="poppable label label-warning" rel="popover" title="The Entry and School are over 1 km apart" data-content=' + "\"#{temp}\"" +' >Distance</span>'
			else
				if status[1] # to handle activities which have no distance like PDDTE
					temp = "This entry is at most #{number_to_human(status[1], :units => :distance)} away from its school"
				else
					temp = "The entry is valid"
				end
				'<span class="poppable label label-success" rel="popover" title="The Entry is Valid" data-content=' + "\"#{temp}\"" +' >Ok</span>'
			end
			
	end
	

end
