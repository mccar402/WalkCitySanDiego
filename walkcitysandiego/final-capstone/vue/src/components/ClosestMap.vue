<template>
  <div class="closest-locations-map">
    <div id="find-closest-map"></div>
  </div>
</template>

<script>
import mapboxgl from "mapbox-gl";

export default {
  name: "find-closest-map",
  data() {
    return {
      mapOfClosest: {},
      defaultLongitude: -117.159619, 
      defaultLatitude: 32.731217, 
      // defaultLongitude: -117.2,
      // defaultLatitude: 32.7,
      distanceArray: Array,
      userCoordinates: "",
    };
  },
  methods: {
    initializeMap() {
      mapboxgl.accessToken = this.$store.state.mapboxToken;
      this.mapOfClosest = new mapboxgl.Map({
        container: "find-closest-map",
        style: "mapbox://styles/mapbox/streets-v11",
        center: [this.defaultLongitude, this.defaultLatitude],
        zoom: 13,
      });
      this.setDefaultMarker();
      this.getMapNav();
      this.getUserLocation();
      this.addFullScreen();
    },
    setDefaultMarker() {
      let popup = new mapboxgl.Popup({ offset: 25 }).setText("You!");
      let userMarker = new mapboxgl.Marker({
        draggable: true,
        color: "red",
      })
        .setLngLat([this.defaultLongitude, this.defaultLatitude])
        .setPopup(popup);

      userMarker.addTo(this.mapOfClosest);
      this.userCoordinates = userMarker.getLngLat();

      console.log(userMarker.getLngLat());

      userMarker.on("dragend", this.findClosest(userMarker));
    },
    getMarkers(locationList) {
      locationList.forEach((marker) => {
        let popup = new mapboxgl.Popup({ offset: 25 }).setText(
          marker.name + ": " + marker.description
        );
        new mapboxgl.Marker()
          .setLngLat([marker.longitudeX, marker.latitudeY])
          .setPopup(popup)
          .addTo(this.mapOfClosest);
      });
    },
    getMapNav() {
      const mapNav = new mapboxgl.NavigationControl();
      this.mapOfClosest.addControl(mapNav, "top-left");
    },
    getUserLocation() {
      const userLocation = new mapboxgl.GeolocateControl({
        trackUserLocation: true,
      });
      this.mapOfClosest.addControl(userLocation);
    },
    addFullScreen() {
      const fullScreenButton = new mapboxgl.FullscreenControl();
      this.mapOfClosest.addControl(fullScreenButton);
    },
    findClosest(marker) {
      const longitudeLatitude = marker.getLngLat();
      console.log(longitudeLatitude);
      this.distanceArray = [];
      const locations = this.$store.state.locations;
      locations.forEach((location) => {
        let locationCoordinates = new mapboxgl.LngLat(
          location.longitudeX,
          location.latitudeY
        );
        let currentDistance = longitudeLatitude.distanceTo(locationCoordinates);
        this.distanceArray.unshift({
          location: location,
          distance: currentDistance,
        });
      });

      this.distanceArray.sort(this.compareDistances);

      let threeClosest = [];
      threeClosest[0] = this.distanceArray[0].location;
      threeClosest[1] = this.distanceArray[1].location;
      threeClosest[2] = this.distanceArray[2].location;

      this.getMarkers(threeClosest);
    },
    compareDistances(locDistance1, locDistance2) {
      if (locDistance1.distance > locDistance2.distance) return 1;
      if (locDistance1.distance < locDistance2.distance) return -1;
      return 0;
    },
  },
  mounted() {
    this.mapOfClosest = this.initializeMap();
  },
};
</script>

<style>
body {
  margin: 0;
  padding: 0;
}

#find-closest-map {
  position: relative;

  width: 45vw;
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

.closest-locations-map {
  height: 100%;
  width: 100%;
}
</style>