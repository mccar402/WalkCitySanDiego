<template>
  <div id="app">
    <!-- <div id="nav">
      <router-link v-bind:to="{ name: 'home' }">Home</router-link>&nbsp;|&nbsp;
      <router-link v-bind:to="{ name: 'profile' }" v-if="$store.state.token != ''">Profile</router-link>&nbsp;|&nbsp;
      <router-link v-bind:to="{ name: 'logout' }" v-if="$store.state.token != ''">Logout</router-link>
    </div> -->
    <nav-bar></nav-bar>
    <router-view />
  </div>
</template>

<script>
import locationService from '@/services/LocationService'
import NavBar from '@/components/NavBar.vue'

export default {
  components: {
    NavBar
  },  
  created() {
    // Run this when we load the page
    locationService
      .getLocations()
      .then((response) => {
        this.$store.commit("SET_LOCATIONS", response.data);
      })
      .catch((err) => {
        console.log(err + ": ACK! No locations available.");
      });
    locationService.getCategories().then((response) => {
      this.$store.commit('SET_CATEGORIES', response.data);
      this.$store.commit('SET_CATEGORY_FILTER', '');
    }).catch((err) => {
      console.log(err + ": Oops! No categories available.");
    });
    this.$store.commit('SET_CATEGORY_FILTER', '');
    this.$store.commit('SET_SEARCH_TERMS', '');
  }
}
</script>

<style>
#app {
  font-family: "Josefin Sans", sans-serif;
  color: rgb(7, 88, 100);
}
p {
  font-size: 1.3em;
}

/* width */
::-webkit-scrollbar {
  width: 10px;
}

/* Track */
::-webkit-scrollbar-track {
  background: #f1f1f1ab;
}

/* Handle */
::-webkit-scrollbar-thumb {
  
  background: rgb(114, 177, 155);
  border-radius: 4px;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
  background: rgb(78, 128, 110);
}
</style>

