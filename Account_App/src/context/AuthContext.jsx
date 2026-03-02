import { createContext, useState, useEffect, useContext } from 'react';
import { v4 as uuidv4 } from 'uuid';

const AuthContext = createContext();

export const useAuth = () => useContext(AuthContext);

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(() => {
        const activeSession = localStorage.getItem('finance_app_session');
        return activeSession ? JSON.parse(activeSession) : null;
    });

    const [users, setUsers] = useState(() => {
        const saved = localStorage.getItem('finance_app_users');
        return saved ? JSON.parse(saved) : [];
    });

    useEffect(() => {
        localStorage.setItem('finance_app_users', JSON.stringify(users));
    }, [users]);

    useEffect(() => {
        if (user) {
            localStorage.setItem('finance_app_session', JSON.stringify(user));
        } else {
            localStorage.removeItem('finance_app_session');
        }
    }, [user]);

    const register = (email, password, name) => {
        // Check if user already exists
        if (users.find(u => u.email === email)) {
            throw new Error('User already exists');
        }

        const newUser = { id: uuidv4(), email, password, name };
        setUsers(prev => [...prev, newUser]);
        setUser({ id: newUser.id, email: newUser.email, name: newUser.name });
        return true;
    };

    const login = (email, password) => {
        const existingUser = users.find(u => u.email === email && u.password === password);
        if (!existingUser) {
            throw new Error('Invalid email or password');
        }
        setUser({ id: existingUser.id, email: existingUser.email, name: existingUser.name });
        return true;
    };

    const logout = () => {
        setUser(null);
    };

    return (
        <AuthContext.Provider value={{
            user,
            register,
            login,
            logout
        }}>
            {children}
        </AuthContext.Provider>
    );
};
