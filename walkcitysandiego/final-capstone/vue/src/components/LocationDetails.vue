<template>
  <div class="location-details-container">
    <div class="location-header">
      <h1 class="location-name">{{location.name}}</h1>
      <img class="banner-image" v-bind:src="location.bannerImgURL" />
      <category-icon-list v-bind:categories="location.categories" />
    </div>
    <div class="location-in-detail">
      <p>{{location.description}}</p>
      <h2>Hours of Operations</h2>
      <location-hours v-bind:hoursofoperation="location.locationHours" />
      <button id="checkin-button" v-on:click.prevent="addCheckin">Check In</button>
    </div>
    <!-- <div class="directions-checkin">
      <direction-map v-bind:location="location" />
    </div> -->
    <div class="directions-single-destination">
      <single-destination v-bind:location="location"/>
    </div>
  </div>
</template>

<script>
import LocationHours from "../components/LocationHours.vue";
// import DirectionMap from "@/components/DirectionMap.vue";
import CategoryIconList from "../components/CategoryIconList.vue";
import userService from "@/services/UserService";
import SingleDestination from "@/components/SingleDestination.vue";

export default {
  name: "location-details",
  props: ["location"],
  components: {
    LocationHours,
    CategoryIconList,
    // DirectionMap,
    SingleDestination
  },
  methods: {
    addCheckin() {
      if (this.$store.state.token != '') {
        const user = this.$store.state.user.id;
        const place = this.location.locationId;
        userService.createCheckin(user, place).then((response) => {
          console.log(response.status + ": Going to your profile");
          this.$router.push({ name: 'profile' });
        }).catch((err) => {
          if (err.response) {
              alert("You've already checked in today! Enjoy!");
            } else if (err.request) {
                alert("Oops! Something went wrong with the request.");
            } else {
              alert("Oops! Our bad! Site could not create the request.");
            }
          });
        } else {
        alert("Oops! You're not logged in!");
      }
    }
  }
};
</script>

<style>
.location-details-container {
  display: grid;
  gap: 10px;
  grid-template-columns: 1fr 3fr;
  grid-template-areas:
    "banner banner"
    "details map";
  justify-content: space-around;
}
.location-header {
  text-align: center;
  grid-area: banner;
}
.banner-image {
  width: auto;
  height: 500px;
  margin-bottom: 10px;
}
.location-in-detail {
  grid-area: details;
  text-align: center;
  margin-bottom: 20px;
}
.directions-single-destination {
  grid-area: map;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}
#checkin-button {
  margin: 10px;
  width: 150px;
  height: 50px;
  background-color: rgb(134, 206, 181);
  border-radius: 5px;
  text-align: center;
  line-height: 12px;
  color: rgb(7, 88, 100);
  padding: 5px;
  font-size: 2rem;
}
</style>