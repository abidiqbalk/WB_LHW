if ($('#clusters_controller').length)
{		
	if ($('.indicators_report_action').length)
	{
		console.log ("Cluster - School Report");	
				
		var loading_functions = new Object();
		loading_functions["Barchart"] = new Object();
		loading_functions["Trend"] = new Object();
		var preloading_functions = new Object();
		var current_visualization = "students_grade3";
		var current_visualization_type = "Barchart";
	
		$(document).ready(function() 
		{
			indicator_script()
		})
	}
}
