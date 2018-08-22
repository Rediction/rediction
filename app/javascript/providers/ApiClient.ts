import axios from "axios";

const apiClient = axios.create({
  timeout: 15000,
  baseURL: "/api"
});

export default apiClient;
