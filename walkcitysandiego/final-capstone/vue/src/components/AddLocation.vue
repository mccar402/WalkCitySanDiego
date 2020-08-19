<template>
  <div>
      <form action="">
          <div class="form-item">
            <label for="name">Name</label>
            <input type="text" id="name" v-model="this.newLocation.name"/>
          </div>
          <div class="form-item">
            <label for="description">Description</label>
            <input type="text" id="description" v-model="this.newLocation.description"/>
          </div>
          <div class="form-item">
            <label for="bannerImgURL">Banner Image URL</label>
            <input type="text" id="bannerImgURL" v-model="this.newLocation.bannerImgURL"/>
          </div>
          <div class="form-item">
            <label for="smallImgURL">Small Image URL</label>
            <input type="text" id="smallImgURL" v-model="this.newLocation.smallImgURL"/>
          </div>
          <div class="form-item">
            <label for="longitudeX">Longitude - X</label>
            <input type="text" id="longitudeX" v-model="this.newLocation.longitudeX"/>
          </div>
          <div class="form-item">
            <label for="latitudeY">Latitude - Y</label>
            <input type="text" id="latitudeY" v-model="this.newLocation.latitudeY"/>
          </div>
          <div class="form-item">
              
             
          </div>
          <input type="submit" value="Save Changes"/>
      </form>
  </div>
</template>

<script>
import LocationService from '../services/LocationService.js';
export default {
    name: "add-location",
    data(){
        return {
            newLocation: {
                name: '',
                description: '',
                bannerImgURL: '',
                smallImgURL: '',
                categories: [],
                locationHours: [],
                longitudeX: '',
                latitudeY: '',
            }
        }
    },
    methods : {
        saveNewLocation(){
            LocationService.addLocation(this.newLocation).then(response => {
                if(response.status == 201){
                    this.$router.push({ name: 'admin' });
                }
            })
        }
    }
}
</script>

<style>

</style>