import { useState } from 'react';
import { useAuth } from '../context/AuthContext';
import { Wallet, UserPlus, AlertCircle } from 'lucide-react';

export default function Register({ onSwitchToLogin }) {
    const { register } = useAuth();
    const [name, setName] = useState('');
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');

    const handleSubmit = (e) => {
        e.preventDefault();
        try {
            setError('');
            register(email, password, name);
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
                    <h1 className="text-gradient">Create Account</h1>
                    <p>Join us to manage your finances better</p>
                </div>

                {error && (
                    <div className="auth-error">
                        <AlertCircle size={18} />
                        <span>{error}</span>
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

                    <button type="submit" className="submit-btn auth-submit">
                        <UserPlus size={20} />
                        <span>Create Account</span>
                    </button>
                </form>

                <div className="auth-footer">
                    <p>Already have an account? <span onClick={onSwitchToLogin} className="auth-link">Log in here</span></p>
                </div>
            </div>
        </div>
    );
}
