<template>
  <div class="category-container">
      <div v-for="currentCategory in $store.state.categories" v-bind:key="currentCategory.categoryId" v-bind:class="{selected : isSelected(currentCategory.name)}"  v-on:click="updateCategoryFilter(currentCategory.name)">
          <category-icon v-bind:isSelected="isSelected(currentCategory.name)" v-bind:category="currentCategory"/>
      </div>
  </div>
</template>

<script>
import CategoryIcon from "../components/CategoryIcon.vue";
export default {
    name: "selectable-category-icon-list",
    data(){
        return {

        }
    },
    // props: ["categories"],
    methods: {
        updateCategoryFilter(categoryName) {
            if(this.$store.state.categoryFilter == categoryName){
                this.$store.commit("SET_CATEGORY_FILTER", "");
                this.$router.push({ name: 'home' });
            }else{
                this.$store.commit("SET_CATEGORY_FILTER", categoryName);
                this.$router.push({ name: 'home' });
            }
        },
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

.selected{
  border-style: solid;
  border-radius: 10px;
}
</style>