import Vue from 'vue'
import Router from 'vue-router'
import Home from '../views/Home.vue'
import Login from '../views/Login.vue'
import Logout from '../views/Logout.vue'
import Register from '../views/Register.vue'
import store from '../store/index'
import Profile from '@/views/Profile.vue'
import Results from '@/views/Results.vue'
import Details from '../views/Details.vue'
import Administration from '../views/Administration.vue'
import Edit from '../views/Edit.vue'
import Add from '../views/Add.vue'

Vue.use(Router)

/**
 * The Vue Router is used to "direct" the browser to render a specific view component
 * inside of App.vue depending on the URL.
 *
 * It also is used to detect whether or not a route requires the user to have first authenticated.
 * If the user has not yet authenticated (and needs to) they are redirected to /login
 * If they have (or don't need to) they're allowed to go about their way.
 */

const router = new Router({
  mode: 'history',
  base: process.env.BASE_URL,
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home,
      meta: {
        requiresAuth: true,
        roles: ['ROLE_USER']
      }
    },
    {
      path: "/login",
      name: "login",
      component: Login,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/logout",
      name: "logout",
      component: Logout,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/register",
      name: "register",
      component: Register,
      meta: {
        requiresAuth: false
      }
    },
    {
      path: "/profile",
      name: "profile",
      component: Profile,
      meta: {
        requiresAuth: true,
        roles: ['ROLE_USER', 'ROLE_ADMIN']
      }
    },
    {
      path: "/results",
      name: "results",
      component: Results,
      meta: {
        requiresAuth: true,
        roles: ['ROLE_USER']
      }
    },
    {
      path: "/details/:id",
      name: "details",
      component: Details,
      meta: {
        requiresAuth: true,
        roles: ['ROLE_USER']
      }
    },
    {
      path: "/admin",
      name: "admin",
      component: Administration,
      meta: {
        requiresAuth: true,
        roles: ['ROLE_ADMIN']
      }
    },
    {
      path: "/location/:id/edit",
      name: "edit",
      component: Edit,
      meta: {
        requiresAuth: true,
        roles: ['ROLE_ADMIN']
      }
    },
    {
      path: "/location/add",
      name: "add",
      component: Add,
      meta: {
        requiresAuth: true,
        roles: ['ROLE_ADMIN']
      }
    }
  ]
})

router.beforeEach((to, from, next) => {
  // Determine if the route requires Authentication
  const requiresAuth = to.matched.some(x => x.meta.requiresAuth);

  // If it does and they are not logged in, send the user to "/login"
  if(requiresAuth){
    if (store.state.token === '') {
      
      next("/login");
    } else{
        if(!to.meta.roles){
          return next();
        
        } else if(to.meta.roles.includes(store.state.user.authorities[0].name)){
          next();
        }
      }
  } else{
    if(!to.meta.roles){
      return next();
    }
  }
});

export default router;
