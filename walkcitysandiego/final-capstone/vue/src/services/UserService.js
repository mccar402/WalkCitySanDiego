import axios from 'axios';

const http = axios.create({
    baseURL: 'http://localhost:8080/api'
});

export default {
    getUserById(userId) {
        return http.get(`/users/${userId}`)
    },
    createCheckin(userId, locationId) {
        return http.post(`/users/${userId}/location/${locationId}`)
    },
    getBadgesByUserId(userId) {
        return http.get(`/users/${userId}/badge`)
    }
}