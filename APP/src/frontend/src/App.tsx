import React from 'react';
import './App.css';
import HomePage from './portal/home/page';
import Header from './components/Header';

function App() {
  return (
    <div className="App">
      <Header />
      <main>
        <HomePage />
      </main>
    </div>
  );
}

export default App;
