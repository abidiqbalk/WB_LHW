if ($('#schools_controller').length)
{		
	if ($('.show_action').length)
	{
		console.log ("School Report");	
		
		$(document).ready(function() {
			$("table#school_assessments_dtable").dataTable( {
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [
				{ "bSortable": false, "aTargets": [ 7 ] },
				{ "bVisible": false, "aTargets": [ 1 ] },
				 { "iDataSort": 1, "aTargets": [ 0 ] },
				],
				"aaSorting": [[0,'desc']],
				"bAutoWidth": false //I need this to fix a bug between bootstrap-tab.js and datatables. Good times...
			
			} );

			$("table#school_mentorings_dtable").dataTable( {
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [
				{ "bSortable": false, "aTargets": [ 9 ] },
				{ "bVisible": false, "aTargets": [ 1 ] },
				 { "iDataSort": 1, "aTargets": [ 0 ] },
				],
				"aaSorting": [[0,'desc']],
				"bAutoWidth": false //I need this to fix a bug between bootstrap-tab.js and datatables. Good times...
			} );

		});
	}
}
