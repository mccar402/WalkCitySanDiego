<template>
  <div >
    <div v-for="hours in hoursofoperation" v-bind:key="hours.locationHoursId">
        {{hours.dayOfWeekName}}: {{hours.openTime}} - {{hours.closeTime}}
    </div>
  </div>
</template>

<script>
export default {
    name: "location-hours",
    props: 
        ["hoursofoperation"]
    
}
</script>

<style>

</style>