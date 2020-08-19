<template>
  <div class="location-list">
    <router-link
      :to="{name: 'details', params: { id: location.locationId}}"
      v-for="location in locations"
      v-bind:key="location.locationId"
      v-on:click.prevent="updateActive()"
    >
      <location-card v-bind:location="location" />
    </router-link>
  </div>
</template>

<script>
import LocationCard from "@/components/LocationCard.vue";

export default {
  name: "locations-list",
  components: {
    LocationCard,
  },
  props: {
    locations: Array,
  },
  methods: {
    updateActive() {
      this.$store.commit('SET_ACTIVE_LOCATION', this.route.params.locationId);
    }
  }
  // computed: {
  //   filteredLocations() {
  //     const catFilter = this.$store.state.categoryFilter;
  //     const locationNameSearch = this.$store.state.searchTerms;

  //     return this.$store.state.locations.filter((location) => {
  //       return ((catFilter == '' ? true : (null != location.categories.find((category) => {
  //         return category.name == catFilter;
  //       }))) && (locationNameSearch == '' ? true : (location.name.toLowerCase().includes(locationNameSearch.toLowerCase()))));
  //     });
  //   }
  // }
};
</script>

<style>
.location-list {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-evenly;
}
.location-list a {
  text-decoration: none;
  color: rgb(7, 88, 100);
}
</style>