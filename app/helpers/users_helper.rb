module UsersHelper

	def users_table
		data_table = GoogleVisualr::DataTable.new
		# Add Column Headers
		data_table.new_column('string', 'Username')
		data_table.new_column('string', 'Email')
		data_table.new_column('string', 'Name')
		data_table.new_column('datetime', 'Last login on')
		data_table.new_column('datetime', 'Created on')
		data_table.new_column('string', 'Actions')

		for user in @users
			actions = "<center>#{link_to "Edit", edit_user_path(:id=>user), :class => 'btn'}   "
			if can? :disable_users, user
				if user.is_active?
					actions = actions + "      " + "#{link_to "Disable", disable_account_user_path(:id=>user), :class => 'btn btn-danger', :method=>:post} "
				else
					actions = actions + "      " + "#{link_to "Enable", enable_account_user_path(:id=>user), :class => 'btn btn-success', :method=>:post} "
				end
			end
			actions = actions + "</center>"
			
			data_table.add_row([user.username,
			user.email,
			user.name.titleize,
			user.current_sign_in_at,
			user.created_at,
			actions
			]
			)
		end
		
		option = { width: 'auto', height: 'auto', title: 'User Table', page: 'enable', pageSize:30,alternatingRowStyle:true, showRowNumber:false,:allowHtml => true }
		@chart = GoogleVisualr::Interactive::Table.new(data_table, option)
		
		return @chart
	end


	def officer_activities_table(officer,start_time,end_time)
		data_table = GoogleVisualr::DataTable.new
		# Add Column Headers
		data_table.new_column('string', 'School Name')
		data_table.new_column('number', 'EMIS Code')
		data_table.new_column('string', 'Activity Conducted')
		data_table.new_column('datetime', 'Conducted On')
		data_table.new_column('datetime', 'Received On')
		data_table.new_column('string', 'Actions')

		# Add Rows and Values
		phone_entries = officer.phone_entries.where(:start_time=>(start_time..end_time.end_of_day)).order("DATE(start_time) DESC")
		for phone_entry in phone_entries
			school = phone_entry.detail.school
			if school.nil? 
				unless phone_entry.type=="PdDte"
					school_name = "No school found with this EMIS Code"
				else
					school_name = "N/A"
				end
			else 
				school_name = school.school_name
			end
			
			if school_name == "No school found with this EMIS Code" and phone_entry.type!="PdDte"
				data_table.add_row([
				{v: school_name, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: phone_entry.detail.emis_code.to_i, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: phone_entry.type, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: phone_entry.start_time, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: phone_entry.meta_submission_date, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: "#{link_to "View Details", phone_entries_path(:id=>phone_entry.id)}", p:{style: 'background-color: rgba(255,160,122,0.4);'}}
				 ]
				)
			else
				data_table.add_row([
				school_name,
				phone_entry.detail.emis_code.to_i,
				phone_entry.type,
				phone_entry.start_time,
				phone_entry.meta_submission_date,
				 "#{link_to "View Details", phone_entries_path(:id=>phone_entry.id)}"
				 ]
				)
			end
			
		end
		
		option = { width: 'auto', height: 'auto', title: 'Officer Data', page: 'enable', pageSize:25,alternatingRowStyle:true, showRowNumber:false,:allowHtml => true }
		@chart = GoogleVisualr::Interactive::Table.new(data_table, option)
		return @chart
	end
	
	def officer_activities_timeline(officer)
		activity_counts = Hash.new
		officer.phone_entries.where(["start_time >= ?",'2012-01-01']).group(["DATE(start_time)","type"]).count.collect do |date, count| 
			if activity_counts[date[0]].nil?
				activity_counts[date[0]] = Hash.new(0)
			end
			activity_counts[date[0]][date[1]] = count
		end
				
		data_table_graph = GoogleVisualr::DataTable.new
		data_table_graph.new_column('date'  , 'Date')
		data_table_graph.new_column('number', 'Assessments')
		data_table_graph.new_column('number', 'Mentorings')
		data_table_graph.new_column('number', 'PD DTE')
		data_table_graph.new_column('number', 'PD PST')
		
		for activity_count in activity_counts
			data_table_graph.add_rows([[ activity_count[0], activity_count[1]["Assessment"], activity_count[1]["Mentoring"], activity_count[1]["PdPst"], activity_count[1]["PdDte"]]])
		end
		
		opts   = { :displayAnnotations => false, :thickness =>2, :displayExactValues=> true, :allowRedraw =>true,
		:displayRangeSelector=> false, :fill => 10, :zoomStartTime =>@start_time-1.month, :zoomEndTime => @end_time}
		@graph = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table_graph, opts)
		return @graph

	end
	
end
