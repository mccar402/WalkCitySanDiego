<template>
  <div class="directions-map">
    <div id="single-destination-map"></div>
    <div class="map-overlay-container">
      <div class="map-overlay">
        <h2 id="overview"></h2>
        <ol id="steps"></ol>
      </div>
    </div>
  </div>
</template>

<script>
import mapboxgl from "mapbox-gl";
import locationService from "@/services/LocationService";

export default {
  name: "single-destination-directions",
  data() {
    return {
      directionsMap: {},
    };
  },
  mounted() {
    // Mapbox token
    mapboxgl.accessToken = this.$store.state.mapboxToken;
    // Sets up query url?
    const transformRequest = (url) => {
      const hasQuery = url.indexOf("?") !== -1;
      const suffix = hasQuery
        ? "&pluginName=lunchboxDirections"
        : "?pluginName=lunchboxDirections";
      return {
        url: url + suffix,
      };
    };

    /* OMG IT IS SYNCING #dontjynx it */
    locationService.getLocationById(this.$route.params.id).then((response) => {
      let currentLocation = response.data;
      let origin = [-117.159619, 32.731217];
      let destination = [currentLocation.longitudeX, currentLocation.latitudeY];

      // Sets up map basics
      let map = new mapboxgl.Map({
        container: "single-destination-map",
        style: "mapbox://styles/mapbox/streets-v11",
        center: [
          (origin[0] + destination[0]) / 2,
          (origin[1] + destination[1]) / 2,
        ],
        zoom: 13,
        transformRequest: transformRequest,
      });

      // UI elements to be populated later
      const overviewText = document.getElementById("overview");
      const stepsText = document.getElementById("steps");

      /* 2. Examine this function, which is called from getDirections() */
      const setOverview = function (route) {
        const routeDistance = route.distance; // in meters, so / 1609.344 later converts to miles
        const routeDuration = route.duration; // in second
        // Pushes the above info into the overviewText div
        overviewText.innerText = `${(routeDistance / 1609.344).toFixed(
          1
        )} miles | ${(routeDuration / 60).toFixed(0)} minutes`;
      };

      /* 3. Examine this, which draws in the route */
      const setRouteLine = function (route) {
        // Geojson wrapper for the data
        const routeLine = {
          type: "FeatureCollection",
          features: [
            {
              properties: {},
              geometry: route.geometry,
            },
          ],
        };
        // Gets the source in the map and pushes the Geojson routeline in there
        map.getSource("route").setData(routeLine);
      };

      /* 6. Now to get the steps to populate in the div */
      const setSteps = function (steps) {
        // Resets text display div
        stepsText.innerText = "";

        // A geojson wrapper for all maneuvers
        const maneuvers = {
          type: "FeatureCollection",
          features: [],
        };

        steps.forEach((step) => {
          const listItem = document.createElement("li");
          listItem.innerText = step.maneuver.instruction;
          stepsText.appendChild(listItem);

          // An individual maneuver
          const maneuver = {
            properties: {
              name: step.name,
              distance: step.distance,
              duration: step.duration,
            },
            geometry: {
              type: "Point",
              coordinates: step.maneuver.location,
            },
          };
          maneuvers.features.push(maneuver);
        });
        // Puts on the map
        map.getSource("maneuvers").setData(maneuvers);
      };

      // 1. Work with this
      const getDirections = function () {
        /* Puts the request together */
        let request = "https://api.mapbox.com/directions/v5/";
        // /walking - uses sidewalks, trails, and ignores vehicular one-way
        // /cycling - tries to route safely, avoiding highways and preferring streets with bike lanes
        request += "mapbox/walking/";
        // Takes origin coordinates, which are given in an array, and joins them with commas; then sticks both locations' coordinates together with a semi-colon
        request += origin.join(",");
        request += ";";
        request += destination.join(",");
        request += "?access_token=" + mapboxgl.accessToken;
        // turns route.geometry from a binary (?) thing into coordinates, which are easier to work with
        request += "&geometries=geojson";
        // The turn-by-turn
        request += "&steps=true";
        // Returns greater geometry detail so that the route path hugs the curves of the roads
        request += "&overview=full";

        console.log(request);

        /* Now let's fetch the request, convert it to JSON, then do stuff with it */
        fetch(request)
          .then((res) => res.json())
          .then((res) => {
            // Retrieves the route
            const route = res.routes[0];
            // Get the steps
            const steps = route.legs[0].steps;

            // Put it on the map
            setOverview(route);
            setRouteLine(route);
            setSteps(steps);
          });
      };

      // marker setup
      const start = new mapboxgl.Marker({
        draggable: true,
        color: "red",
      })
        .setLngLat(origin)
        .addTo(map);

      const end = new mapboxgl.Marker({
        draggable: true,
        color: "blue",
      })
        .setLngLat(destination)
        .addTo(map);

      const onDragEnd = function () {
        origin = start.getLngLat().toArray();
        destination = end.getLngLat().toArray();
        getDirections();
      };

      start.on("dragend", onDragEnd);
      end.on("dragend", onDragEnd);

      /* 4. Once the map loads */
      map.on("load", () => {
        map.addSource("route", {
          type: "geojson",
          data: {
            type: "FeatureCollection",
            features: [],
          },
        });

        // Layer 1: blue route
        map.addLayer(
          {
            id: "routeLayer",
            type: "line",
            source: "route",
            layout: {},
            paint: {
              "line-color": "cornflowerblue",
              "line-width": 10,
            },
          },
          "road-label"
        );

        // Layer 2: arrows, taken from a symbol in the text-field and puts it on the map
        map.addLayer(
          {
            id: "routeArrows",
            source: "route",
            type: "symbol",
            layout: {
              "symbol-placement": "line",
              "text-field": "→",
              "text-rotate": 0,
              "text-keep-upright": false,
              "symbol-spacing": 100,
              "text-size": 22,
              "text-offset": [0, -0.1],
            },
            paint: {
              "text-color": "white",
              "text-halo-color": "white",
              "text-halo-width": 1,
            },
          },
          "road-label"
        );

        map.addSource("maneuvers", {
          type: "geojson",
          data: {
            type: "FeatureCollection",
            features: [],
          },
        });

        map.addLayer(
          {
            id: "maneuverLayer",
            type: "circle",
            source: "maneuvers",
            layout: {},
            paint: {
              "circle-color": "green",
            },
          },
          "poi-label"
        );

        getDirections();
      });

      this.directionsMap = map;
    });
  },
};
</script>

<style>
#single-destination-map {
  position: relative;
  width: 66vw;
  height: 60vh;
}

.mapboxgl-canvas {
  position: relative;
}

.map-overlay-container {
  position: static;
  width: 50%;
  padding: 10px;
  z-index: 1;
}

.map-overlay {
  font: 12px/20px "Helvetica Neue", Arial, Helvetica, sans-serif;
  background-color: #fff;
  border-radius: 3px;
  padding: 10px;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
  height: 300px;
  overflow-x: hidden;
  overflow-y: auto;
}

.map-overlay h2,
.map-overlay p {
  margin: 0 0 10px;
}

</style>