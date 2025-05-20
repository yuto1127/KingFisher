import React from 'react';
import { Link } from 'react-router-dom';
import { AppBar, Toolbar, Box } from '@mui/material';
import { styled } from '@mui/material/styles';
import HomeIcon from '@mui/icons-material/Home';
import MapIcon from '@mui/icons-material/Map';
import InfoIcon from '@mui/icons-material/Info';
import QrCodeScannerIcon from '@mui/icons-material/QrCodeScanner';

interface HeaderProps {
  role?: 'customer' | 'helpdesk' | 'admin';
}

const StyledLink = styled(Link)({
  color: 'inherit',
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  padding: '8px',
  borderRadius: '50%',
  '&:hover': {
    backgroundColor: 'rgba(0, 0, 0, 0.04)',
  },
});

const Header: React.FC<HeaderProps> = ({ role }) => {
  return (
    <AppBar position="static" color="default" elevation={1}>
      <Toolbar sx={{ justifyContent: 'center' }}>
        <Box sx={{ display: 'flex', gap: 2 }}>
          <StyledLink to="/">
            <HomeIcon sx={{ fontSize: 40 }} />
          </StyledLink>
          <StyledLink to="/floor-map">
            <MapIcon sx={{ fontSize: 40 }} />
          </StyledLink>
          <StyledLink to="/information">
            <InfoIcon sx={{ fontSize: 40 }} />
          </StyledLink>
          {(role === 'helpdesk' || role === 'admin') && (
            <StyledLink to={`/${role}/qr-reader`}>
              <QrCodeScannerIcon sx={{ fontSize: 40 }} />
            </StyledLink>
          )}
        </Box>
      </Toolbar>
    </AppBar>
  );
};

export default Header; 