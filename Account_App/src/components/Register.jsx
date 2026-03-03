import { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { Wallet, UserPlus, AlertCircle } from 'lucide-react';

export default function Register({ onSwitchToLogin }) {
    const { register } = useAuth();
    const [name, setName] = useState('');
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [info, setInfo] = useState('');
    const [loading, setLoading] = useState(false);

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            setError('');
            setInfo('');
            setLoading(true);
            await register(email, password, name);
            // Supabase sends a confirmation email by default.
            // If email confirmation is disabled in the Supabase project the user is logged in immediately.
            setInfo('Account created! Check your email to confirm your address, then log in.');
        } catch (err) {
            setError(err.message);
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="auth-container">
            <div className="auth-card glass-panel">
                <div className="auth-header">
                    <div className="logo-wrapper">
                        <Wallet size={40} color="var(--accent-color)" />
                    </div>
                    <h1 className="text-gradient">Create Account</h1>
                    <p>Join us to manage your finances better</p>
                </div>

                {error && (
                    <div className="auth-error">
                        <AlertCircle size={18} />
                        <span>{error}</span>
                    </div>
                )}

                {info && (
                    <div className="auth-error" style={{ background: 'rgba(16,185,129,0.12)', borderColor: 'rgba(16,185,129,0.3)', color: '#34d399' }}>
                        <span>{info}</span>
                    </div>
                )}

                <form onSubmit={handleSubmit} className="auth-form">
                    <div className="form-group">
                        <label>Full Name</label>
                        <input
                            type="text"
                            value={name}
                            onChange={(e) => setName(e.target.value)}
                            required
                            className="form-input"
                            placeholder="John Doe"
                        />
                    </div>

                    <div className="form-group">
                        <label>Email Address</label>
                        <input
                            type="email"
                            value={email}
                            onChange={(e) => setEmail(e.target.value)}
                            required
                            className="form-input"
                            placeholder="you@example.com"
                        />
                    </div>

                    <div className="form-group">
                        <label>Password</label>
                        <input
                            type="password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                            required
                            className="form-input"
                            placeholder="••••••••"
                            minLength={6}
                        />
                    </div>

                    <button type="submit" className="submit-btn auth-submit" disabled={loading}>
                        <UserPlus size={20} />
                        <span>{loading ? 'Creating account…' : 'Create Account'}</span>
                    </button>
                </form>

                <div className="auth-footer">
                    <p>Already have an account? <span onClick={onSwitchToLogin} className="auth-link">Log in here</span></p>
                </div>
            </div>
        </div>
    );
}
