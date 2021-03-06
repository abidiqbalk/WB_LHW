//= require jquery.dataTables

/* Default class modification */
$.extend( $.fn.dataTableExt.oStdClasses, {
	"sWrapper": "dataTables_wrapper form-inline"
} );

/* API method to get paging information */
$.fn.dataTableExt.oApi.fnPagingInfo = function ( oSettings )
{
	return {
		"iStart":         oSettings._iDisplayStart,
		"iEnd":           oSettings.fnDisplayEnd(),
		"iLength":        oSettings._iDisplayLength,
		"iTotal":         oSettings.fnRecordsTotal(),
		"iFilteredTotal": oSettings.fnRecordsDisplay(),
		"iPage":          Math.ceil( oSettings._iDisplayStart / oSettings._iDisplayLength ),
		"iTotalPages":    Math.ceil( oSettings.fnRecordsDisplay() / oSettings._iDisplayLength )
	};
}

/* Bootstrap style pagination control */
$.extend( $.fn.dataTableExt.oPagination, {
	"bootstrap": {
		"fnInit": function( oSettings, nPaging, fnDraw ) {
			var oLang = oSettings.oLanguage.oPaginate;
			var fnClickHandler = function ( e ) {
				e.preventDefault();
				if ( oSettings.oApi._fnPageChange(oSettings, e.data.action) ) {
					fnDraw( oSettings );
				}
			};

			$(nPaging).addClass('pagination').append(
				'<ul>'+
					'<li class="prev disabled"><a href="#">&larr; '+oLang.sPrevious+'</a></li>'+
					'<li class="next disabled"><a href="#">'+oLang.sNext+' &rarr; </a></li>'+
				'</ul>'
			);
			var els = $('a', nPaging);
			$(els[0]).bind( 'click.DT', { action: "previous" }, fnClickHandler );
			$(els[1]).bind( 'click.DT', { action: "next" }, fnClickHandler );
		},

		"fnUpdate": function ( oSettings, fnDraw ) {
			var iListLength = 5;
			var oPaging = oSettings.oInstance.fnPagingInfo();
			var an = oSettings.aanFeatures.p;
			var i, j, sClass, iStart, iEnd, iHalf=Math.floor(iListLength/2);

			if ( oPaging.iTotalPages < iListLength) {
				iStart = 1;
				iEnd = oPaging.iTotalPages;
			}
			else if ( oPaging.iPage <= iHalf ) {
				iStart = 1;
				iEnd = iListLength;
			} else if ( oPaging.iPage >= (oPaging.iTotalPages-iHalf) ) {
				iStart = oPaging.iTotalPages - iListLength + 1;
				iEnd = oPaging.iTotalPages;
			} else {
				iStart = oPaging.iPage - iHalf + 1;
				iEnd = iStart + iListLength - 1;
			}

			for ( i=0, iLen=an.length ; i<iLen ; i++ ) {
				// Remove the middle elements
				$('li:gt(0)', an[i]).filter(':not(:last)').remove();

				// Add the new list items and their event handlers
				for ( j=iStart ; j<=iEnd ; j++ ) {
					sClass = (j==oPaging.iPage+1) ? 'class="active"' : '';
					$('<li '+sClass+'><a href="#">'+j+'</a></li>')
						.insertBefore( $('li:last', an[i])[0] )
						.bind('click', function (e) {
							e.preventDefault();
							oSettings._iDisplayStart = (parseInt($('a', this).text(),10)-1) * oPaging.iLength;
							fnDraw( oSettings );
						} );
				}

				// Add / remove disabled classes from the static elements
				if ( oPaging.iPage === 0 ) {
					$('li:first', an[i]).addClass('disabled');
				} else {
					$('li:first', an[i]).removeClass('disabled');
				}

				if ( oPaging.iPage === oPaging.iTotalPages-1 || oPaging.iTotalPages === 0 ) {
					$('li:last', an[i]).addClass('disabled');
				} else {
					$('li:last', an[i]).removeClass('disabled');
				}
			}
		}
	}
} );


function compliance_format_details ( table, nTr )
{
	var aData = table.fnGetData( nTr );
	var sOut = '<div class="row-fluid">';
	sOut += '<div class="span6"><center><h4>Monitoring Activities</h4></center> <table class="table table-bordered">';
	sOut += '<tr><td class="header">Family Plannings:</td><td class="center">'+aData[5]+'</td></tr>';
	sOut += '<tr><td class="header">Health House:</td><td class="center">'+aData[7]+'</td></tr>';
	sOut += '<tr><td class="header">Maternal:</td><td class="center">'+aData[6]+'</td></tr>';
	sOut += '<tr><td class="header">Support Group Meetings:</td><td class="center">'+aData[8]+'</td></tr>';
	sOut += '<tr><td class="header">Newborn:</td><td class="center">'+aData[9]+'</td></tr>';
	sOut += '<tr><td class="header">Child Health:</td><td class="center">'+aData[10]+'</td></tr>';
	sOut += '<tr><td class="header center">Special Tasks:</td> <td class="center">'+aData[11]+'</td></tr>';
	sOut += '</table></div>'	
	sOut += '<div class="span6"><center><h4>Reporting Activities</h4></center> <table class="table table-bordered">';
	sOut += '<tr><td class="header">Birth Death Reports:</td><td class="center">'+aData[12]+'</td></tr>';
	sOut += '<tr><td class="header">Child Health Reports:</td><td class="center">'+aData[14]+'</td></tr>';
	sOut += '<tr><td class="header">Family Planning Sessions:</td><td class="center">'+aData[13]+'</td></tr>';
	sOut += '<tr><td class="header">Maternal Health Reports:</td><td class="center">'+aData[15]+'</td></tr>';
	sOut += '<tr><td class="header">Treatment Reports:</td><td class="center">'+aData[16]+'</td></tr>';
	sOut += '<tr><td class="header">Community Meeting Reports:</td><td class="center">'+aData[17]+'</td></tr>';
	sOut += '<tr><td class="header">Facility Reports:</td><td class="center">'+aData[18]+'</td></tr>';
	sOut += '</table></div></div>';
	
	return sOut;
}

function add_details_field_datatable(table_name)  // Insert a 'details' column to the table
{
	var nCloneTh = document.createElement( 'th' );
	var nCloneTd = document.createElement( 'td' );
	nCloneTd.innerHTML = '<img class="details" src='+gon.details_open+'>';
	nCloneTd.className = "center";
	
	$('#'+table_name+' thead tr').each( function () {
		this.insertBefore( nCloneTh, this.childNodes[0] );
	} );
	
	$('#'+table_name+' tbody tr').each( function () {
		this.insertBefore(  nCloneTd.cloneNode( true ), this.childNodes[0] );
	} );
}

function register_details_field_click_event(table_name,table)  // Insert a 'details' column to the table
{
	$('#'+table_name+' tbody td img').live('click', function () {
		var nTr = this.parentNode.parentNode;
		if ( this.src.match('details_close') )
		{
			/* This row is already open - close it */
			this.src = gon.details_open;
			table.fnClose( nTr );
		}
		else
		{
			/* Open this row */
			this.src = gon.details_close;
			table.fnOpen( nTr, compliance_format_details(table, nTr), 'details' );
		}
	} );
}
