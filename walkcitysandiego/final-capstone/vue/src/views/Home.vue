<template>
  <div class="home">
    <search-bar />
    <home-page />
  </div>
</template>

<script>
import HomePage from '@/components/HomePage.vue'
import SearchBar from '@/components/SearchBar.vue'

export default {
  name: "home",
  components: {
    HomePage,
    SearchBar
  }
}
</script>

<style scoped>
div .home {
  display: flex;
  flex-direction: column;
  justify-content: center;
  text-align: center;
  align-items: center;
}
</style>