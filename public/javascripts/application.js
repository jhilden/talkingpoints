// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

google.load("jquery", "1.4.2");
google.load("jqueryui", "1.8.0");

google.setOnLoadCallback(function() {
	// extends jQuery to make a non-AJAX POST request
  $.extend({
	  doPost: function(url, params) {
			var markup = '<form id="doPostForm" method="POST" action="' + url + '">' +
			  '<input type="hidden" name="authenticity_token" value="' + window._auth_token + '" />"';	
			$.each(params, function(name, value) {
        markup += '<input type="hidden" name="' + name + '" value="' + value + '" />"';
      });
			markup += "</form>";
			
	    $('body').append(markup);
			$("#doPostForm").submit();
	  }
	});
	
	$(function() {
		$("a.button, input:submit").button();
		$("a.delete").button({icons: {primary: 'ui-icon-trash'}, text: false});
		$("a.edit").button({icons: {primary: 'ui-icon-pencil'}, text: false});
		$("a.create").button({icons: {primary: 'ui-icon-plus'}});
	});
});

// all the code related to specifying coordinates using Google Maps
function specifyCoordinates(latlng) {
	var link = $('<a id="specify-coordinates-link" href="#map_canvas">Specify location coordinates using the map</a>');
  link.bind("click", function() {
		$('#map_canvans').focus();
    map.setMapType(G_HYBRID_MAP);
		
		if (latlng == null) {
			latlng = new GLatLng(42.27535, -83.730839);
	    location_marker = new GMarker(
	      latlng,
	      {title: "new coordinates", draggable: true});
	    map.addOverlay(location_marker);
	    location_marker.openInfoWindowHtml("Drag this marker to the position of the location");
	  }
		
		map.setCenter(latlng, 19);
		
		location_marker.enableDragging();
		GEvent.addListener(location_marker, "dragend", function(newlatlng) {
			var save_coordinates_url = "/locations/" + location_id + "/save_coordinates/"
			save_coordinates_url += newlatlng.lat() + ";" + newlatlng.lng();
			save_coordinates_url.replace(".", ",");
			
			location_marker.openInfoWindowHtml(
			  'New coordinates: ' + newlatlng.lat() + ', ' + newlatlng.lng() + '<br />' +
			  '<a id="save-coordinates-link" href="#">Save</a> <a id="reset-coordinates-link" href="#">Reset</a>'
			);
			// using .live() here because .bind() wasn't working
			$("#reset-coordinates-link").live("click", function() {
        location_marker.closeInfoWindow();
        location_marker.setLatLng(latlng);
        return false;
      })
      $("#save-coordinates-link").live("click", function() {
				// instead of building the form on the fly on save, we could also put it into the infoWindow right away
        $.doPost("/locations/" + location_id, {
          _method: "put",
          commit: "Update",
          'location[lat]': newlatlng.lat(),
          'location[lng]': newlatlng.lng()
        });
        return false;
      })
		});
	  
		$('#map_canvas').addClass("specify_coordinates_mode");
		if ($("#specify_coordinates_message").length == 0) {
			$('#map_canvas').before('<div id="specify_coordinates_message">Drag the marker to a more precise location</div>');
		}
  });
	
  $('p#coordinates').append(link);
}
