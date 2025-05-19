import React from 'react';
import { Link } from 'react-router-dom';

const HomeComponent = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">ホームページ</h1>
      <div className="space-y-4">
        <p className="text-lg">ようこそ！</p>
        <div className="flex space-x-4">
          <Link 
            to="/about" 
            className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
          >
            概要ページへ
          </Link>
          <Link 
            to="/contact" 
            className="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600"
          >
            お問い合わせへ
          </Link>
        </div>
      </div>
    </div>
  );
};

export default HomeComponent; 