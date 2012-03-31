//= require gmaps4rails/googlemaps.js
//= require datatable_helpers

if ($('#users_controller').length)
{		
	if ($('.compliance_report_action').length)
	{
		console.log ("User Compliance Report");	
		
		$(document).ready(function() {
			
		$("table#user_compliance_dtable").dataTable( {
			"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
			"sPaginationType": "bootstrap",
			"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
			"aoColumnDefs": [
			{ "bSortable": false, "aTargets": [ 5 ] },
			{ "bVisible": false, "aTargets": [ 2,4 ] },
			 { "iDataSort": 2, "aTargets": [ 1 ] },
			 { "iDataSort": 4, "aTargets": [ 3 ] },
			],
			"aaSorting": [[ 1, "desc" ]],
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
	
} );


		});
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