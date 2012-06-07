if ($('#provinces_controller').length)
{
	if ($('.indicators_report_action').length)
	{
		console.log ("Provinces - Overall School Reports");
			
		var loading_functions = new Object();
		loading_functions["Barchart"] = new Object();
		loading_functions["Trend"] = new Object();
		var preloading_functions = new Object();
		var current_visualization = "ReportingBirthDeath_live_births";
		var current_visualization_type = "Barchart";
	
		$(document).ready(function() 
		{
			indicator_script()
			apply_indicators_datatable()
		})
	}
	
	if ($('.compliance_report_action').length)
	{
		console.log ("Provinces - Districts Overall Reports");	
		var loading_functions = new Object();
		var preloading_functions = new Object();
		var map_reload = 1;
		var current_visualization = "total_compliance_barchart";
		var current_visualization_type = "barchart"
		
		$(document).ready(function() 
		{
			$("#color-legend").popover
			(
				{
					placement: 'left',
					content: color_legend()
				} 
			); 
			//$("#test").tooltip();
			Gmaps.map.callback = function() 
			{			
				create_entries_legend();
				setup_polygons();
			//	color_polygons();
			}
			
			preloading_functions[current_visualization_type]();
			loading_functions[current_visualization]();
			
			$("#total_compliance_barchart_link").click(function () 
			{
				current_visualization = "total_compliance_barchart";
				
				if (current_visualization_type != "barchart")
				{
					current_visualization_type = "barchart";
					preloading_functions[current_visualization_type]();
				}
								
				loading_functions[current_visualization]();
				$("#help_bar").html(
					"This chart displays a <strong>snap-shot view</strong> of the <strong>total number of phone entries submitted</strong> by officers from each district as a <strong>percentage of the total number of phone entries expected</strong> from them (compliance). A <strong>better compliance percentage</strong> shows that a district is achieving <strong>a quantitatively higher standard</strong> in it's phone-based reporting/monitoring activities."
				);
				$("#visualization_selector").html($("#total_compliance_barchart_link").html()+"<span class=\"caret\"></span>");
				$("#visualization_type").html("Overall Barchart - Compliance Report");
			});
			
			$("#total_compliance_trend_link").click(function () 
			{
				current_visualization = "total_compliance_trend";
				
				if (current_visualization_type != "graph")
				{
					current_visualization_type = "graph";
					preloading_functions[current_visualization_type]();
				}
				
				loading_functions[current_visualization]();
				$("#help_bar").html(
					"This graph plots the <strong>compliance of the entire province as a percentage across time</strong>. This lets you quickly analyze the usage-trend of <strong>all phone-related activities being conducted by the department</strong>. "
				);
				$("#visualization_selector").html($("#total_compliance_trend_link").html()+"<span class=\"caret\"></span>");
				$("#visualization_type").html("Trend - Compliance Report");
			});
			
			$("#activity_compliance_barchart_link").click(function () 
			{
				current_visualization = "activity_compliance_barchart";
				
				if (current_visualization_type != "barchart")
				{
					current_visualization_type = "barchart";
					preloading_functions[current_visualization_type]();
				}
				
				loading_functions[current_visualization]();
				
				$("#help_bar").html(
					"This chart displays <strong>activity-wise, the total number of phone entries submitted </strong>by monitoring officers from each district within the given time-period as <strong>a percentage of the total number of phone entries expected </strong>from them <strong>for that activity</strong>(activity compliance). A <strong>better compliance percentage</strong> for an activity indicates that a district is achieving <strong> quantitatively greater coverage</strong> in it's phone-based reporting/monitoring activities <strong>for that activity</strong>"
				);
				$("#visualization_selector").html($("#activity_compliance_barchart_link").html()+"<span class=\"caret\"></span>");
				$("#visualization_type").html("Detailed Barchart - Compliance Report");
			});
			
			$('#activity_map_link').on('shown', function (e) 
			{
				current_visualization = "map";
				current_visualization_type = "map";
				
				if (map_reload ==1)
				{
					google.maps.event.trigger(Gmaps.map.serviceObject, 'resize');
					Gmaps.map.fitBounds();
					map_reload = 0;
				}
				
				$("#help_bar").html(
					"This map plots the entries submitted within the given time-period to assist in the analysis of <strong>where monitoring officers are conducting their activities</strong> and identify any <strong>outliers</strong>.  Use the side-panel to filter entries by type. Clusters of entries can be zoomed to see individual entries. Entries can be clicked to view their basic details."
				);
				$("#visualization_selector").html($("#activity_map_link").html()+"<span class=\"caret\"></span>");
				$("#visualization_type").html("Map - Compliance Report");
			})
			apply_compliance_datatable()
		});
		
	}
}