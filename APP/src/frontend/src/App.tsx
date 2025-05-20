import React, { useState } from 'react';
import './App.css';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import Header from './components/Header';
import LoginComponent from './components/Auth/LoginComponent';
import RegisterComponent from './components/Auth/RegisterComponent';

// 仮のページコンポーネント
const HomePage = () => <div>ホームページ（QR会員証表示）</div>;
const FloorMapPage = () => <div>フロアマップ</div>;
const InformationPage = () => <div>インフォメーション</div>;
const QRReaderPage = () => <div>QRリーダー</div>;

function App() {
  // 開発用：一時的に認証をスキップ
  const [currentRole, setCurrentRole] = useState<'customer' | 'helpdesk' | 'admin'>('customer');

  const handleLogin = (role: 'customer' | 'helpdesk' | 'admin') => {
    setCurrentRole(role);
  };

  const handleLogout = () => {
    setCurrentRole('customer');
  };

  // 開発用：認証チェックをスキップ
  const ProtectedRoute = ({ children }: { children: React.ReactNode }) => {
    return <>{children}</>;
  };

  return (
    <Router>
      <div className="App">
        <Header role={currentRole} />
        <main>
          <Routes>
            {/* 認証関連のルート */}
            <Route path="/login" element={<LoginComponent role="customer" onLogin={() => handleLogin('customer')} />} />
            <Route path="/register" element={<RegisterComponent role="customer" />} />
            
            <Route path="/helpdesk/login" element={<LoginComponent role="helpdesk" onLogin={() => handleLogin('helpdesk')} />} />
            <Route path="/helpdesk/register" element={<RegisterComponent role="helpdesk" />} />
            
            <Route path="/admin/login" element={<LoginComponent role="admin" onLogin={() => handleLogin('admin')} />} />
            <Route path="/admin/register" element={<RegisterComponent role="admin" />} />

            {/* 顧客用ルート */}
            <Route path="/" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
            <Route path="/floor-map" element={<ProtectedRoute><FloorMapPage /></ProtectedRoute>} />
            <Route path="/information" element={<ProtectedRoute><InformationPage /></ProtectedRoute>} />

            {/* ヘルプデスク用ルート */}
            <Route path="/helpdesk" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
            <Route path="/helpdesk/floor-map" element={<ProtectedRoute><FloorMapPage /></ProtectedRoute>} />
            <Route path="/helpdesk/information" element={<ProtectedRoute><InformationPage /></ProtectedRoute>} />
            <Route path="/helpdesk/qr-reader" element={<ProtectedRoute><QRReaderPage /></ProtectedRoute>} />

            {/* 管理者用ルート */}
            <Route path="/admin" element={<ProtectedRoute><HomePage /></ProtectedRoute>} />
            <Route path="/admin/floor-map" element={<ProtectedRoute><FloorMapPage /></ProtectedRoute>} />
            <Route path="/admin/information" element={<ProtectedRoute><InformationPage /></ProtectedRoute>} />
            <Route path="/admin/qr-reader" element={<ProtectedRoute><QRReaderPage /></ProtectedRoute>} />

            {/* デフォルトリダイレクト */}
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;
