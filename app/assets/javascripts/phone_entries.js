//= require datatable_helpers

if ($('#phone_entries_controller').length)
{		
	if ($('.show_action').length)
	{
		console.log ("Phone Entry Show Action");	
		
		$(document).ready(function() {

			$('a#first.thumbnail').click(function(e) {
				e.preventDefault()
				$('.myModal').modal({
					show: true, 
					backdrop: false,
					keyboard: true
				 })
			});
			
			$('a#second.thumbnail').click(function(e) {
				e.preventDefault()
				$('#Modal2').modal({
					show: true, 
					backdrop: false,
					keyboard: true
				 })
			});

		});
		
	}
	
	if ($('.index_action').length)
	{
		console.log ("Phone Entry Index Action");	
		
		$(document).ready(function() 
		{
			$(".poppable").popover(); //Always place this before applying datatables
			apply_entries_datatable();
		});
		
		
		function apply_entries_datatable()
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
