import React from 'react';
import { Link, useNavigate } from 'react-router-dom';

const AboutPage = () => {
  const navigate = useNavigate();

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">概要ページ</h1>
      <div className="space-y-4">
        <p className="text-lg">このサイトについての説明がここに入ります。</p>
        <div className="flex space-x-4">
          <button
            onClick={() => navigate(-1)}
            className="bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600"
          >
            前のページに戻る
          </button>
          <Link 
            to="/" 
            className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
          >
            ホームに戻る
          </Link>
        </div>
      </div>
    </div>
  );
};

export default AboutPage; 