<template>
  <div class="login-container">
    <login-component></login-component>
    <div id="login" class="text-center">
      <form class="form-signin" @submit.prevent="login">
        <h1 class="h3 mb-3 font-weight-normal">Please Sign In</h1>
        <div
          class="alert alert-danger"
          role="alert"
          v-if="invalidCredentials"
        >Invalid username and password!</div>
        <div
          class="alert alert-success"
          role="alert"
          v-if="this.$route.query.registration"
        >Thank you for registering, please sign in.</div>
        <label for="username" class="sr-only">Username</label>
        <input
          type="text"
          id="username"
          class="form-control"
          placeholder="Username"
          v-model="user.username"
          required
          autofocus
        />
        <label for="password" class="sr-only">Password</label>
        <input
          type="password"
          id="password"
          class="form-control"
          placeholder="Password"
          v-model="user.password"
          required
        />
        <router-link :to="{ name: 'register' }">Need an account?</router-link>
        <button type="submit">Sign in</button>
      </form>
    </div>
  </div>
</template>

<script>
import authService from "../services/AuthService";
import LoginComponent from "../components/LoginComponent";

export default {
  name: "login",
  components: {
    LoginComponent,
  },
  data() {
    return {
      user: {
        username: "",
        password: "",
      },
      invalidCredentials: false,
    };
  },
  methods: {
    login() {
      authService
        .login(this.user)
        .then((response) => {
          if (response.status == 200) {
            this.$store.commit("SET_AUTH_TOKEN", response.data.token);
            this.$store.commit("SET_USER", response.data.user);
            if(this.$store.state.user.authorities[0].name == 'ROLE_USER'){
              this.$router.push({name: 'home'});
            } else {
              this.$router.push({name: 'admin'});
            }
          }
        })
        .catch((error) => {
          const response = error.response;

          if (response.status === 401) {
            this.invalidCredentials = true;
          }
        });
    },
  },
};
</script>

<style scoped>
.login-container {
  background-image: url('https://www.telegraph.co.uk/content/dam/Travel/Cruise/Ocean/CROP-San-Diego-skyline-iStock-xlarge.jpg');
  background-size: cover;
  background-repeat: no-repeat;
  height: 100vh;
  color: whitesmoke;
}

form > * {
  padding: 10px;
  /* margin: 10px; */
}

.form-signin a {
  color: white;
}

/* form.form-signin {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 10px;
    grid-template-areas: 
    "username-label username-input"
    "password-label password-input"
    "register sign-in";
} */
</style>