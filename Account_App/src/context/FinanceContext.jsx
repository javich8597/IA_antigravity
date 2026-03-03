import { createContext, useState, useEffect, useContext } from 'react';
import { supabase } from '../lib/supabaseClient';
import { useAuth } from './AuthContext';
import { translations } from '../utils/translations';

const FinanceContext = createContext();
export const useFinance = () => useContext(FinanceContext);

export const FinanceProvider = ({ children }) => {
    const { user } = useAuth();

    // ── State ──────────────────────────────────────────────────────────────
    const [transactions, setTransactions] = useState([]);
    const [recurringTransactions, setRecurringTransactions] = useState([]);
    const [goals, setGoals] = useState([]);
    const [currency, setCurrencyState] = useState('EUR');
    const [language, setLanguageState] = useState('en');
    const [loading, setLoading] = useState(false);

    // ── Fetch all data when user changes ────────────────────────────────────
    useEffect(() => {
        if (!user) {
            setTransactions([]);
            setRecurringTransactions([]);
            setGoals([]);
            return;
        }
        fetchAll();
    }, [user?.id]);

    const fetchAll = async () => {
        setLoading(true);
        const [txRes, recRes, goalRes, settingsRes] = await Promise.all([
            supabase.from('transactions').select('*').order('created_at', { ascending: false }),
            supabase.from('recurring_transactions').select('*').order('created_at', { ascending: false }),
            supabase.from('goals').select('*').order('created_at', { ascending: false }),
            supabase.from('user_settings').select('*').maybeSingle()
        ]);

        if (!txRes.error) setTransactions(txRes.data || []);
        if (!recRes.error) setRecurringTransactions(recRes.data || []);
        if (!goalRes.error) setGoals(goalRes.data || []);

        if (settingsRes.data) {
            // Row exists — restore preferences
            setCurrencyState(settingsRes.data.currency || 'EUR');
            setLanguageState(settingsRes.data.language || 'en');
        } else {
            // First login: create a default settings row so future fetches succeed
            await supabase.from('user_settings').upsert({
                user_id: user.id,
                currency: 'EUR',
                language: 'en',
                updated_at: new Date().toISOString()
            });
        }

        setLoading(false);
    };

    // ── Preference helpers ──────────────────────────────────────────────────
    const saveSettings = async (patch) => {
        if (!user) return;
        await supabase.from('user_settings').upsert({ user_id: user.id, ...patch, updated_at: new Date().toISOString() });
    };

    const setCurrency = (val) => {
        setCurrencyState(val);
        saveSettings({ currency: val });
    };

    const setLanguage = (val) => {
        setLanguageState(val);
        saveSettings({ language: val });
    };

    // ── i18n ────────────────────────────────────────────────────────────────
    const t = (key) => translations[language]?.[key] || translations['en']?.[key] || key;

    // ── Formatting ──────────────────────────────────────────────────────────
    const formatCurrency = (amount) => {
        const abs = Math.abs(amount);
        const sign = amount < 0 ? '-' : '';
        if (abs >= 1_000_000_000) {
            const n = (abs / 1_000_000_000).toFixed(2).replace(/\.?0+$/, '');
            return `${sign}${n}B ${currencySymbol}`;
        }
        if (abs >= 1_000_000) {
            const n = (abs / 1_000_000).toFixed(2).replace(/\.?0+$/, '');
            return `${sign}${n}M ${currencySymbol}`;
        }
        if (abs >= 100_000) {
            const n = (abs / 1_000).toFixed(1).replace(/\.0$/, '');
            return `${sign}${n}K ${currencySymbol}`;
        }
        const n = new Intl.NumberFormat('en-US', { style: 'decimal', minimumFractionDigits: 2, maximumFractionDigits: 2 }).format(abs);
        return `${sign}${n} ${currencySymbol}`;
    };

    const currencySymbols = { USD: '$', EUR: '€', GBP: '£', JPY: '¥' };
    const currencySymbol = currencySymbols[currency] || '$';

    const getFrequencyLabel = (freq) => {
        const map = { weekly: '/wk', monthly: '/mo', quarterly: '/qtr', biannually: '/6mo', annually: '/yr' };
        return map[freq] || `/${freq}`;
    };

    // ── Transactions CRUD ───────────────────────────────────────────────────
    const addTransaction = async (transaction) => {
        if (!user) return;
        const { data, error } = await supabase.from('transactions').insert({
            user_id: user.id,
            description: transaction.description,
            amount: parseFloat(transaction.amount),
            type: transaction.type,
            category: transaction.category || 'General',
            date: transaction.date || null
        }).select().single();
        if (!error && data) setTransactions(prev => [data, ...prev]);
    };

    const deleteTransaction = async (id) => {
        await supabase.from('transactions').delete().eq('id', id);
        setTransactions(prev => prev.filter(t => t.id !== id));
    };

    const updateTransaction = async (id, updatedFields) => {
        const { data, error } = await supabase.from('transactions')
            .update({ ...updatedFields, amount: parseFloat(updatedFields.amount) })
            .eq('id', id)
            .select().single();
        if (!error && data) setTransactions(prev => prev.map(t => t.id === id ? data : t));
    };

    // ── Recurring Transactions CRUD ─────────────────────────────────────────
    const addRecurringTransaction = async (item) => {
        if (!user) return;
        const { data, error } = await supabase.from('recurring_transactions').insert({
            user_id: user.id,
            description: item.description,
            amount: parseFloat(item.amount),
            type: item.type,
            category: item.category || 'General',
            frequency: item.frequency || 'monthly'
        }).select().single();
        if (!error && data) setRecurringTransactions(prev => [data, ...prev]);
    };

    const deleteRecurringTransaction = async (id) => {
        await supabase.from('recurring_transactions').delete().eq('id', id);
        setRecurringTransactions(prev => prev.filter(t => t.id !== id));
    };

    // ── Goals CRUD ──────────────────────────────────────────────────────────
    const addGoal = async (goal) => {
        if (!user) return;
        const { data, error } = await supabase.from('goals').insert({
            user_id: user.id,
            name: goal.name,
            target_amount: parseFloat(goal.targetAmount),
            current_amount: parseFloat(goal.currentAmount || goal.initialAmount || 0),
            initial_amount: parseFloat(goal.initialAmount || 0),
            deadline: goal.deadline || null
        }).select().single();
        if (!error && data) setGoals(prev => [data, ...prev]);
    };

    const updateGoal = async (id, newAmount) => {
        const { data, error } = await supabase.from('goals')
            .update({ current_amount: parseFloat(newAmount) })
            .eq('id', id)
            .select().single();
        if (!error && data) setGoals(prev => prev.map(g => g.id === id ? data : g));
    };

    const deleteGoal = async (id) => {
        await supabase.from('goals').delete().eq('id', id);
        setGoals(prev => prev.filter(g => g.id !== id));
    };

    // ── Derived / Filter helpers ────────────────────────────────────────────
    const getFilteredTransactions = (filter = 'all') => {
        if (filter === 'all') return transactions;
        const now = new Date();
        return transactions.filter(t => {
            if (!t.date) return false;
            const d = new Date(t.date);
            if (filter === 'daily') return d.toDateString() === now.toDateString();
            if (filter === 'monthly') return d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear();
            if (filter === 'yearly') return d.getFullYear() === now.getFullYear();
            return true;
        });
    };

    const getAllCombinedTransactions = (filter = 'all') => {
        const regular = getFilteredTransactions(filter);
        const recurring = recurringTransactions.map(r => ({ ...r, isRecurring: true }));
        return [...regular, ...recurring].sort((a, b) =>
            new Date(b.created_at) - new Date(a.created_at)
        );
    };

    const calculateTotals = () => {
        const monthlyRecurringIncome = recurringTransactions
            .filter(r => r.type === 'income')
            .reduce((sum, r) => sum + Number(r.amount), 0);
        const monthlyRecurringExpenses = recurringTransactions
            .filter(r => r.type === 'expense')
            .reduce((sum, r) => sum + Number(r.amount), 0);

        const totalIncome = transactions
            .filter(t => t.type === 'income')
            .reduce((sum, t) => sum + Number(t.amount), 0) + monthlyRecurringIncome;
        const totalExpenses = transactions
            .filter(t => t.type === 'expense')
            .reduce((sum, t) => sum + Number(t.amount), 0) + monthlyRecurringExpenses;

        return { totalIncome, totalExpenses, balance: totalIncome - totalExpenses };
    };

    const calculateForecast = () => {
        const { totalIncome, totalExpenses } = calculateTotals();
        const now = new Date();
        const daysInMonth = new Date(now.getFullYear(), now.getMonth() + 1, 0).getDate();
        const dayOfMonth = now.getDate();
        const daysRemaining = daysInMonth - dayOfMonth;
        const dailyRate = (totalIncome - totalExpenses) / dayOfMonth;
        return totalIncome - totalExpenses + (dailyRate * daysRemaining);
    };

    const getHistoricalSavings = (months = 3) => {
        const now = new Date();
        const savingsByMonth = [];
        for (let i = 0; i < months; i++) {
            const targetMonth = new Date(now.getFullYear(), now.getMonth() - i, 1);
            const monthTxns = transactions.filter(t => {
                if (!t.date) return false;
                const d = new Date(t.date);
                return d.getMonth() === targetMonth.getMonth() && d.getFullYear() === targetMonth.getFullYear();
            });
            const income = monthTxns.filter(t => t.type === 'income').reduce((s, t) => s + Number(t.amount), 0);
            const expenses = monthTxns.filter(t => t.type === 'expense').reduce((s, t) => s + Number(t.amount), 0);
            savingsByMonth.push(income - expenses);
        }
        const avgSavings = savingsByMonth.reduce((s, v) => s + v, 0) / months;
        return { savingsByMonth, avgSavings };
    };

    const getProjectedAnnualSavings = () => {
        const { avgSavings } = getHistoricalSavings(3);
        return avgSavings * 12;
    };

    // ── Normalise Supabase snake_case keys to camelCase for legacy consumers ─
    // Goals from Supabase use snake_case; the Profile page uses camelCase.
    const normalisedGoals = goals.map(g => ({
        ...g,
        targetAmount: g.target_amount ?? g.targetAmount,
        currentAmount: g.current_amount ?? g.currentAmount,
        initialAmount: g.initial_amount ?? g.initialAmount
    }));

    return (
        <FinanceContext.Provider value={{
            transactions,
            addTransaction,
            deleteTransaction,
            updateTransaction,
            recurringTransactions,
            addRecurringTransaction,
            deleteRecurringTransaction,
            goals: normalisedGoals,
            addGoal,
            updateGoal,
            deleteGoal,
            getFilteredTransactions,
            getAllCombinedTransactions,
            calculateTotals,
            calculateForecast,
            currency,
            setCurrency,
            formatCurrency,
            currencySymbol,
            getFrequencyLabel,
            language,
            setLanguage,
            t,
            getHistoricalSavings,
            getProjectedAnnualSavings,
            loading
        }}>
            {children}
        </FinanceContext.Provider>
    );
};
