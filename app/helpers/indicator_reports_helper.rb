module IndicatorReportsHelper

	def indicator_barchart(collection, indicator, width='auto', height='auto',font_size='automatic', label_count='automatic', slanted_text='automatic', text_angle='automatic')
		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('string', 'Name')
		data_table.new_column('number', indicator.full_name)
		
		collection.sort! { |a,b| b.get_indicator_value(indicator) <=> a.get_indicator_value(indicator) }
		
		for unit in collection
			data_table.add_row([unit.name.titleize, unit.get_indicator_value(indicator)])
		end
		
		opts   = {:height=> height ,:chartArea=> {:top => 5, :height=> "95%"}, :vAxis => {:textStyle=>{:fontSize => font_size}}, :animation => {:duration => '2000', :easing => 'inAndOut'},:hAxis => {:viewWindowMode=> 'explicit',:viewWindow=>{:min=>0},:minvalue => 0}}
		@barchart = GoogleVisualr::Interactive::BarChart.new(data_table, opts)
		
		return @barchart
	end

	def indicator_graph(collection,indicator, width='auto', height='auto', label_count='automatic', slanted_text='automatic', text_angle='automatic')
		line_series = Hash.new

		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('string', 'Name')
		data = []
		
		[*collection].each_with_index {|unit, index|
			data_table.new_column('number', indicator.full_name + " for " + unit.name.titleize)
			data.append(unit.get_indicator_values(indicator))
			line_series[index.to_s] = {:lineWidth => 3+(1*index),:pointSize => 7+(1*index)}
		}
		
		data_table.new_column('boolean' , nil, nil, 'certainty')
		
		[*data].last.each_key {|key| 
			result = []
			[*data].each {|unit|
				
				result.append(unit[key])
			}
			data_table.add_row([key]+ result.flatten+[true])
		}
		
=begin	for projected values
		if Time.now.prev_month.beginning_of_month<=@start_time.beginning_of_month 
			projected_values = []
			[*collection].each_with_index {|unit, index|
				gradient = data_table.rows[data_table.rows.size-1][index+1].v - data_table.rows[data_table.rows.size-2][index+1].v
				projected_value = data_table.rows[data_table.rows.size-1][index+1].v + gradient 
				
				if projected_value < 0
					projected_value =0
					else if projected_value > 100
						projected_value = 100
					end
				end
				projected_values.append(projected_value)
			}

			data_table.add_row([(@start_time+1.month).strftime("%b %y ")]+ projected_values +[false])
		end
=end
		opts   = {:height=> height ,:chartArea=> {:top => 25, :height=> "85%", :width=>"90%"},:lineWidth => 3,:pointSize => 7, :series => line_series, :curveType=> "function",:legend=>{:position=>"top"}, :animation => {:duration => '2000', :easing => 'linear'},:vAxis => {:viewWindowMode=> 'explicit',:viewWindow=>{:min=>0,:minvalue => 0}}}
		@barchart = GoogleVisualr::Interactive::LineChart.new(data_table, opts)
		
		return @barchart
	end
	
end
