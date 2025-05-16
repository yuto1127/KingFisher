import React from 'react';
import './App.css';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import HomePage from './portal/home/page';
import AboutPage from './portal/about/page';
import ContactPage from './portal/contact/page';
import Header from './components/Header';
import TestComponent from './components/api/test/TestComponent';

function App() {
  return (
    <Router>
      <div className="App">
        <Header />
        <main>
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/about" element={<AboutPage />} />
            <Route path="/contact" element={<ContactPage />} />
            <Route path="/test" element={<TestComponent />} />
            {/* 他のルートは必要に応じて追加 */}
          </Routes>
        </main>
      </div>
    </Router>
  );
}

export default App;
