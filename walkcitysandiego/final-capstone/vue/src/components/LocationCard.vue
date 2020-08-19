<template>
  <div class="location-card">
    <div class="name-container">
      <h2 class="name">{{ location.name }}</h2>
    </div>
    <div class="image-container">
      <img class="small-image" v-bind:src="location.smallImgURL" />
    </div>
    <!-- Add in for loop for category cards -->
    <category-icon-list v-bind:categories="location.categories"></category-icon-list>
    <!--<location-hours v-bind:hoursofoperation="location.locationHours"/>-->
  </div>
</template>

<script>
import CategoryIconList from "../components/CategoryIconList";
//import LocationHours from "../components/LocationHours";

export default {
  name: "location-card",
  components: {
    CategoryIconList, //,
    //LocationHours
  },
  props: {
    location: Object,
  }
};
</script>

<style>
.location-card {
  border: 3px solid rgb(134, 206, 181);
  border-radius: 10px;
  width: 250px;
  height: 300px;
  margin: 20px;
  text-align: center;
  transition: transform .2s;
}

.location-card:hover {
  background-color: rgb(205, 245, 231);
  transform: scale(1.1);
}

.location-card .name {
  font-size: 1.5rem;
}
.location-card .small-image {
  max-width: 150px;
}
div .image-container {
    height: 150px;
    display: flex;
    justify-content: center;
    align-items: center;
}
div .name-container {
  height: 60px;
}
</style>