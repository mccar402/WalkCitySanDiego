<template>
  <div>
      <router-link :to="{name: 'add'}">Add New Location</router-link>
      <admin-locations-list v-bind:locations="this.$store.state.locations"/>
  </div>
</template>

<script>
import AdminLocationsList from '../components/AdminLocationsList.vue';
export default {
    name: 'administration',
    components: {
        AdminLocationsList
    }
}
</script>

<style>

</style>