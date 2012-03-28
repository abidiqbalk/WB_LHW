if ($('#districts_controller').length)
{
	if ($('.overall_schools_report_action').length)
	{
		console.log ("Districts - Overall School Reports");
		
		$(document).ready(function() {
			$('a.dropdown-toggle').dropdown(); //little fix to let dropdowns work with single clicks
			$("#loading").hide();
			$("#stuff").show("fast");
			
			$("table#overall_assessments_dtable").dataTable( {
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [{ "bSortable": false, "aTargets": [ 6 ] }],
				"bInfo": false,
				"bAutoWidth": false, //I need this to fix a bug between bootstrap-tab.js and datatables. Good times...
				"fnDrawCallback": function() {
				if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
						$('.dataTables_paginate').css("display", "block");  
						$('.dataTables_length').css("display", "block");
						$('.dataTables_filter').css("display", "block");                        
				} else {
						$('.dataTables_paginate').css("display", "none");
						$('.dataTables_length').css("display", "none");
						$('.dataTables_filter').css("display", "none");
				}
			}
		
		
			} );
	
			$("table#overall_mentorings_dtable").dataTable( {
				"sDom": "<'row'<'span7'l><'span7'f>r>t<'row'<'span7'i><'span7'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [{ "bSortable": false, "aTargets": [ 9 ] }],
				"bInfo": false,
				"bAutoWidth": false, //I need this to fix a bug between bootstrap-tab.js and datatables. Good times...
				"fnDrawCallback": function() {
					if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
							$('.dataTables_paginate').css("display", "none");  
							$('.dataTables_length').css("display", "none");
							$('.dataTables_filter').css("display", "none");                        
					} else {
							$('.dataTables_paginate').css("display", "none");
							$('.dataTables_length').css("display", "none");
							$('.dataTables_filter').css("display", "none");
					}
				}
			} );

			
		});
		
		
	}
	
	
	if ($('.school_report_action').length)
	{
		console.log ("Districts - District School Reports");	
		
		$(document).ready(function() {
			$("table#district_assessments_dtable").dataTable( {
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [{ "bSortable": false, "aTargets": [ 7 ] }],
				"aaSorting": [[2,'desc']],
				"bAutoWidth": false //I need this to fix a bug between bootstrap-tab.js and datatables. Good times...
			
			} );

			$("table#district_mentorings_dtable").dataTable( {
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [{ "bSortable": false, "aTargets": [ 9 ] }],
				"aaSorting": [[5,'desc']],
				"bAutoWidth": false //I need this to fix a bug between bootstrap-tab.js and datatables. Good times...
			} );

		});
	}
	
	
	if ($('.compliance_report_action').length)
	{
		console.log ("Districts - District Compliance Reports");	
					
		$(document).ready(function() {

			$("table#district_compliance_dtable").dataTable( {
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [{ "bSortable": false, "aTargets": [ 7 ] }],
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
	
	
	if ($('.activities_report_action').length)
	{
		console.log ("Districts - Districts Overall Reports");	
		
		$(document).ready(function() {
			$("table#districts_activities_dtable").dataTable( {
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [{ "bSortable": false, "aTargets": [ 7 ] }],
				"bInfo": false,
				"fnDrawCallback": function() {
						if (Math.ceil((this.fnSettings().fnRecordsDisplay()) / this.fnSettings()._iDisplayLength) > 1)  {
								$('.dataTables_paginate').css("display", "block");  
								$('.dataTables_length').css("display", "block");
								$('.dataTables_filter').css("display", "block");                        
						} else {
								$('.dataTables_paginate').css("display", "none");
								$('.dataTables_length').css("display", "none");
								$('.dataTables_filter').css("display", "none");
						}
					}
			} );
		});
	}
}
