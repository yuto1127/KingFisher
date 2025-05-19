import React from 'react';
import { Link } from 'react-router-dom';

const AboutComponent = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">概要ページ</h1>
      <div className="space-y-4">
        <p className="text-lg">このサイトについての説明がここに入ります。</p>
        <Link 
          to="/" 
          className="inline-block bg-gray-500 text-white px-4 py-2 rounded hover:bg-gray-600"
        >
          ホームに戻る
        </Link>
      </div>
    </div>
  );
};

export default AboutComponent; 