import axios from 'axios';

const axiosClient = axios.create({
  baseURL: 'http://localhost:8000/api', // LaravelのAPIエンドポイント
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// リクエストインターセプター
axiosClient.interceptors.request.use(
  (config) => {
    // トークンがある場合はヘッダーに追加
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// レスポンスインターセプター
axiosClient.interceptors.response.use(
  (response) => {
    return response;
  },
  (error) => {
    if (error.response?.status === 401) {
      // 認証エラーの場合の処理
      localStorage.removeItem('token');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

export default axiosClient; 