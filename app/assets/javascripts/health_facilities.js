if ($('#health_facilities_controller').length)
{	
	if ($('.indicators_report_action').length)
	{
		console.log ("Facilities - Indicators Reports");	
		
		var loading_functions = new Object();
		loading_functions["Trend"] = new Object();
		var preloading_functions = new Object();
		var current_visualization = "ReportingBirthDeath_live_births";
		var current_visualization_type = "Trend";
	
		$(document).ready(function() 
		{
			indicator_script()
		})
	}
}