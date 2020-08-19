import Vue from 'vue'
import Vuex from 'vuex'
import axios from 'axios'

Vue.use(Vuex)

/*
 * The authorization header is set for axios when you login but what happens when you come back or
 * the page is refreshed. When that happens you need to check for the token in local storage and if it
 * exists you should set the header so that it will be attached to each request
 */
const currentToken = localStorage.getItem('token')
const currentUser = JSON.parse(localStorage.getItem('user'));

if (currentToken != null) {
  axios.defaults.headers.common['Authorization'] = `Bearer ${currentToken}`;
}

export default new Vuex.Store({
  state: {
    token: currentToken || '',
    user: currentUser || {},
    locations: [],
    categories: [],
    searchTerms: "",
    categoryFilter: "",  
    activeLocation:
    {
      locationId: '',
      name: '',
      description: '',
      bannerImgURL: '',
      smallImgURL: '',
      categories: '',
      locationHours: '',
      longitudeX: '',
      latitudeY: '',
    },
    mapboxToken: 'pk.eyJ1IjoibWFyZ2FyZXRncmVlbiIsImEiOiJja2Rvb3V5MHAwNXczMndqenNudGoyNTI3In0.zFDXY091qT3Xx0NslvQuTA'
  },
  mutations: {
    SET_AUTH_TOKEN(state, token) {
      state.token = token;
      localStorage.setItem('token', token);
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
    },
    SET_USER(state, user) {
      state.user = user;
      localStorage.setItem('user', JSON.stringify(user));
    },
    LOGOUT(state) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      state.token = '';
      state.user = {};
      axios.defaults.headers.common = {};
    },
    SET_ACTIVE_LOCATION(state, data) {
      state.activeLocation = data;
    },
    SET_LOCATIONS(state, data) {
      state.locations = data;
    },
    SET_CATEGORIES(state, data) {
      state.categories = data;
    },
    SET_SEARCH_TERMS(state, data) {
      state.searchTerms = data;
    },
    SET_CATEGORY_FILTER(state, data){
      state.categoryFilter = data;
    },
    SET_MAP_TOKEN(state, newToken) {
      state.mapboxToken = newToken;
    }
  },
  strict: true
})
