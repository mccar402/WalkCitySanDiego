<template>
  <div class="user-details">
    <h1>{{ this.user.firstName }}&nbsp;{{this.user.lastName}}'s Profile</h1>
    <badge-shelf v-bind:earnedbadges="this.user.badgesEarned" />
    <checkin-container v-bind:user="this.user" />
  </div>
</template>

<script>
import BadgeShelf from "@/components/BadgeShelf.vue";
import CheckinContainer from "@/components/CheckinContainer.vue";
import userService from "@/services/UserService";

export default {
  name: "user-details",
  components: {
    BadgeShelf,
    CheckinContainer,
  },
  data() {
    return {
      user: {},
    };
  },
  created() {
    this.getUserData();
  },
  methods: {
    getUserData() {
      const currentUser = this.$store.state.user;
      userService.getUserById(currentUser.id).then((response) => {
        this.user = response.data;
      });
    },
  }
};
</script>

<style>
.user-details{
  display: flex;
  flex-direction: column;
  align-items: center;
}
.user-details h1 {
  font-size: 40px;
}
</style>