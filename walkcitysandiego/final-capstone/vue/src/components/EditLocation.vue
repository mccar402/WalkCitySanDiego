<template>
  <div>
      <form action="">
          <div class="form-item">
            <label for="name">Name</label>
            <input type="text" id="name" v-model="this.editedLocation.name"/>
          </div>
          <div class="form-item">
            <label for="description">Description</label>
            <input type="text" id="description" v-model="this.editedLocation.description"/>
          </div>
          <div class="form-item">
            <label for="bannerImgURL">Banner Image URL</label>
            <input type="text" id="bannerImgURL" v-model="this.editedLocation.bannerImgURL"/>
          </div>
          <div class="form-item">
            <label for="smallImgURL">Small Image URL</label>
            <input type="text" id="smallImgURL" v-model="this.editedLocation.smallImgURL"/>
          </div>
          <div class="form-item">
            <label for="longitudeX">Longitude - X</label>
            <input type="text" id="longitudeX" v-model="this.editedLocation.longitudeX"/>
          </div>
          <div class="form-item">
            <label for="latitudeY">Latitude - Y</label>
            <input type="text" id="latitudeY" v-model="this.editedLocation.latitudeY"/>
          </div>
          <input type="submit" value="Save Changes"/>
      </form>
  </div>
</template>

<script>
export default {
    name: "edit-location",
    props: ["location"],
    data(){
        return {
            editedLocation: {}
        }
    },
    created(){
        this.editedLocation = this.location;
    }
}
</script>

<style>

</style>