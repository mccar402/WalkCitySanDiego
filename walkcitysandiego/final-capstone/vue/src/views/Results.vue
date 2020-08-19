<template>
  <div class="results">
      <search-bar id="search-bar"/>
      <locations-list id="locations-list" v-bind:locations="filteredLocations"/>
      <div id="map-container">
        <location-map id="location-map" v-bind:locations="filteredLocations" />
      </div>
  </div>
</template>

<script>
import SearchBar from "@/components/SearchBar.vue"
import LocationsList from "@/components/LocationsList.vue"
import LocationMap from "@/components/LocationMap.vue"

export default {
    name: 'results',
    components: {
        LocationsList,
        LocationMap,
        SearchBar
    },
    computed: {
    filteredLocations() {
      const catFilter = this.$store.state.categoryFilter;
      const locationNameSearch = this.$store.state.searchTerms;

      return this.$store.state.locations.filter((location) => {
        return ((catFilter == '' ? true : (null != location.categories.find((category) => {
          return category.name == catFilter;
        }))) && (locationNameSearch == '' ? true : (location.name.toLowerCase().includes(locationNameSearch.toLowerCase()))));
      });
    }
  }

}
</script>

<style>

div .results {
    display: grid;
    grid-template-columns: 1fr 2fr;
    gap: 20px;
    grid-template-areas: 
    "searchbar searchbar"
    "locations map";
    justify-items: center;
}
#search-bar {
    grid-area: searchbar;
}
#locations-list {
    width: 33vw;
    height: 100vh;
    grid-area: locations;
    overflow: hidden;
    overflow-y: scroll;
}
#map-container {
    grid-area: map;
    width: 66vw;
    height: 100vh;
}

</style>