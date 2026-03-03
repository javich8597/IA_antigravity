import { createContext, useState, useEffect, useContext } from 'react';
import { supabase } from '../lib/supabaseClient';

const AuthContext = createContext();

export const useAuth = () => useContext(AuthContext);

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);
    const [authLoading, setAuthLoading] = useState(true);

    useEffect(() => {
        // Restore session on mount
        supabase.auth.getSession().then(({ data: { session } }) => {
            setUser(session?.user ?? null);
            setAuthLoading(false);
        });

        // Listen for login / logout events
        const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
            setUser(session?.user ?? null);
        });

        return () => subscription.unsubscribe();
    }, []);

    const register = async (email, password, name) => {
        const { error } = await supabase.auth.signUp({
            email,
            password,
            options: { data: { name } }
        });
        if (error) throw new Error(error.message);
    };

    const login = async (email, password) => {
        const { error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw new Error(error.message);
    };

    const logout = async () => {
        await supabase.auth.signOut();
    };

    // Expose a compatible user shape: { id, email, name }
    const userProfile = user
        ? { id: user.id, email: user.email, name: user.user_metadata?.name || user.email }
        : null;

    return (
        <AuthContext.Provider value={{ user: userProfile, authLoading, register, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
};
