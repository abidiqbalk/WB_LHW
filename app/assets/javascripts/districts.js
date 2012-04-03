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
		
		function fnFormatDetails ( oTable, nTr )
		{
			var aData = oTable.fnGetData( nTr );
			var sOut = '<table class="table table-bordered">'
			sOut += '<tr><td class="header">Child Health:</td><td>'+aData[6]+'</td><td class="header">Household Health:</td><td>'+aData[7]+'</td></tr>';
			sOut += '<tr><td class="header">Family Planning:</td><td>'+aData[8]+'</td><td class="header">Maternity Report:</td><td>'+aData[9]+'</td></tr>';
			sOut += '<tr><td class="header">Newborn Report:</td><td>'+aData[10]+'</td><td class="header">SG Meeting:</td><td>'+aData[10]+'</td></tr>';
			sOut += '</table>';
			
			return sOut;
		}
		
		$(document).ready(function() {
			/*
			 * Insert a 'details' column to the table
			 */
			var nCloneTh = document.createElement( 'th' );
			var nCloneTd = document.createElement( 'td' );
			nCloneTd.innerHTML = '<img src="<%= asset_path 'details_open.png' %>">';
			nCloneTd.className = "center";
			
			$('#district_compliance_dtable thead tr').each( function () {
				this.insertBefore( nCloneTh, this.childNodes[0] );
			} );
			
			$('#district_compliance_dtable tbody tr').each( function () {
				this.insertBefore(  nCloneTd.cloneNode( true ), this.childNodes[0] );
			} );
			
			var oTable = $("table#district_compliance_dtable").dataTable( {
				"sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
				"sPaginationType": "bootstrap",
				"oLanguage": {"sLengthMenu": "_MENU_ records per page"},
				"aoColumnDefs": [
				{ "bSortable": false, "aTargets": [ 0,5,6,7,8,9,10,11 ] },
				{ "bVisible": false, "aTargets": [ 6,7,8,9,10,11 ] }
				],
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
				
				$('#district_compliance_dtable tbody td img').live('click', function () {
					var nTr = this.parentNode.parentNode;
					if ( this.src.match('details_close') )
					{
						/* This row is already open - close it */
						this.src = "/assets/details_open.png";
						oTable.fnClose( nTr );
					}
					else
					{
						/* Open this row */
						this.src = "/assets/details_close.png";
						oTable.fnOpen( nTr, fnFormatDetails(oTable, nTr), 'details' );
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
