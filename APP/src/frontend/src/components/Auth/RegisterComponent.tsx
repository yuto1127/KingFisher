import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { TextField, Button, Box, Typography, Container, Paper } from '@mui/material';

interface RegisterComponentProps {
  role: 'customer' | 'helpdesk' | 'admin';
}

const RegisterComponent: React.FC<RegisterComponentProps> = ({ role }) => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    password: '',
    confirmPassword: '',
  });

  const getRoleTitle = () => {
    switch (role) {
      case 'customer':
        return '参加者会員登録';
      case 'helpdesk':
        return '学生会員登録';
      case 'admin':
        return '管理者会員登録';
      default:
        return '会員登録';
    }
  };

  const getLoginPath = () => {
    switch (role) {
      case 'customer':
        return '/login';
      case 'helpdesk':
        return '/helpdesk/login';
      case 'admin':
        return '/admin/login';
      default:
        return '/login';
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    // TODO: 会員登録処理の実装
    console.log('Register attempt:', { ...formData, role });
  };

  const handleBackToLogin = () => {
    navigate(getLoginPath());
  };

  return (
    <Container component="main" maxWidth="xs">
      <Paper elevation={3} sx={{ p: 4, mt: 8 }}>
        <Typography component="h1" variant="h5" align="center" gutterBottom>
          {getRoleTitle()}
        </Typography>
        <Box component="form" onSubmit={handleSubmit} sx={{ mt: 1 }}>
          <TextField
            margin="normal"
            required
            fullWidth
            id="name"
            label="お名前"
            name="name"
            autoComplete="name"
            autoFocus
            value={formData.name}
            onChange={handleChange}
          />
          <TextField
            margin="normal"
            required
            fullWidth
            id="email"
            label="メールアドレス"
            name="email"
            autoComplete="email"
            value={formData.email}
            onChange={handleChange}
          />
          <TextField
            margin="normal"
            required
            fullWidth
            name="password"
            label="パスワード"
            type="password"
            id="password"
            value={formData.password}
            onChange={handleChange}
          />
          <TextField
            margin="normal"
            required
            fullWidth
            name="confirmPassword"
            label="パスワード（確認）"
            type="password"
            id="confirmPassword"
            value={formData.confirmPassword}
            onChange={handleChange}
          />
          <Button
            type="submit"
            fullWidth
            variant="contained"
            sx={{ mt: 3, mb: 2 }}
          >
            登録
          </Button>
          <Button
            fullWidth
            variant="outlined"
            onClick={handleBackToLogin}
          >
            ログインページに戻る
          </Button>
        </Box>
      </Paper>
    </Container>
  );
};

export default RegisterComponent; 