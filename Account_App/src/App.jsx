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
  const { user, authLoading } = useAuth();
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

  // Wait for Supabase to restore the session before deciding what to render
  if (authLoading) {
    return (
      <div style={{ display: 'flex', height: '100vh', alignItems: 'center', justifyContent: 'center', background: 'var(--bg-main)' }}>
        <div style={{ textAlign: 'center', color: 'var(--text-muted)' }}>
          <div style={{
            width: 44, height: 44,
            border: '3px solid rgba(99,102,241,0.25)',
            borderTop: '3px solid #6366f1',
            borderRadius: '50%',
            animation: 'spin 0.8s linear infinite',
            margin: '0 auto 1rem auto'
          }} />
          <p style={{ fontSize: '0.9rem', letterSpacing: '0.05em' }}>Loading…</p>
        </div>
      </div>
    );
  }

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
