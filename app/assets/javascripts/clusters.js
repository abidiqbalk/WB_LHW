if ($('#clusters_controller').length)
{		
	if ($('.school_report_action').length)
	{
		console.log ("Cluster - School Report");	
		
		var last_type = "barchart_1";
		var indicator = new Object();
		var activity_loaded = new Object();
		activity_loaded["assessment"]=0;
		activity_loaded["mentoring"]=0;
		var activity = "assessment";
		
		var chart;

		var loading_functions = new Object();
			
		$(document).ready(function() 
		{
			$('a.dropdown-toggle').dropdown(); //little fix to let dropdowns work with single clicks
			
			$("#Mentorings-Report-link").click(function () 
			{
				activity = "mentoring"
				if (activity_loaded[activity] == 0)
				{
					$('#visualizations_area').hide();
					$.post('mentorings_report', null, null, "script");
					activity_loaded[activity] == 1
				}
				else
				{
					loading_functions[activity][indicator[activity]][last_type]();
				}
			});
			
			$("#Assessments-Report-link").click(function () 
			{
				activity = "assessment"
				loading_functions[activity][indicator[activity]][last_type]();
			});
			
			$("#indicator_barchart_link").click(function () 
			{
				$("#visualization_span").toggleClass("span11", true);
				$("#visualization_span").toggleClass("span12", false);
			});
			
			$("#indicator_scatterplot_link").click(function () 
			{
				$("#visualization_span").toggleClass("span11", false);
				$("#visualization_span").toggleClass("span12",true);
			});
			
			$("#indicator_timeline_link").click(function () 
			{
				$("#visualization_span").toggleClass("span11", false);
				$("#visualization_span").toggleClass("span12",true);
			});
			
			$.post('assessments_report', null, null, "script");			
		});
	}
}
