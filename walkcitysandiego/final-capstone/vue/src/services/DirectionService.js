// THIS FILE IS NOT USED

import mapboxgl from 'mapbox-gl';
import axios from 'axios';

mapboxgl.accessToken = this.$store.state.mapboxToken;

const https = axios.create({
    baseURL: 'https://api.mapbox.com/directions/v5'
})

export default {

}