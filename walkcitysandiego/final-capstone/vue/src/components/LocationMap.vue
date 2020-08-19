<template>
  <div class="location-map">
      <div id="map" ></div>
  </div>
</template>

<script>
import mapboxgl from "mapbox-gl";

export default {
  name: "map",
  data() {
    return {
      map: {}
    };
  },
  props: {
    locations: Array
  },
  methods: {
    initializeMap() {
      mapboxgl.accessToken = this.$store.state.mapboxToken;
      this.map = new mapboxgl.Map({
        container: "map",
        style: "mapbox://styles/mapbox/streets-v11",
        center: [this.locations[0].longitudeX, this.locations[0].latitudeY],
        zoom: 11,
      });
      this.getMarkers();
      this.getMapNav();
      this.getUserLocation();
      this.addFullScreen();
    },
    getMarkers() {
      this.locations.forEach((marker) => {
        // create the popup
        let popup = new mapboxgl.Popup({ offset: 25 }).setText(
          marker.name + ": " + marker.description
        );
        new mapboxgl.Marker()
          .setLngLat([marker.longitudeX, marker.latitudeY])
          .setPopup(popup)
          .addTo(this.map);
      });
    },
    getMapNav() {
      const mapNav = new mapboxgl.NavigationControl();
      this.map.addControl(mapNav, 'top-left');
    },
    getUserLocation() {
      const userLocation = new mapboxgl.GeolocateControl({
        trackUserLocation: true
      });
      this.map.addControl(userLocation);
    },
    addFullScreen() {
      const fullScreenButton = new mapboxgl.FullscreenControl();
      this.map.addControl(fullScreenButton);
    },
    forceRender() {
      this.mapKey += 1;
    },
    updateMap() {
      this.map.jumpTo({ 'center': [this.locations[0].longitudeX, this.locations[0].latitudeY]})
    }
  },
  mounted() {
    this.map = this.initializeMap();
  }
};
</script>

<style>
body {
  margin: 0;
  padding: 0;
}

#map {
  position: relative;
  width: 60vw;
  height: 100%;
}

.location-map{
  height: 100%;
}

.mapboxgl-canvas {
  position: relative;
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