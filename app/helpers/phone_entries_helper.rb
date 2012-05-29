module PhoneEntriesHelper
include ActionView::Helpers::UrlHelper
include ActionView::Helpers::TextHelper

	def pretty_print(entry,indicator)
		case indicator.indicator_type
			when "date"
				date = entry.try(indicator.hook)
				if date
					entry.try(indicator.hook).strftime("%A, %B #{entry.try(indicator.hook).day.ordinalize} %Y")
				else
					"Not Recorded"
				end
			when "integer"
				indicator.suffix ? pluralize(entry.try(indicator.hook),indicator.suffix) : entry.try(indicator.hook)
			when "download"
				link_to 'Download attachment', audio_attachment_phone_entry_path(entry)
			when "boolean"
				entry.try(indicator.hook)==0 ? "No" : "Yes"
			else
				entry.try(indicator.hook)
		end
	end
	
	def generate_entry_markers(entries)
		@json = entries.to_gmaps4rails do |entry, marker|
		marker.infowindow render(:partial => "/phone_entries/infowindow", :locals => { :entry => entry})
		 
		marker.picture({
				:picture => image_path(entry.type+".png"),
				:width   => 32,
				:height  => 37
			 })
		  marker.title   "#{entry.detail.class.model_name.human} entry on #{entry.start_time.strftime("%A, %B #{entry.start_time.day.ordinalize} %Y at %I:%M %p")}"
		  marker.sidebar entry.type #worthless hack to store entry type but whatever.
		end
	end
	
	def generate_entry_marker(entry) #gives us the markers for entry+school+ctsc in that order. Brain can't come up with a better way right now.
		@json = entry.to_gmaps4rails do |entry, marker|
				marker.picture({
					:picture => image_path("phones-default.png"),
					:width   => 32,
					:height  => 37
				 })
			marker.title   "#{entry.detail.class.model_name.human} entry on #{entry.start_time.strftime("%A, %B #{entry.start_time.day.ordinalize} %Y at %I:%M %p")}"
			marker.sidebar "Entry"
		end
	end

	def	generate_entry_status(status)
	temp = "The entry is valid"
	'<span class="poppable label label-success" rel="popover" title="The Entry is Valid" data-content=' + "\"#{temp}\"" +' >Ok</span>'
		# case status[0]
			# when "fail"
			  # '<span class="poppable label label-important" rel="popover" title="Unknown EMIS Code" data-content="The entry refers to a school that does not exist in our database">Invalid-Emis</span>'
			# when "warning"
				# temp = "This entry is atleast #{number_to_human(status[1], :units => :distance)} away from its school"
				# '<span class="poppable label label-warning" rel="popover" title="The Entry and School are over 1 km apart" data-content=' + "\"#{temp}\"" +' >Distance</span>'
			# else
				# if status[1] # to handle activities which have no distance like PDDTE
					# temp = "This entry is at most #{number_to_human(status[1], :units => :distance)} away from its school"
				# else
					# temp = "The entry is valid"
				# end
				# '<span class="poppable label label-success" rel="popover" title="The Entry is Valid" data-content=' + "\"#{temp}\"" +' >Ok</span>'
			# end
			
	end
	

end
