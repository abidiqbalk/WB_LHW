//= require datatable_helpers

if ($('#users_controller').length)
{	
	if ($('.indicators_report_action').length)
	{
		console.log ("Officers - Officer Indicators Reports");	
		
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
	
	if ($('.compliance_report_action').length)
	{
		console.log ("User Compliance Report");	
		var loading_functions = new Object();
		var preloading_functions = new Object();
		var map_reload = 1;
		var current_visualization = "total_compliance_trend";
		var current_visualization_type = "graph"		
		$(document).ready(function() 
		{
			$(".poppable").popover(); //Always place this before applying datatables
			
			Gmaps.map.callback = function() 
			{			
				create_entries_legend();
				setup_polygons();
			}
		
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
					"This chart displays a <strong>snap-shot view</strong> of the <strong>total number of phone entries submitted</strong> by officers from each district as a <strong>percentage of the total number of phone entries expected</strong> from them (compliance). A <strong>better compliance percentage</strong> shows that a district is achieving <strong>a quantitatively higher standard</strong> in it's phone-based reporting/monitoring activities."
				);
				
				$("#visualization_selector").html($("#total_compliance_trend_link").html()+"<span class=\"caret\"></span>");
				$("#visualization_type").html("Trend - Compliance Report");
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
			
			preloading_functions[current_visualization_type]();
			loading_functions[current_visualization]();
			
			apply_users_datatable();
		});
		
		function apply_users_datatable()
		{
			$("table#entries_dtable").dataTable( 
			{
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [
				{ "bSortable": false, "aTargets": [ 8 ] },
				{ "bVisible": false, "aTargets": [ 4,5 ] },
				 { "iDataSort": 4, "aTargets": [ 6 ] },
				 { "iDataSort": 5, "aTargets": [ 7 ] },
				],
				"aaSorting": [[ 6, "desc" ]],
				"bInfo": true,
				"fnDrawCallback": function() {
						if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
								$('.dataTables_paginate').css("display", "block");  
								//$('.dataTables_length').css("display", "block");
								//$('.dataTables_filter').css("display", "block");                        
						} else {
								$('.dataTables_paginate').css("display", "none");
								//$('.dataTables_length').css("display", "none");
								//$('.dataTables_filter').css("display", "none");
						}
					}
		
			});
		}
	}
}


if (($('#registrations_controller').length) || ($('#users_controller').length))
{		
	if (($('.new_action').length) || ($('.edit_action').length))
	{
		console.log ("New/Edit User");	
		
		$(document).ready(function() {

		$('#user_role_ids_5').click(function(e) {
			if ($('#user_role_ids_5').is(':checked'))
			{
				$('#district_picker').modal({
                show: true, 
                backdrop: false,
                keyboard: true
             })
			}
        });
		


		});
	}
}