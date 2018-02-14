//@author : Zakaria Khattabi
//Script for launching wkt map with Open Layer

function execute(data){
	(function(){
		var WKT = []; // Array contains lists of all WKT polygons extrated from SPARQL request
		var labels = []; // Array contains lists of all labels polygons extrated from SPARQL request
		var colorSelect = "#4ff7f7";
		var varNames = [];
		if(data.results.bindings.length==0) {
			alert("no results to show");
		} else {
			varNames = data.head.vars;
			$.each(data.results.bindings, function(key, val) {	
				WKT.push(val[varNames[0]]['value']);
				labels.push(val[varNames[1]]['value']);
			});
		}
		
		// Map configuration
		var map = L.map('map').setView([0, 0], 10);
		// Add map box tile
		L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
			attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
			maxZoom: 18,
			id: 'dlift.b4e0fe33',
			accessToken: 'pk.eyJ1IjoiZGxpZnQiLCJhIjoiMGRhOTQyM2NmNjkyN2E5ZDliYjdlYjhmZjk0MmRkMzQifQ.Jr2TI6X6zPRjpQAsYhX_PQ'
		}).addTo(map);
		
		//Create feature group
		var fGroup = new L.featureGroup();
		//Iterate dynamicly in all present polygons
		$.each(WKT,function(index,value){
			var feature = transformToGeoJson(value, fGroup, map);
			feature.bindPopup(labels[index]);
		});
		fGroup.addTo(map); // Add it to the map
		
		// bounds map on layers
		map.fitBounds(fGroup.getBounds(), {padding: [0,0]});
		//Function to transformate WKT geometries to GeoJson
		function transformToGeoJson(WKT, fGroup, map) {
			var wkt = new Wkt.Wkt();
			// Read wkt
			try { // Catch any malformed WKT strings
                wkt.read(WKT);
            } catch (e1) {
                try {
                    wkt.read(WKT.replace('\n', '').replace('\r', '').replace('\t', ''));
                } catch (e2) {
                    if (e2.name === 'WKTError') {
                        console.log('Could not understand the WKT string. Check that you have parentheses balanced, and try removing tabs and newline characters.');
                        return;
                    }
                }
            }
			// Convert to object
			var obj = wkt.toObject({
                icon: new L.Icon({
                    iconUrl: 'red_dot.png',
                    iconSize: [16, 16],
                    iconAnchor: [8, 8],
                    shadowUrl: 'dot_shadow.png',
                    shadowSize: [16, 16],
                    shadowAnchor: [8, 8]
                }),
                editable: true,
                color: '#AA0000',
                weight: 3,
                opacity: 1.0,
                editable: true,
                fillColor: '#AA0000',
                fillOpacity: 0.2
            });
			
			// Draw geometries
            if (Wkt.isArray(obj)) { // Distinguish multigeometries (Arrays) from objects
                for (i in obj) {
                    if (obj.hasOwnProperty(i) && !Wkt.isArray(obj[i])) {
						obj[i].addTo(map);
						fGroup.addLayer(obj[i]);
                    }
                }
            } else {
				obj.addTo(map);
				fGroup.addLayer(obj);
            }
			return obj;
		}
	})();
}