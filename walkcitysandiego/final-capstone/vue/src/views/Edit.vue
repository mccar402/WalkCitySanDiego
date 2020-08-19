<template>
  <edit-location v-bind:location="this.$store.state.activeLocation"/>
</template>

<script>
import EditLocation from "../components/EditLocation.vue";
import LocationService from "../services/LocationService.js";
export default {
  name: "edit",
  components: {
    EditLocation
  },
  created(){
    const activeLocationId = this.$route.params.id;
    LocationService.getLocationById(activeLocationId).then(response => {
      if(response.status == 200)
        this.$store.commit("SET_ACTIVE_LOCATION", response.data);
    })
    
  }
}
</script>

<style>

</style>