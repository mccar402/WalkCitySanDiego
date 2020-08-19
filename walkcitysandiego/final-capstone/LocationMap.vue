<template>
  <div>
    <div>
      <div id="map"></div>
    </div>
  </div>
</template>

<script>

import mapboxgl from "mapbox-gl";
import locationService from "@/services/LocationService";
export default {
    name: "map",
    data(){
      return {
        accessToken: 'pk.eyJ1IjoibWFyZ2FyZXRncmVlbiIsImEiOiJja2Rvb3V5MHAwNXczMndqenNudGoyNTI3In0.zFDXY091qT3Xx0NslvQuTA',
        locations: [{
      locationId: '',
      name: '',
      description: '',
      bannerImgURL: '',
      smallImgURL: '',
      categories: '',
      longitudeX: '',
      latitudeY: '',
    
        }]
      };
    },
    methods: {
      getMarkers(){ 

        }
      
    }, 
    created() {
      
      }, 
    mounted() {
      locationService
     .getLocations()
     .then((response) => {
       this.locations = response.data;
      mapboxgl.accessToken = this.accessToken;
   const map = new mapboxgl.Map({
     container: "map",
      style: "mapbox://styles/mapbox/streets-v11",
      center: [-117.144596, 32.734252],
      zoom: 15,
    });

    this.locations.forEach(marker => {
      // create the popup
var popup = new mapboxgl.Popup({ offset: 25 }).setText(
marker.name
);
      new mapboxgl.Marker()
      .setLngLat([marker.longitudeX, marker.latitudeY])
      .setPopup(popup
      )
      .addTo(map)
    }); 
     })
     .catch((err) => {
       console.log(err + ": ACK! No locations available.");
     });
  }, 

};

</script>

<style>
body {
  margin: 0;
  padding: 0;
}

#map {
  position: absolute;
  top: 0;
  bottom: 0;
  width: 100%;
}

.marker {
  background-image: url("https://cdn.rawgit.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png");
  background-size: cover;
  width: 25px;
  height: 25px;
  border-radius: 50%;
  cursor: pointer;
}

.mapboxgl-popup {
  max-width: 200px;
}

.mapboxgl-popup-content {
  text-align: center;
  font-family: "Open Sans", sans-serif;
}
</style>