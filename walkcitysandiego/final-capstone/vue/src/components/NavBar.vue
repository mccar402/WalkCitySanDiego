<template>
  <div class="nav-bar" v-show="$store.state.token != ''">
    <img />
    <h1 id="page-title">WalkCity San Diego</h1>
    <nav class="nav-buttons">
      <ul>
        <li>
          <router-link v-bind:to="{ name: 'home' }">
            <h1>Home</h1>
          </router-link>
        </li>
        <li>
          <router-link v-bind:to="{ name: 'profile' }" v-if="$store.state.token != ''">
            <h1>Profile</h1>
          </router-link>
        </li>
        <li>
          <router-link v-bind:to="{ name: 'logout' }" v-if="$store.state.token != ''">
            <h1>Logout</h1>
          </router-link>
        </li>
      </ul>
    </nav>
  </div>
</template>

<script>
export default {
  name: "nav-bar",
};
</script>

<style>
#page-title {
  font-size: 50px;
}

.nav-bar {
  display: flex;
  align-content: center;
  flex-wrap: wrap;
  margin-left: 10px;
  margin-right: 10px;
}
.nav-buttons {
    flex-grow: 1;
}
.nav-buttons > ul {
    display: flex;
    justify-content: flex-end;
    margin: 0;
    padding-top: 10px;
    list-style-type: none;
    align-content: center;
}
nav ul li {
    text-decoration: none;
    list-style: none;
    width: 150px;
    background-color: rgb(134, 206, 181);
    border-radius: 5px;
    text-align: center;
    line-height: 12px;
    margin: 10px 5px 0px 10px;
}

li a {
    text-decoration: none;
    color: rgb(7, 88, 100);
}

</style>