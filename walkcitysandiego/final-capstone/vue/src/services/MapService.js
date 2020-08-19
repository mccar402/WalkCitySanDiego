// THIS FILE IS NOT USED
import mapboxgl from 'https://api.tiles.mapbox.com/mapbox-gl-js/v1.11.1/mapbox-gl.js'

mapboxgl.accessToken = 'pk.eyJ1IjoiamVmZm1hbm5zIiwiYSI6ImNrZGZ6Zml0aDBqdm8yc3Q1dXNvbGNwOHAifQ.-yQ4_3FzqbuT9eyhojnEIg';

let map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/streets-v11',
    center: [-117.144721, 32.730859],
    zoom: 11
});


// code from the next step will go here!
let geojson = {
    type: 'FeatureCollection',
    features: [{
        type: 'Feature',
        geometry: {
            type: 'Point',
            coordinates: [-117.273008, 32.850230]
        },
        properties: {
            title: 'La Jolla Cove',
            description: 'Dis where it happenin dood'
        }
    },
    {
        type: 'Feature',
        geometry: {
            type: 'Point',
            coordinates: [-117.187565, 32.684737]
        },
        properties: {
            title: 'Coronado Beach',
            description: 'Ayo, imma beach!'
        }
    }]
};

// add markers to map
geojson.features.forEach(function (marker) {

    // create a HTML element for each feature
    let el = document.createElement('div');
    el.className = 'marker';

    // make a marker for each feature and add to the map
    new mapboxgl.Marker(el)
        .setLngLat(marker.geometry.coordinates)
        .setPopup(new mapboxgl.Popup({ offset: 25 }) // add popups
        .setHTML('<h3>' + marker.properties.title + '</h3><p>' + marker.properties.description + '</p>'))
        .addTo(map);
});