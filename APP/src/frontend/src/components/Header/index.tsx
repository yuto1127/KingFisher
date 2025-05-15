import React from 'react';
import { Link } from 'react-router-dom';

const Header = () => {
  return (
    <header className="bg-white shadow-md">
      <nav className="container mx-auto px-4 py-4">
        <div className="flex justify-between items-center">
          <Link to="/" className="text-xl font-bold">
            サイト名
          </Link>
          <div className="space-x-4">
            <Link to="/" className="hover:text-gray-600">
              ホーム
            </Link>
            <Link to="/about" className="hover:text-gray-600">
              概要
            </Link>
            <Link to="/contact" className="hover:text-gray-600">
              お問い合わせ
            </Link>
          </div>
        </div>
      </nav>
    </header>
  );
};

export default Header; 