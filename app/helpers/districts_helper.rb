module DistrictsHelper

	def full_districts_activity_table(start_time,end_time)
		data_table = GoogleVisualr::DataTable.new
		# Add Column Headers
		data_table.new_column('string', 'District')
		data_table.new_column('number', 'Number of Schools')
		data_table.new_column('number', 'Number of DTEs Assigned')
		data_table.new_column('number', 'Assessments Conducted')
		data_table.new_column('number', 'Mentorings Conducted')
		data_table.new_column('number', 'PD PST Sessions Attended')
		data_table.new_column('number', 'PD DTE Sessions Attended')
		data_table.new_column('string', 'Actions')

		# Add Rows and Values
		districts = District.find_all_by_district_name(["Okara","Hafizabad"])
		for district in districts
			data_table.add_row([district.district_name.capitalize,
			district.schools.count,
			district.visitors.count,
			district.assessments.where(:start_time=>(start_time..end_time.end_of_day)).count,
			district.mentorings.where(:start_time=>(start_time..end_time.end_of_day)).count,
			district.pd_psts.where(:start_time=>(start_time..end_time.end_of_day)).count,
			district.pd_dtes.where(:start_time=>(start_time..end_time.end_of_day)).count,
			if can? :view_compliance_reports, district
				"#{link_to "View Details", compliance_report_district_path(:id=>district.district_name), :class => 'btn'}"
			end
			]
			)
		end
		
		option = { width: 'auto', height: 'auto', title: 'Overall District Data', page: 'enable', pageSize:4,alternatingRowStyle:true, showRowNumber:false,:allowHtml => true }
		@chart = GoogleVisualr::Interactive::Table.new(data_table, option)
		
		return @chart
	end

	
	def full_districts_activity_timeline
		activity_counts = Hash.new
		District.joins(:phone_entries).count(:group => ["DATE(start_time)","district_name"],
		:conditions => ["start_time >= ? ", '2011-12-19'],
		:order => "DATE(start_time) ASC"
		).collect do |date, count| 
			if activity_counts[date[0]].nil?
				activity_counts[date[0]] = Hash.new(0)
			end
			activity_counts[date[0]][date[1]] = count
		end
				
		data_table_graph = GoogleVisualr::DataTable.new
		data_table_graph.new_column('date'  , 'Date')
		data_table_graph.new_column('number', 'Okara')
		data_table_graph.new_column('number', 'Hafizabad'   )
		
		for activity_count in activity_counts
			data_table_graph.add_rows([[ activity_count[0], activity_count[1]["OKARA"], activity_count[1]["HAFIZABAD"]]])
		end
		
		opts   = { :displayAnnotations => false, :thickness =>2, :displayExactValues=> true, :allowRedraw =>true,
		:displayRangeSelector=> false, :fill => 10, :zoomStartTime =>@start_time-1.day, :zoomEndTime => @end_time }
		@graph = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table_graph, opts)

		return @graph
	end
	
	
	def district_compliance_table(district,start_time,end_time)
		data_table = GoogleVisualr::DataTable.new
		# Add Column Headers
		data_table.new_column('string', 'Name')
		data_table.new_column('number', '<center>Schools Assigned</center>')
		data_table.new_column('number', '<center>Assessments Conducted</center>')
		data_table.new_column('number', '<center>Mentorings Conducted</center>')
		data_table.new_column('number', '<center>PD PST Sessions Attended</center>')
		data_table.new_column('number', '<center>PD DTE Sessions Attended</center>')
		data_table.new_column('string', 'Actions')
