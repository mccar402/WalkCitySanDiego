<template>
  <div class="profile">
      <user-details />
  </div>
</template>

<script>
import UserDetails from '@/components/UserDetails.vue'
export default {
    name: 'profile',
    components: {
        UserDetails
    }
}
</script>

<style>
    div.profile{
        display: flex;
        flex-direction: column;
        justify-content: center;
        text-align: center;
        align-items: center;
    }
</style>