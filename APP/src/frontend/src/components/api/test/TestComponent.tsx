import React, { useEffect, useState } from 'react';
import testService, { TestData } from './testService';

const TestComponent: React.FC = () => {
  const [testData, setTestData] = useState<TestData[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    fetchTestData();
  }, []);

  const fetchTestData = async () => {
    try {
      setLoading(true);
      const response = await testService.getTestData();
      setTestData(response.data);
      setError(null);
    } catch (err) {
      setError('データの取得に失敗しました');
      console.error('Error fetching test data:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleCreate = async () => {
    try {
      const newData = {
        title: '新しいテスト',
        description: 'これはテストデータです'
      };
      await testService.createTestData(newData);
      fetchTestData(); // データを再取得
    } catch (err) {
      console.error('Error creating test data:', err);
    }
  };

  if (loading) return <div>読み込み中...</div>;
  if (error) return <div className="text-red-500">{error}</div>;

  return (
    <div className="p-4">
      <h2 className="text-2xl font-bold mb-4">テストデータ一覧</h2>
      <button
        onClick={handleCreate}
        className="bg-blue-500 text-white px-4 py-2 rounded mb-4"
      >
        新規作成
      </button>
      <div className="space-y-4">
        {testData.map((item) => (
          <div key={item.id} className="border p-4 rounded">
            <h3 className="text-xl font-semibold">{item.title}</h3>
            <p className="text-gray-600">{item.description}</p>
            <p className="text-sm text-gray-400">
              作成日: {new Date(item.created_at).toLocaleDateString()}
            </p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default TestComponent; 