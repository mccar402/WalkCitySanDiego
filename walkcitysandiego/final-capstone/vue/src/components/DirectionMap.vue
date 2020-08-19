<template>
  <div>
    <div>
      <div id="direction-map"></div>
    </div>
  </div>
</template>

<script>
// THIS FILE IS NO LONGER USED
import mapboxgl from "mapbox-gl";

export default {
  name: "direction-map",
  data() {
    return {
      directionMap: {},
      // currentLocation: this.$store.state.activeLocation
    };
  },
  props: ["location"],
  methods: {
    initializeMap() {
      mapboxgl.accessToken = this.$store.state.mapboxToken;
      let map = new mapboxgl.Map({
        container: "direction-map",
        style: "mapbox://styles/mapbox/streets-v11",
        center: [this.location.longitudeX, this.location.latitudeY],
        zoom: 15,
      });
      this.getMarkers(map);
      this.getMapNav(map);
      this.getUserLocation(map);
      this.addFullScreen(map);
      this.addDirections(map);
      return map;
    },
    getMarkers(aMap) {
      let popup = new mapboxgl.Popup({ offset: 25 }).setText(
        this.location.name
      );
      new mapboxgl.Marker()
        .setLngLat([this.location.longitudeX, this.location.latitudeY])
        .setPopup(popup)
        .addTo(aMap);
    },
    getMapNav(aMap) {
      const mapNav = new mapboxgl.NavigationControl();
      aMap.addControl(mapNav, "top-left");
    },
    getUserLocation(aMap) {
      const userLocation = new mapboxgl.GeolocateControl({
        trackUserLocation: true,
      });
      aMap.addControl(userLocation);
    },
    addFullScreen(aMap) {
      const fullScreenButton = new mapboxgl.FullscreenControl();
      aMap.addControl(fullScreenButton);
    },
    addDirections(aMap) {
      // Not yet working
      let directions = new mapboxgl.MapboxDirections({
        accessToken: this.$store.state.mapboxToken,
      });
      aMap.addControl(directions, "bottom-left");
    },
  },
  mounted() {
    this.initializeMap().then((response) => {
      this.directionMap = response.data;
    });
  },
};
</script>

<style>
body {
  margin: 0;
  padding: 0;
}

#direction-map {
  position: relative;
  width: 66vw;
  height: auto;
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