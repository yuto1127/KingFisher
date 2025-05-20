import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { AppBar, Toolbar, Typography, Button, Box } from '@mui/material';

interface HeaderProps {
  role?: 'customer' | 'helpdesk' | 'admin';
}

const Header: React.FC<HeaderProps> = ({ role }) => {
  const location = useLocation();

  const getNavigationItems = () => {
    const commonItems = [
      { path: '/', label: 'ホーム' },
      { path: '/floor-map', label: 'フロアマップ' },
      { path: '/information', label: 'インフォメーション' },
    ];

    if (role === 'helpdesk' || role === 'admin') {
      return [
        ...commonItems,
        { path: '/qr-reader', label: 'QRリーダー' },
      ];
    }

    return commonItems;
  };

  const isActive = (path: string) => {
    return location.pathname === path;
  };

  return (
    <AppBar position="static">
      <Toolbar>
        <Typography variant="h6" component="div" sx={{ flexGrow: 0, mr: 4 }}>
          KingFisher
        </Typography>
        <Box sx={{ flexGrow: 1, display: 'flex', gap: 2 }}>
          {getNavigationItems().map((item) => (
            <Button
              key={item.path}
              component={Link}
              to={item.path}
              color="inherit"
              sx={{
                backgroundColor: isActive(item.path) ? 'rgba(255, 255, 255, 0.1)' : 'transparent',
                '&:hover': {
                  backgroundColor: 'rgba(255, 255, 255, 0.2)',
                },
              }}
            >
              {item.label}
            </Button>
          ))}
        </Box>
        <Box>
          <Button color="inherit" component={Link} to={`/${role}/login`}>
            ログアウト
          </Button>
        </Box>
      </Toolbar>
    </AppBar>
  );
};

export default Header; 