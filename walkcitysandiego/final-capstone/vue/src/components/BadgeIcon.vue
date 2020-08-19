<template>
  <div class="badge-icon">
    <img
      v-bind:src="require(`@/assets/${this.badge.badgeImgURL}`)"
      v-bind:class="this.badge.dateEarned != null ? 'earned' : 'unearned'"
      v-bind:alt="this.badge.dateEarned != null ? badge.name + ' badge: earned' : badge.name + ' badge: unearned'"
    />
    <caption class="badge-text">{{badge.name}}</caption>
  </div>
</template>

<script>
export default {
  name: "badge-icon",
  props: ["badge"],
};
</script>

<style>
.badge-icon {
  width: 100px;
  height: auto;
  margin: 5px;
  display: flex;
  flex-direction: column;
  align-items: center;
}

img {
  width: 100%;
  height: auto;
}

.earned {
  opacity: 100%;
}

.unearned {
  opacity: 50%;
  filter: grayscale(100%);
}

.badge-text {
  font-size: 1rem;
  font-weight: bolder;
}
</style>