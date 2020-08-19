<template>
  <div class="category-container">
      <div v-for="currentCategory in categories" v-bind:key="currentCategory.id" >
          <category-icon v-bind:category="currentCategory"/>
      </div>
  </div>
</template>

<script>
import CategoryIcon from "../components/CategoryIcon.vue";
export default {
    name: "category-icon-list",
    data(){
        return {

        }
    },
    props: ["categories"],
    methods: {
        isSelected(categoryName){
            return (this.$store.state.categoryFilter == categoryName);
        }
    },
    components:{
        CategoryIcon
    }
}
</script>

<style>
.category-container {
  display: flex;
  justify-content: center;
}
</style>