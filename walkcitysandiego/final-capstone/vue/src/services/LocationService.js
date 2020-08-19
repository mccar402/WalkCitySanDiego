import axios from 'axios';

const http = axios.create({
    baseURL: "http://localhost:8080/api"
});

export default {
    getLocations() {
        return http.get('/locations');
    },
    getLocationById(locationId) {
        return http.get(`/locations/${locationId}`);
    },
    getCategories() {
        return http.get('/categories');
    },
    addLocation() {
        return http.post('/locations');
    }
}