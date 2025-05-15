import axiosClient from '../axiosClient';

// テストデータの型定義
export interface TestData {
  id: number;
  title: string;
  description: string;
  created_at: string;
}

// テストデータのレスポンス型
export interface TestResponse {
  data: TestData[];
  message: string;
}

// テスト用のAPIサービス
const testService = {
  // テストデータの取得
  getTestData: async (): Promise<TestResponse> => {
    try {
      const response = await axiosClient.get('/test');
      return response.data;
    } catch (error) {
      throw error;
    }
  },

  // テストデータの作成
  createTestData: async (data: Omit<TestData, 'id' | 'created_at'>): Promise<TestData> => {
    try {
      const response = await axiosClient.post('/test', data);
      return response.data;
    } catch (error) {
      throw error;
    }
  },

  // テストデータの更新
  updateTestData: async (id: number, data: Partial<TestData>): Promise<TestData> => {
    try {
      const response = await axiosClient.put(`/test/${id}`, data);
      return response.data;
    } catch (error) {
      throw error;
    }
  },

  // テストデータの削除
  deleteTestData: async (id: number): Promise<void> => {
    try {
      await axiosClient.delete(`/test/${id}`);
    } catch (error) {
      throw error;
    }
  }
};

export default testService; 