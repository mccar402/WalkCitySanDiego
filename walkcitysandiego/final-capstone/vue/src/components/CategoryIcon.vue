<template>
  <div>
        <img
          class="icon"
          v-bind:src="category.iconImgURL"
          
        />
  </div>
</template>

<script>
export default {
  name: "category-icon",
  data(){
    return {

    }
  },
  props: ["category"]
};
</script>

<style>
.icon {
  width: 50px;
  margin: 5px;
}

</style>