import { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from './context/AuthContext';
import './App.css';

import Navbar from './components/Navbar';
import Login from './components/Login';
import Register from './components/Register';

import Dashboard from './pages/Dashboard';
import Analytics from './pages/Analytics';
import Recurring from './pages/Recurring';
import Profile from './pages/Profile';

function App() {
  const { user } = useAuth();
  const [showRegister, setShowRegister] = useState(false);

  const [theme, setTheme] = useState(() => {
    return localStorage.getItem('finance_app_theme') || 'dark';
  });

  useEffect(() => {
    localStorage.setItem('finance_app_theme', theme);
    if (theme === 'light') {
      document.body.classList.add('light-theme');
    } else {
      document.body.classList.remove('light-theme');
    }
  }, [theme]);

  const toggleTheme = () => {
    setTheme(prev => prev === 'dark' ? 'light' : 'dark');
  };

  if (!user) {
    return showRegister
      ? <Register onSwitchToLogin={() => setShowRegister(false)} />
      : <Login onSwitchToRegister={() => setShowRegister(true)} />;
  }

  return (
    <Router>
      <div className="app-container">
        <Navbar theme={theme} toggleTheme={toggleTheme} />
        <Routes>
          <Route path="/" element={<Dashboard />} />
          <Route path="/analytics" element={<Analytics />} />
          <Route path="/recurring" element={<Recurring />} />
          <Route path="/profile" element={<Profile />} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
