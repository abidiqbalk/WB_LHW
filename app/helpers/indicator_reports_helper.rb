module IndicatorReportsHelper

	def indicator_barchart(collection, indicator, width='auto', height='auto', label_count='automatic', slanted_text='automatic', text_angle='automatic')
		data_table = GoogleVisualr::DataTable.new
		data_table.new_column('string', 'Name')
		data_table.new_column('number', indicator.full_name)
		
		collection.sort! { |a,b| b.get_indicator_value(indicator) <=> a.get_indicator_value(indicator) }
		
		for unit in collection
			data_table.add_row([unit.name.titleize, unit.get_indicator_value(indicator)])
		end
		
		opts   = {:height=> height ,:chartArea=> {:top => 5, :height=> "95%"}, :animation => {:duration => '2000', :easing => 'inAndOut'},:hAxis => {:viewWindowMode=> 'explicit',:viewWindow=>{:min=>0},:minvalue => 0}}
		@barchart = GoogleVisualr::Interactive::BarChart.new(data_table, opts)
		
		return @barchart
	end

end
