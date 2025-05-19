import React from 'react';
import { Link } from 'react-router-dom';
import { Button } from '@mui/material';
import { styled } from '@mui/material/styles';

const TitleStyle = styled(Link)({
  color: '#000000',
  fontSize: '40px',
  fontWeight: 'bold',
  textDecoration: 'none',
});

const Header = () => {
  return (
    <header className="bg-white shadow-md">
      <nav className="container mx-auto px-4 py-4">
        <div className="flex justify-between items-center">
          <TitleStyle to="/">
            KingFisher
          </TitleStyle>

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