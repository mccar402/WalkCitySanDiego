<template>
  <div class="search-bar">
    <div>
      <form id="search-input" v-on:submit.prevent="updateSearchTerms">
        <label id="search-label" for="search-input">Search by Location Name:</label>
        <input id="search-input" name="search-input" type="text" v-model="keyWords" />
        <input type="submit" value="Search" />
      </form>
    </div>
    <div class="category-filter">
      <p>Filter by Category:</p>
      <selectable-category-icon-list v-bind:categories="$store.state.categories" />
    </div>
  </div>
</template>

<script>
import SelectableCategoryIconList from "@/components/SelectableCategoryIconList.vue";

export default {
  name: "search-bar",
  data() {
    return {
      keyWords: "",
    };
  },
  components: {
    SelectableCategoryIconList,
  },
  methods: {
    updateSearchTerms() {
      this.$store.commit("SET_SEARCH_TERMS", this.keyWords);
      this.$store.commit("SET_CATEGORY_FILTER", "");
      this.$router.push({ name: "results" });
      if (this.$router.currentRoute.name == "results") {
        // not refreshing map on results page yet
        this.$refs.LocationMap.forceRender();
        this.$refs.LocationMap.initializeMap();
      } else {
        this.$router.push({ name: "results" });
      }
    },
  },
};
</script>

<style>
.search-bar {
  text-align: center;
  border: 3px solid rgb(134, 206, 181);
  border-radius: 10px;
  width: 80vw;
  padding: 10px;
  background-color: rgb(205, 245, 231);
}

.search-bar > * {
  margin: 10px;
}

.category-filter {
  display: flex;
  justify-content: center;
}

p {
  display: inline;
}

selectable-category-icon-list {
  display: inline;
}

#search-input {
  margin: 0 5px;
}

#search-label {
  font-size: 1.3em;
}
</style>