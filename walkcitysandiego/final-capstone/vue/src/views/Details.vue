<template>
  <div class="location-details">
    <search-bar/>
    <location-details v-bind:location="this.$store.state.activeLocation"/>
  </div>
</template>

<script>
import LocationDetails from "../components/LocationDetails.vue";
import SearchBar from "../components/SearchBar.vue";
import LocationService from "../services/LocationService.js";

export default {
  name: "details",
  components: {
      LocationDetails,
      SearchBar
  },
  created(){
    const activeLocationId = this.$route.params.id;
    LocationService.getLocationById(activeLocationId).then(response => {
      if(response.status == 200)
        this.$store.commit("SET_ACTIVE_LOCATION", response.data);
    })
    
  }
  
  
};
</script>

<style>
div .location-details {
  display: flex;
  flex-direction: column;
  align-items: center;
}
</style>