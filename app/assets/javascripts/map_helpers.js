
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
	return '<legend style="margin-bottom:3px;"><h5>Monitoring Activities</h5></legend>' +
		'<table>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'FpClient\',document.getElementById(\'family_planning_legend\').checked)" id="family_planning_legend"><label></label></td><td><img src = '+ gon.markers[9] +'></td><td>Family Planning</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'HealthHouse\',document.getElementById(\'health_house_legend\').checked)" id="health_house_legend"><label></label></td><td><img src =' + gon.markers[8] +'></td><td>Health House</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'Maternal\',document.getElementById(\'maternal_legend\').checked)" id="maternal_legend"><label></label></td><td><img src = '+ gon.markers[10] +'></td><td>Maternal</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'SupportGroupMeeting\',document.getElementById(\'support_group_meeting_legend\').checked)" id="support_group_meeting_legend"><label></label></td><td><img src = '+ gon.markers[12] +'></td><td>Support Group Meeting</td></tr>' +	
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'Newborn\',document.getElementById(\'newborn_legend\').checked)" id="newborn_legend"><label></label></td><td><img src = '+ gon.markers[11] +'></td><td>Newborn</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'ChildHealth\',document.getElementById(\'child_health_legend\').checked)" id="child_health_legend"><label></label></td><td><img src =' + gon.markers[7] +'></td><td>Child Health</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'SpecialTask\',document.getElementById(\'special_task_legend\').checked)" id="special_task_legend"><label></label></td><td><img src =' + gon.markers[13] +'></td><td>Special Task</td></tr>' +
		'</table>' +
			'<br><legend style="margin-bottom:3px;"><h5>Reporting Activities</h5></legend>' +
		'<table>'+
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'ReportingBirthDeath\',document.getElementById(\'reporting_birth_death_legend\').checked)" id="reporting_birth_death_legend"><label></label></td><td><img src = '+ gon.markers[0] +'></td><td>Birth Death Report</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'ReportingFamilyPlanning\',document.getElementById(\'reporting_family_planning_legend\').checked)" id="reporting_family_planning_legend"><label></label></td><td><img src = '+ gon.markers[4] +'></td><td>Family Planning Session</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onClick="toggle_markers(\'ReportingChildHealth\',document.getElementById(\'reporting_child_health_legend\').checked)" id="reporting_child_health_legend"><label></label></td><td><img src = '+ gon.markers[1] +'></td><td>Child Health Report</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onCick="toggle_markers(\'ReportingMaternalHealth\',document.getElementById(\'reporting_maternal_legend\').checked)" id="reporting_maternal_health_legend"><label></label></td><td><img src = '+ gon.markers[5] +'></td><td>Maternal Health Report</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onCick="toggle_markers(\'ReportingTreatment\',document.getElementById(\'reporting_treatment_legend\').checked)" id="reporting_treatment_health_legend"><label></label></td><td><img src = '+ gon.markers[6] +'></td><td>Treatment Report</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onCick="toggle_markers(\'ReportingCommunityMeeting\',document.getElementById(\'reporting_community_meeting_legend\').checked)" id="reporting_community_meeting_legend"><label></label></td><td><img src = '+ gon.markers[2] +'></td><td>Community Meeting Report</td></tr>' +
			'<tr><td><input type="checkbox" checked="checked" onCick="toggle_markers(\'ReportingFacility\',document.getElementById(\'reporting_facility_legend\').checked)" id="reporting_facility_health_legend"><label></label></td><td><img src = '+ gon.markers[3] +'></td><td>Facility Report</td></tr>' +
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
		if (entry_type=="All" || Gmaps.map.markers[i].sidebar==entry_type)
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