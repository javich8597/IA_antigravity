import { useState, useRef, useEffect } from 'react';
import { LogOut, User, LayoutDashboard, PieChart, Repeat, Target, Sun, Moon, Settings, TrendingUp } from 'lucide-react';
import { NavLink } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import { useFinance } from '../context/FinanceContext';
import SettingsModal from './SettingsModal';

export default function Navbar({ theme, toggleTheme }) {
    const { user, logout } = useAuth();
    const { t } = useFinance();
    const [isSettingsOpen, setIsSettingsOpen] = useState(false);
    const [isProfileMenuOpen, setIsProfileMenuOpen] = useState(false);
    const dropdownRef = useRef(null);

    useEffect(() => {
        function handleClickOutside(event) {
            if (dropdownRef.current && !dropdownRef.current.contains(event.target)) {
                setIsProfileMenuOpen(false);
            }
        }
        document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, []);

    if (!user) return null;

    return (
        <nav className="navbar glass-panel">
            {/* Left Profile Action (balances flex layout via flex: 1) */}
            <div style={{ flex: 1, display: 'flex', alignItems: 'center', position: 'relative' }} ref={dropdownRef}>
                <button
                    className="avatar"
                    onClick={() => setIsProfileMenuOpen(!isProfileMenuOpen)}
                    title={user.email}
                    style={{ cursor: 'pointer', outline: 'none' }}
                >
                    <User size={20} color="var(--accent-color)" />
                </button>

                {isProfileMenuOpen && (
                    <div className="profile-dropdown">
                        <div className="profile-header">
                            <span className="profile-name">{user.name || 'User'}</span>
                            <span className="profile-email">{user.email}</span>
                        </div>
                        <div className="dropdown-divider"></div>
                        <button
                            className="dropdown-item"
                            onClick={(e) => {
                                e.stopPropagation();
                                setIsSettingsOpen(true);
                                setIsProfileMenuOpen(false);
                            }}
                        >
                            <Settings size={16} />
                            <span>{t('settings') || 'Settings'}</span>
                        </button>
                    </div>
                )}
            </div>

            <div className="nav-links" style={{ display: 'flex', gap: '1.5rem' }}>
                <NavLink to="/" className={({ isActive }) => `nav-link ${isActive ? 'active-nav' : ''}`}>
                    <LayoutDashboard size={18} /><span>{t('dashboard')}</span>
                </NavLink>
                <NavLink to="/analytics" className={({ isActive }) => `nav-link ${isActive ? 'active-nav' : ''}`}>
                    <PieChart size={18} /><span>{t('analytics')}</span>
                </NavLink>
                <NavLink to="/wealth" className={({ isActive }) => `nav-link ${isActive ? 'active-nav' : ''}`}>
                    <TrendingUp size={18} /><span>{t('Wealth')}</span>
                </NavLink>
                <NavLink to="/profile" className={({ isActive }) => `nav-link ${isActive ? 'active-nav' : ''}`}>
                    <Target size={18} /><span>{t('profile')}</span>
                </NavLink>
            </div>

            <div style={{ display: 'flex', alignItems: 'center', gap: '1rem', flex: 1, justifyContent: 'flex-end' }}>
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
