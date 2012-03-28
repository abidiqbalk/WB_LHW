if ($('#clusters_controller').length)
{		
	if ($('.school_report_action').length)
	{
		console.log ("Cluster - School Report");	
		
		$(document).ready(function() {
			$("table#cluster_assessments_dtable").dataTable( {
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [{ "bSortable": false, "aTargets": [ 7 ] }],
				"aaSorting": [[2,'desc']],
				"bAutoWidth": false //I need this to fix a bug between bootstrap-tab.js and datatables. Good times...
			
			} );

			$("table#cluster_mentorings_dtable").dataTable( {
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [{ "bSortable": false, "aTargets": [ 9 ] }],
				"aaSorting": [[5,'desc']],
				"bAutoWidth": false //I need this to fix a bug between bootstrap-tab.js and datatables. Good times...
			} );

		});
	}
}