=begin 
nice in theory but ineffective in this case
		activity_counts = Hash.new
		District.joins(:phone_entries).where("phone_entries.start_time"=>(start_time..end_time.end_of_day)).count(:group => ["name","type"],
		:order => "DATE(start_time) ASC"
		).collect do |name, count, id| 
			if activity_counts[name[0]].nil?
				activity_counts[name[0]] = Hash.new(0)
			end
			activity_counts[name[0]][name[1]] = count
		end

		# puts activity_counts[0][:PdDte]
		temp_expectation_visits = 15
		temp_expectation_pd = 1
		
		for activity_count in activity_counts
			a_count = activity_count[1]["Assessment"]
			m_count = activity_count[1]["Mentoring"]
			p_count = activity_count[1]["PdPst"]
			d_count = activity_count[1]["PdDte"]
			if a_count < temp_expectation_visits or m_count < temp_expectation_visits or p_count < temp_expectation_pd or d_count < temp_expectation_pd
				data_table.add_row([{v: activity_count[0].titleize, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: temp_expectation_visits, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: a_count, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: m_count, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: p_count, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: d_count, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: "<a href=\"/compliance/officer/#{visitor.id}\">View Details</a>", p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				 ]
				)
			else
				data_table.add_row([activity_count[0].titleize,
				temp_expectation_visits,
				a_count,
				m_count,
				p_count,
				d_count,
				"<a href=\"/compliance/officer/#{visitor.id}\">View Details</a>" ]
				)
			end
		end
=end		

		# Add Rows and Values
		visitors = district.visitors
		temp_expectation_visits = 7
		temp_expectation_pd = 1
		# need to come up with a better way to format rows
		for visitor in visitors
			a_count = visitor.assessments.where(:start_time=>(start_time..end_time.end_of_day)).count
			m_count = visitor.mentorings.where(:start_time=>(start_time..end_time.end_of_day)).count
			p_count = visitor.pd_psts.where(:start_time=>(start_time..end_time.end_of_day)).count
			d_count = visitor.pd_dtes.where(:start_time=>(start_time..end_time.end_of_day)).count
			if a_count < temp_expectation_visits or m_count < temp_expectation_visits or p_count < temp_expectation_pd or d_count < temp_expectation_pd
				data_table.add_row([{v: visitor.name.titleize, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: temp_expectation_visits, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: a_count, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: m_count, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: p_count, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: d_count, p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				{v: "#{link_to "View Details", compliance_report_user_path(:id=>visitor.id)}", p:{style: 'background-color: rgba(255,160,122,0.4);'}},
				 ]
				)
			else
				data_table.add_row([
				visitor.name.titleize,
				temp_expectation_visits,
				a_count,
				m_count,
				p_count,
				d_count,
				"#{link_to "View Details", compliance_report_user_path(:id=>visitor.id)}" ]
				)
			end
		end
		
		option = { sortColumn: 2, width: 'auto', height: 'auto', title: 'Overall District Data', page: 'enable', pageSize:20,alternatingRowStyle:true, showRowNumber:false,:allowHtml => true }
		@chart = GoogleVisualr::Interactive::Table.new(data_table, option)
		
		return @chart
	end

		
	def district_compliance_bar_chart(district, start_time, end_time)
		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('string', 'Name')
		data_table.new_column('number', 'Assessments')
		data_table.new_column('number', 'Mentorings')
		
		activity_counts = Hash.new
		District.joins(:phone_entries).where("phone_entries.start_time"=>(start_time..end_time.end_of_day), "district_name"=>district.district_name).count(:group => ["name","type"],
		:order => "name ASC"
		).collect do |name, count, id| 
			if activity_counts[name[0]].nil?
				activity_counts[name[0]] = Hash.new(0)
			end
			activity_counts[name[0]][name[1]] = count
		end

		for activity_count in activity_counts
			data_table.add_rows([[ activity_count[0], activity_count[1]["Assessment"], activity_count[1]["Mentoring"]]])
		end
		
		opts   = { :width => 'auto', :height => 600, :title => 'DTE Performance', chartArea:{top:0,height:"95%"},
		vAxis: {title: 'Name', titleTextStyle: {color: 'black'}}, axisTitlesPosition: 'none' }
		@barchart = GoogleVisualr::Interactive::BarChart.new(data_table, opts)
		
		return @barchart
	end
	
	def district_activities_timeline(district,start_time,end_time)
		activity_counts = Hash.new
		District.joins(:phone_entries).count(:group => ["DATE(start_time)","type"],
		:conditions => ["start_time >= ? AND district_name = ?", '2012-01-01', district.district_name],
		:order => "DATE(start_time) ASC"
		).collect do |date, count| 
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
		:displayRangeSelector=> false, :fill => 10, :zoomStartTime =>@start_time-1.month, :zoomEndTime => @end_time }
		
		@graph = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table_graph, opts)
		
		return @graph
	end

	
	#----------------------------------------School Reports---------------------------------------------------
	
	def all_indicators_bar_chart_by_collection(collection, indicators)
		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('string', 'Name')
		for indicator in indicators
			data_table.new_column('number', indicator.name)
		end
			
		for unit in collection
			data_table.add_row(  [unit.name.titleize] + indicators.collect do |indicator| unit.send(indicator.call_average_method) end )
		end
		
		opts   = { :width => 'auto', :height => 500, :chartArea => {:left => '35', :top => '30', :height => '85%'}}
		@barchart = GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)
		
		return @barchart
	end
	
	def all_indicators_bar_chart_by_indicator(collection, indicators, collection_names)
		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('string', 'Name')
		line_series = Hash.new
		
		collection_names.each_with_index {|collection_name, index|
			data_table.new_column('number', collection_name.to_s+" Average")
			line_series[index.to_s] = {:type => 'line'}
		}
		for unit in collection
			data_table.new_column('number', unit.name.titleize)
		end

		for indicator in indicators
			data_table.add_row( [indicator.alternate_name] + [indicator.personal_average[0] , indicator.local_average[0] ,indicator.global_average[0] ,indicator.super_global_average[0]].compact! + collection.collect do |unit| unit.send(indicator.call_average_method) end )
		end
		opts   = { :width => 'auto', :height => 500, :chartArea => {:left => '35', :top => '30', :height => '85%'}, :seriesType => 'bars', :series => line_series}
		@barchart = GoogleVisualr::Interactive::ComboChart.new(data_table, opts)
		
		return @barchart
	end
	
	def indicator_combo_chart(collection, indicator, collection_names, width='auto', height='auto', label_count='automatic', slanted_text='automatic', text_angle='automatic')
		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('string', 'Name')
		data_table.new_column('number', indicator.name)
		line_series = Hash.new
		collection_names.each_with_index {|collection_name, index|
			data_table.new_column('number', collection_name.to_s+" Average")
			line_series[(index+1).to_s] = {:type => 'line'}
		}	
		
		for unit in collection
			data_table.add_row([unit.name.titleize, unit.send(indicator.call_average_method)] + indicator.level(collection_names.size-1))
		end
		
		opts   = {:chartArea => {:width => "90%"}, :width => width, :height => height, :legend=> {position: 'top'}, :animation => {:duration => '2000', :easing => 'inAndOut'}, :seriesType => 'bars', :series => line_series, :lineWidth => '5' , :hAxis => {:slantedText => slanted_text, :showTextEvery => label_count, :slantedTextAngle => text_angle}}
		@barchart = GoogleVisualr::Interactive::ComboChart.new(data_table, opts)
		
		return @barchart
	end
	
	def indicator_pie_chart(collection, indicator, width='auto', height='auto')
		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('string', 'Name')
		data_table.new_column('number', indicator.name)

		for unit in collection
			data_table.add_row([unit.name.titleize, unit.send(indicator.call_total_method) ])
		end
		
		opts   = { :width => width, :height => height, :is3D => true}
		@barchart = GoogleVisualr::Interactive::PieChart.new(data_table, opts)
		
		return @barchart
	end
	
	
	def indicator_timeline(indicator, collection_names, width=600, height=500)
		data_table_graph = GoogleVisualr::DataTable.new
		data_table_graph.new_column('date'  , 'Date')
		collection_names.each_with_index {|collection_name, index|
			data_table_graph.new_column('number', collection_name.to_s+" Average")
		}

		indicator.level_count(collection_names.size-1).times {|i|
			month = indicator.date_by_index(collection_names.size-1,i)
			data_table_graph.add_row(
				[month] + indicator.values_by_date(collection_names.size-1,month)
			)
		}
		
		opts   = {:width => width, :height => height, :displayAnnotations => false, :thickness =>2, :displayExactValues=> true,
		:displayRangeSelector=> false, :allowRedraw =>true, :fill => 3, :zoomStartTime =>@start_time-33.days, :zoomEndTime => @end_time+2.day }
		
		@graph = GoogleVisualr::Interactive::AnnotatedTimeLine.new(data_table_graph, opts)
		
		return @graph
	end
	
	def indicator_scatter_chart(collection, indicator, collection_names, width=940, height=500)
		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('number', 'District')
		data_table.new_column('number', indicator.name)
		data_table.new_column('string', nil, nil, 'tooltip')
		
		line_series = Hash.new
		line_series[0] = {visibleInLegend: false}
		collection_names.each_with_index {|collection_name, index|
			data_table.new_column('number', collection_name.to_s+" Average")
			#data_table.new_column('string', nil, nil, 'tooltip')
			line_series[index+1] = { lineWidth: 3, pointSize: 0}
		}
			
		collection.each_with_index {|unit, index|
			data_table.add_row([index, unit.send(indicator.call_average_method), unit.name.titleize + " - " + unit.send(indicator.call_average_method).to_s] + indicator.level(collection_names.size-1,0))
		}
		data_table.add_row([collection.size-0.001, nil, nil] + indicator.level(collection_names.size-1,0))
		opts   = { :width => 'auto', :height => height,
				 :hAxis => {  :textPosition =>'none'}, 
				 :animation => {:duration => '1000'},
				 :vAxis => { :title => indicator.name},
				 :series => line_series }
		@chart = GoogleVisualr::Interactive::ScatterChart.new(data_table, opts)

	end
	
end
