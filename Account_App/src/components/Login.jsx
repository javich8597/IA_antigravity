import { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { Wallet, LogIn, AlertCircle } from 'lucide-react';

export default function Login({ onSwitchToRegister }) {
    const { login } = useAuth();
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');

    const handleSubmit = (e) => {
        e.preventDefault();
        try {
            setError('');
            login(email, password);
        } catch (err) {
            setError(err.message);
        }
    };

    return (
        <div className="auth-container">
            <div className="auth-card glass-panel">
                <div className="auth-header">
                    <div className="logo-wrapper">
                        <Wallet size={40} color="var(--accent-color)" />
                    </div>
                    <h1 className="text-gradient">Welcome Back</h1>
                    <p>Login to track your finances securely</p>
                </div>

                {error && (
                    <div className="auth-error">
                        <AlertCircle size={18} />
                        <span>{error}</span>
                    </div>
                )}

                <form onSubmit={handleSubmit} className="auth-form">
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
                        />
                    </div>

                    <button type="submit" className="submit-btn auth-submit">
                        <LogIn size={20} />
                        <span>Sign In</span>
                    </button>
                </form>

                <div className="auth-footer">
                    <p>Don't have an account? <span onClick={onSwitchToRegister} className="auth-link">Register here</span></p>
                </div>
            </div>
        </div>
    );
}
