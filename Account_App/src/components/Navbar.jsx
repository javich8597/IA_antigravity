import { useState } from 'react';
import { LogOut, User, LayoutDashboard, PieChart, Repeat, Target, Sun, Moon, Settings } from 'lucide-react';
import { NavLink } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useFinance } from '../context/FinanceContext';
import SettingsModal from './SettingsModal';

export default function Navbar({ theme, toggleTheme }) {
    const { user, logout } = useAuth();
    const { t } = useFinance();
    const [isSettingsOpen, setIsSettingsOpen] = useState(false);

    if (!user) return null;

    return (
        <nav className="navbar glass-panel">
            <div className="nav-user">
                <div className="avatar">
                    <User size={20} color="var(--accent-color)" />
                </div>
                <div className="user-details">
                    <span className="user-name">{user.name}</span>
                    <span className="user-email">{user.email}</span>
                </div>
            </div>

            <div className="nav-links" style={{ display: 'flex', gap: '1.5rem' }}>
                <NavLink to="/" className={({ isActive }) => `nav-link ${isActive ? 'active-nav' : ''}`}>
                    <LayoutDashboard size={18} /><span>{t('dashboard')}</span>
                </NavLink>
                <NavLink to="/analytics" className={({ isActive }) => `nav-link ${isActive ? 'active-nav' : ''}`}>
                    <PieChart size={18} /><span>{t('analytics')}</span>
                </NavLink>
                <NavLink to="/recurring" className={({ isActive }) => `nav-link ${isActive ? 'active-nav' : ''}`}>
                    <Repeat size={18} /><span>{t('recurring')}</span>
                </NavLink>
                <NavLink to="/profile" className={({ isActive }) => `nav-link ${isActive ? 'active-nav' : ''}`}>
                    <Target size={18} /><span>{t('profile')}</span>
                </NavLink>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                <button
                    onClick={() => setIsSettingsOpen(true)}
                    aria-label="Settings"
                    style={{
                        background: 'transparent', border: 'none', color: 'var(--text-muted)',
                        cursor: 'pointer', display: 'flex', alignItems: 'center',
                        padding: '0.5rem', borderRadius: '50%', transition: 'var(--transition)'
                    }}
                >
                    <Settings size={20} />
                </button>
                <button
                    onClick={toggleTheme}
                    aria-label="Toggle Theme"
                    style={{
                        background: 'transparent', border: 'none', color: 'var(--text-muted)',
                        cursor: 'pointer', display: 'flex', alignItems: 'center',
                        padding: '0.5rem', borderRadius: '50%', transition: 'var(--transition)'
                    }}
                >
                    {theme === 'dark' ? <Sun size={20} /> : <Moon size={20} />}
                </button>
                <button onClick={logout} className="logout-btn">
                    <LogOut size={18} />
                    <span className="hidden sm:inline">{t('logout')}</span>
                </button>
            </div>

            <SettingsModal isOpen={isSettingsOpen} onClose={() => setIsSettingsOpen(false)} />
        </nav>
    );
}
