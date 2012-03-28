//= require gmaps4rails/googlemaps.js
//= require datatable_helpers

if ($('#phone_entries_controller').length)
{		
	if ($('.show_action').length)
	{
		console.log ("Phone Entry Show Action");	
		
		$(document).ready(function() {

			$('a.thumbnail').click(function(e) {
				e.preventDefault()
				$('#myModal').modal({
					show: true, 
					backdrop: false,
					keyboard: true
				 })
			});

		});
	}
}
