import React from 'react';
import './App.css';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './portal/home/page';
import Header from './components/Header';

function App() {
  return (
    <Router>
      <div className="App">
        <Header />
        <main>
          <Routes>
            <Route path="/" element={<HomePage />} />
            {/* 他のルートは必要に応じて追加 */}
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;
