import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { TextField, Button, Box, Typography, Container, Paper } from '@mui/material';

interface LoginComponentProps {
  role: 'customer' | 'helpdesk' | 'admin';
  onLogin?: () => void;
}

const LoginComponent: React.FC<LoginComponentProps> = ({ role, onLogin }) => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const getRoleTitle = () => {
    switch (role) {
      case 'customer':
        return '参加者ログイン';
      case 'helpdesk':
        return '学生ログイン';
      case 'admin':
        return '管理者ログイン';
      default:
        return 'ログイン';
    }
  };

  const getRegisterPath = () => {
    switch (role) {
      case 'customer':
        return '/register';
      case 'helpdesk':
        return '/helpdesk/register';
      case 'admin':
        return '/admin/register';
      default:
        return '/register';
    }
  };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    // TODO: ログイン処理の実装
    console.log('Login attempt:', { email, password, role });
    if (onLogin) {
      onLogin();
    }
  };

  const handleRegister = () => {
    navigate(getRegisterPath());
  };

  return (
    <Container component="main" maxWidth="xs">
      <Paper elevation={3} sx={{ p: 4, mt: 8 }}>
        <Typography component="h1" variant="h5" align="center" gutterBottom>
          {getRoleTitle()}
        </Typography>
        <Box component="form" onSubmit={handleLogin} sx={{ mt: 1 }}>
          <TextField
            margin="normal"
            required
            fullWidth
            id="email"
            label="メールアドレス"
            name="email"
            autoComplete="email"
            autoFocus
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <TextField
            margin="normal"
            required
            fullWidth
            name="password"
            label="パスワード"
            type="password"
            id="password"
            autoComplete="current-password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <Button
            type="submit"
            fullWidth
            variant="contained"
            sx={{ mt: 3, mb: 2 }}
          >
            ログイン
          </Button>
          <Button
            fullWidth
            variant="outlined"
            onClick={handleRegister}
          >
            新規会員登録
          </Button>
        </Box>
      </Paper>
    </Container>
  );
};

export default LoginComponent; 