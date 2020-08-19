<template>
  <div class="badge-shelf">
      <h2>Your Badges</h2>
      <div class="badge-container">
        <badge-icon v-for="badge in this.earnedbadges" v-bind:key="badge.badgeId" v-bind:badge="badge"/>
      </div>

  </div>
</template>

<script>
import BadgeIcon from '@/components/BadgeIcon.vue'

export default {
    name: "badge-shelf",
    props: ["earnedbadges"],
    components: {
        BadgeIcon
    }
}
</script>

<style>
.badge-shelf{
    display: flex;
    flex-direction: column;
    align-content: center;
    width: 75%;
}
    .badge-container{
        display: flex;
        justify-content: center;
    }
</style>