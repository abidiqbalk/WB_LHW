
function create_entries_legend() 
{
	var legendDiv = document.createElement('DIV');
	var legend = new legendInit(legendDiv, Gmaps.map,entries_legend);
	legendDiv.index = 1;
	Gmaps.map.serviceObject.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legendDiv);
}

function create_schools_legend() 
{
	var legendDiv = document.createElement('DIV');
	var legend = new legendInit(legendDiv, Gmaps.map,schools_legend);
	legendDiv.index = 1;
	Gmaps.map.serviceObject.controls[google.maps.ControlPosition.RIGHT_BOTTOM].push(legendDiv);
}

function legendInit(controlDiv, map,legend) 
{
	// Set CSS styles for the DIV containing the control
	controlDiv.style.padding = '5px';

	// Set CSS for the control border
	var controlUI = document.createElement('DIV');
	controlUI.style.backgroundColor = 'white';
	controlUI.style.borderStyle = 'solid';
	controlUI.style.borderWidth = '1px';
	controlUI.style.opacity = '0.9';
	controlUI.title = 'Legend';
	controlDiv.appendChild(controlUI);

	// Set CSS for the control text
	var controlText = document.createElement('DIV');
	controlText.style.fontFamily = 'Arial,sans-serif';
	controlText.style.fontSize = '12px';
	controlText.style.paddingLeft = '4px';
	controlText.style.paddingRight = '4px';
	controlText.style.paddingTop = '4px';
	controlText.style.paddingBottom = '4px';
	controlText.style.textAlign = "left";

	// Add the text
	controlText.innerHTML = legend()
	controlUI.appendChild(controlText);
}

function entries_legend() 
{
	return '<table>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'Assessment\',document.getElementById(\'assessment_legend\').checked)" id="assessment_legend"><label></label></td><td><img src = '+ gon.assessment_marker +'></td><td>Assessment</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'Mentoring\',document.getElementById(\'mentoring_legend\').checked)" id="mentoring_legend"><label></label></td><td><img src =' + gon.mentoring_marker +'></td><td>Mentoring</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'PdPst\',document.getElementById(\'pdpst_legend\').checked)" id="pdpst_legend"><label></label></td><td><img src = '+ gon.pdpst_marker +'></td><td>PD Day of PSTs</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'PdDte\',document.getElementById(\'pddte_legend\').checked)" id="pddte_legend"><label></label></td><td><img src = '+ gon.pddte_marker +'></td><td>PD Day of DTEs</td></tr>' +
		'</table>';
}

function schools_legend() 
{
	return '<table>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'Entry\',document.getElementById(\'entry_legend\').checked)" id="entry_legend"><label></label></td><td><img src = '+ gon.default_marker +'></td><td>Phone Entry</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'School\',document.getElementById(\'school_legend\').checked)" id="school_legend"><label></label></td><td><img src =' + gon.school_marker +'></td><td>School</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'CTSC\',document.getElementById(\'ctsc_legend\').checked)" id="ctsc_legend"><label></label></td><td><img src = '+ gon.ctsc_marker +'></td><td>CTSC</td></tr>' +
		'</table>';
}

function toggle_markers(entry_type,display_type)
{
	for (var i = 0; i < Gmaps.map.markers.length; i++) 
	{
		if (Gmaps.map.markers[i].sidebar==entry_type)
		{
			Gmaps.map.markers[i].serviceObject.setVisible(display_type);
		}
	}
}

function setup_polygons()
{
	$.each(Gmaps.map.polygons, function(index, value) 
	{ 
		google.maps.event.addListener(value.serviceObject, 'click', function(event) 
		{
			infowindow = new google.maps.InfoWindow
			({
				content: "<h3>"+gon.districts[index]+" : "+ $("td#"+gon.districts[index]).html()+"</h3>"
			});
			infowindow.setPosition(event.latLng);
			infowindow.open(Gmaps.map.serviceObject);
		}); 
	});
}

function color_polygons()
{
	$.each(Gmaps.map.polygons, function(index, value) 
	{ 
		value.serviceObject.setOptions({fillColor: $("tr#"+gon.districts[index]).css("background-color")});
	});
}