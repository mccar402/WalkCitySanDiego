<template>
  <div class="checkin-container">
    <h2>Check In History</h2>
    <div class="checkins">
      <checkin-card
        v-for="checkin in this.user.listOfCheckins"
        v-bind:key="checkin.id"
        v-bind:checkin="checkin"
      />
    </div>
  </div>
</template>

<script>
import CheckinCard from "@/components/CheckinCard.vue";

export default {
  name: "checkin-container",
  components: {
    CheckinCard,
  },
  props: ["user"],
};
</script>

<style>
div .checkins {
  display: flex;
  justify-content: center;
}
h2 {
  font-size: 30px;
}
</style>