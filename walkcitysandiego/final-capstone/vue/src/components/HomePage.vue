<template>
  <div class="location-container">
    <div class="top-locations" v-if="$store.state.categoryFilter === ''">
      <h1 id="top-three">Places You Could Go Right Now!</h1>
      <locations-list v-bind:locations="randomLocations" />
    </div>
    <div class="closest-locations" v-if="$store.state.categoryFilter === ''">
      <h1>Top Spots Closest to You</h1>
      <closest-map id="top-closest-locations" v-bind:locations="$store.state.locations" />
    </div>
    <div class="all-locations">
      <h1 id="list-of-all-locations">All Locations:</h1>
      <locations-list v-bind:locations="filteredLocations" />
    </div>
  </div>
</template>

<script>
import LocationsList from "@/components/LocationsList.vue";
import ClosestMap from "@/components/ClosestMap.vue";

export default {
  name: "home-page",
  components: {
    LocationsList,
    ClosestMap
  },
  computed: {
    randomLocations() {
      const allLocations = this.$store.state.locations;

      const maxNumber = allLocations.length - 1;
      let randomNumbers = [];
      randomNumbers.unshift(this.getRandomInt(maxNumber));
      randomNumbers.unshift(this.getRandomInt(maxNumber));
      randomNumbers.unshift(this.getRandomInt(maxNumber));

      let topRandomLocations = [];
      for (let i = 0; i < allLocations.length; i++) {
        if (randomNumbers.includes(i)) {
          topRandomLocations.unshift(allLocations[i]);
          console.log(allLocations[i]);
        }
      }

      return topRandomLocations;
    },
    filteredLocations() {
      const catFilter = this.$store.state.categoryFilter;
      const locationNameSearch = this.$store.state.searchTerms;

      return this.$store.state.locations.filter((location) => {
        return (
          (catFilter == ""
            ? true
            : null !=
              location.categories.find((category) => {
                return category.name == catFilter;
              })) &&
          (locationNameSearch == ""
            ? true
            : location.name
                .toLowerCase()
                .includes(locationNameSearch.toLowerCase()))
        );
      });
    },
  },
  mounted() {
    this.$store.commit("SET_CATEGORY_FILTER", "");
    this.$store.commit("SET_SEARCH_TERMS", "");
  },
  methods: {
    getRandomInt(max) {
      return Math.floor(Math.random() * Math.floor(max));
    },
  },
};
</script>

<style>
div .location-container {
  display: grid;
  grid-template-columns: 1fr 1fr;
  grid-template-areas:
  "top-three closest-map"
  "all-locations all-locations"
  ;
}
div .location-container {
  grid-area: top-three;
  height: 100%;
}
div .closest-locations {
  grid-area: closest-map;
}
div .all-locations {
  grid-area: all-locations;
}
#top-three {
  margin-bottom: 0;
}

</style>