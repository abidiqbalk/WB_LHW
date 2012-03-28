// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree ../../../vendor/assets/javascripts
//= require cocoon
//= require google-code-prettify
//= require jquery.observe_field
//= require gmaps4rails/googlemaps.js
//= require jquery.dataTables
//= require_tree .


$("*[data-spinner]").live('ajax:beforeSend', function(e){
  $($(this).data('spinner')).show();
  e.stopPropagation(); //Don't show spinner of parent elements.
});
$("*[data-spinner]").live('ajax:complete', function(){
  $($(this).data('spinner')).hide();
});

$(document).ready(function() {
	$('a.dropdown-toggle').dropdown(); //little fix to let dropdowns work with single clicks
	$("#loading").hide();
	$("#stuff").show("fast");
	$('.calendar_field').datepicker({dateFormat: "dd-mm-yy"});
});