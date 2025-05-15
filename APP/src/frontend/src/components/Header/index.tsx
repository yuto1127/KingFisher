import React from 'react';
import Link from 'next/link';

const Header = () => {
  return (
    <header className="bg-white shadow-md">
      <nav className="container mx-auto px-4 py-4">
        <div className="flex justify-between items-center">
          <Link href="/" className="text-xl font-bold">
            サイト名
          </Link>
          <div className="space-x-4">
            <Link href="/" className="hover:text-gray-600">
              ホーム
            </Link>
            <Link href="/about" className="hover:text-gray-600">
              概要
            </Link>
            <Link href="/contact" className="hover:text-gray-600">
              お問い合わせ
            </Link>
          </div>
        </div>
      </nav>
    </header>
  );
};

export default Header; 