<template>
  <div class="checkin-card">
      {{ checkin.checkInDate }}
      <location-card v-bind:location="checkin.location"/>
  </div>
</template>

<script>
import LocationCard from '@/components/LocationCard.vue'

export default {
    name: 'checkin-card',
    props: ["checkin"],
    components: {
        LocationCard
    }
}
</script>

<style>

.checkin-card {
    font-size: 1.25rem;
}

</style>