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
    const [wealthData, setWealthData] = useState(null);
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
        const [txRes, recRes, goalRes, settingsRes, wealthRes] = await Promise.all([
            supabase.from('transactions').select('*').order('created_at', { ascending: false }),
            supabase.from('recurring_transactions').select('*').order('created_at', { ascending: false }),
            supabase.from('goals').select('*').order('created_at', { ascending: false }),
            supabase.from('user_settings').select('*').maybeSingle(),
            supabase.from('user_wealth').select('*').maybeSingle()
        ]);

        let loadedTxs = txRes.data || [];
        let loadedRecs = recRes.data || [];

        // --- RECURRING ENGINE EXECUTION ---
        try {
            const now = new Date();
            now.setHours(0, 0, 0, 0);
            const toInsert = [];
            const updates = [];

            for (const r of loadedRecs) {
                if (!r.next_date) continue; // Skip old legacy data without dates
                let currDate = new Date(r.next_date);
                let processed = false;

                while (currDate <= now) {
                    toInsert.push({
                        user_id: r.user_id,
                        description: r.description + ' (Auto)',
                        amount: r.amount,
                        type: r.type,
                        category: r.category,
                        date: currDate.toISOString().split('T')[0]
                    });

                    if (r.frequency === 'weekly') currDate.setDate(currDate.getDate() + 7);
                    else if (r.frequency === 'monthly') currDate.setMonth(currDate.getMonth() + 1);
                    else if (r.frequency === 'quarterly') currDate.setMonth(currDate.getMonth() + 3);
                    else if (r.frequency === 'biannually') currDate.setMonth(currDate.getMonth() + 6);
                    else if (r.frequency === 'annually') currDate.setFullYear(currDate.getFullYear() + 1);
                    else currDate.setMonth(currDate.getMonth() + 1); // fallback

                    processed = true;
                }

                if (processed) {
                    updates.push({ id: r.id, next_date: currDate.toISOString().split('T')[0] });
                    // Provide optimistic update to our loaded recurring list so it stops triggering
                    r.next_date = currDate.toISOString().split('T')[0];
                }
            }

            if (toInsert.length > 0) {
                const { data: triggerData } = await supabase.from('transactions').insert(toInsert).select();
                if (triggerData) {
                    loadedTxs = [...triggerData, ...loadedTxs].sort((a, b) => new Date(b.created_at) - new Date(a.created_at));
                }
            }
            if (updates.length > 0) {
                // Loop to update them
                for (const up of updates) {
                    await supabase.from('recurring_transactions').update({ next_date: up.next_date }).eq('id', up.id);
                }
            }
        } catch (err) {
            console.error('Error auto-processing recurring tx:', err);
        }
        // ----------------------------------
        // --- CATEGORY MIGRATION (V23) ---
        // Seamlessly maps old legacy category names to the new 14-root structure
        const migrateCategory = (cat) => {
            if (!cat) return 'Internal - Ajustes manuales';
            const root = cat.split(' - ')[0];
            const sub = cat.split(' - ')[1] || '';

            if (root === 'Salary') return 'Income - ' + (sub || 'Nómina');
            if (root === 'Savings') return 'Investments - ' + (sub || 'Traspaso a Ahorros');
            if (root === 'General' || root === 'Other') return 'Internal - Ajustes manuales';

            if (root === 'Food') {
                if (sub.includes('Restaurante')) return 'Dining - Restaurantes';
                if (sub.includes('domicilio')) return 'Dining - Comida a Domicilio';
                if (sub.includes('Cafetería') || sub.includes('Snack')) return 'Dining - Cafetería';
            }
            return cat;
        };

        loadedTxs = loadedTxs.map(tx => ({ ...tx, category: migrateCategory(tx.category) }));
        loadedRecs = loadedRecs.map(r => ({ ...r, category: migrateCategory(r.category) }));
        // --------------------------------

        setTransactions(loadedTxs);
        setRecurringTransactions(loadedRecs);
        if (!goalRes.error) setGoals(goalRes.data || []);

        if (settingsRes.data) {
            setCurrencyState(settingsRes.data.currency || 'EUR');
            setLanguageState(settingsRes.data.language || 'en');
        } else {
            await supabase.from('user_settings').upsert({
                user_id: user.id,
                currency: 'EUR',
                language: 'en',
                updated_at: new Date().toISOString()
            });
        }

        if (wealthRes.data) {
            setWealthData(wealthRes.data);
        } else {
            const { data: cw } = await supabase.from('user_wealth').insert({ user_id: user.id }).select().single();
            setWealthData(cw || null);
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

    // ── V22: User Memory Engine ─────────────────────────────────────────────
    const saveToUserMemory = (description, category) => {
        if (!description || !category) return;
        const nDesc = description.trim().toLowerCase();
        if (nDesc.length < 2) return;

        try {
            const memStr = localStorage.getItem('user_categorizer_memory');
            const mem = memStr ? JSON.parse(memStr) : {};
            mem[nDesc] = category;
            localStorage.setItem('user_categorizer_memory', JSON.stringify(mem));
        } catch (e) {
            console.error("Memory learning failed", e);
        }
    };

    // ── Transactions CRUD ───────────────────────────────────────────────────
    const addTransaction = async (transaction) => {
        if (!user) return;

        if (transaction.description && transaction.category) {
            saveToUserMemory(transaction.description, transaction.category);
        }

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
        if (updatedFields.description && updatedFields.category) {
            saveToUserMemory(updatedFields.description, updatedFields.category);
        }

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
            frequency: item.frequency || 'monthly',
            start_date: item.startDate,
            next_date: item.startDate // Initially the next execution is the start date
        }).select().single();
        if (!error && data) {
            // Because we might have added a next_date <= today, we should probably just trigger fetchAll to process it.
            // But to avoid an extra network request, we can just fetchAll anyway or let the user refresh.
            // For now, update local state, and if it was supposed to trigger today, they can refresh.
            setRecurringTransactions(prev => [data, ...prev]);
            // If the start date is <= today, re-fetch to trigger the processing engine
            const now = new Date();
            now.setHours(0, 0, 0, 0);
            if (new Date(item.startDate) <= now) {
                fetchAll();
            }
        }
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
        let filtered = [...transactions];
        const now = new Date();

        if (filter !== 'all') {
            filtered = transactions.filter(t => {
                if (!t.date) return false;
                const d = new Date(t.date);
                if (filter === 'daily') return d.toDateString() === now.toDateString();
                if (filter === 'monthly') return d.getMonth() === now.getMonth() && d.getFullYear() === now.getFullYear();
                if (filter === 'yearly') return d.getFullYear() === now.getFullYear();
                return true;
            });
        }

        // Sort strictly by insertion order (when they were added) descending
        return filtered.sort((a, b) => {
            const dateA = new Date(a.created_at);
            const dateB = new Date(b.created_at);
            return dateB - dateA;
        });
    };

    const getAllCombinedTransactions = (filter = 'all') => {
        const regular = getFilteredTransactions(filter);
        return regular.sort((a, b) => {
            // Sort by explicit calendar date descending
            const dateA = new Date(a.date || a.created_at);
            const dateB = new Date(b.date || b.created_at);
            return dateB - dateA;
        });
    };

    const calculateTotals = () => {
        const totalIncome = transactions
            .filter(t => t.type === 'income')
            .reduce((sum, t) => sum + Number(t.amount), 0);
        const totalExpenses = transactions
            .filter(t => t.type === 'expense')
            .reduce((sum, t) => sum + Number(t.amount), 0);

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
        if (!user) return { savingsByMonth: [], avgSavings: 0 };

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

            // Monthly capacity from purely existing historical transaction logs
            savingsByMonth.push(income - expenses);
        }

        const totalSavings = savingsByMonth.reduce((s, v) => s + v, 0);
        const avgSavings = totalSavings / months;
        return { savingsByMonth, avgSavings };
    };

    const getProjectedAnnualSavings = () => {
        const { avgSavings } = getHistoricalSavings(3);
        return avgSavings * 12;
    };

    // ── Wealth & Intelligence Engine ────────────────────────────────────────
    const updateWealth = async (patch) => {
        if (!user || !wealthData?.id) return;
        const { data, error } = await supabase.from('user_wealth')
            .update({ ...patch, updated_at: new Date().toISOString() })
            .eq('id', wealthData.id)
            .select().single();
        if (!error && data) setWealthData(data);
    };

    const getDynamicLiquidCash = () => {
        if (!wealthData) return 0;
        const baseCash = Number(wealthData.liquid_cash || 0);
        const recalibrateDate = wealthData.last_recalibrated_date ? new Date(wealthData.last_recalibrated_date) : new Date(0);

        // Calculate flow since last recalibration
        const recentTxns = transactions.filter(t => {
            const txDate = new Date(t.date || t.created_at);
            return txDate >= recalibrateDate;
        });

        const incomes = recentTxns.filter(t => t.type === 'income').reduce((s, t) => s + Number(t.amount), 0);
        const expenses = recentTxns.filter(t => t.type === 'expense').reduce((s, t) => s + Number(t.amount), 0);

        return baseCash + incomes - expenses;
    };

    const getBlindSpots = () => {
        const now = new Date();
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(now.getDate() - 30);

        // Get expenses in the last 30 days
        const recentExpenses = transactions.filter(t => t.type === 'expense' && new Date(t.date || t.created_at) >= thirtyDaysAgo);

        const frequencyMap = {};
        recentExpenses.forEach(t => {
            // we split the category to check main category or sub
            const key = t.category || 'General';
            if (!frequencyMap[key]) frequencyMap[key] = { count: 0, total: 0 };
            frequencyMap[key].count += 1;
            frequencyMap[key].total += Number(t.amount);
        });

        // Filter categories with high freq (>3 times a month) but small individual amounts (<30 average)
        const spots = Object.entries(frequencyMap)
            .filter(([k, v]) => v.count >= 3 && (v.total / v.count) < 30)
            .map(([k, v]) => ({ category: k, count: v.count, total: v.total, avg: v.total / v.count }))
            .sort((a, b) => b.total - a.total);

        // Also compile active subscriptions
        const subs = recurringTransactions.filter(r => r.type === 'expense');

        return { smallFrequent: spots, subscriptions: subs };
    };

    const simulateGoalAffordability = (goalAmount) => {
        const cash = getDynamicLiquidCash();
        const newCash = cash - goalAmount;

        // Calculate average monthly survival needs (Housing, Food, Utilities)
        // Since we have nested categories like "Housing - Alquiler", we match the root
        const needsCategories = ['Housing', 'Food', 'Utilities', 'Transportation', 'Healthcare'];

        let totalNeedsExpense = 0;
        // Looking at the last 3 months
        const now = new Date();
        const ninetyDaysAgo = new Date();
        ninetyDaysAgo.setDate(now.getDate() - 90);

        const recentNeeds = transactions.filter(t => {
            if (t.type !== 'expense') return false;
            const txDate = new Date(t.date || t.created_at);
            if (txDate < ninetyDaysAgo) return false;

            const rootCat = t.category ? t.category.split(' - ')[0] : '';
            return needsCategories.includes(rootCat);
        });

        totalNeedsExpense = recentNeeds.reduce((s, t) => s + Number(t.amount), 0);
        // Average monthly needs
        const avgMonthlyNeeds = totalNeedsExpense / 3;

        const currentRunway = avgMonthlyNeeds > 0 ? (cash / avgMonthlyNeeds) : 0;
        const newRunway = avgMonthlyNeeds > 0 ? (newCash / avgMonthlyNeeds) : 0;

        return {
            affordable: cash >= goalAmount,
            remainingCash: newCash,
            currentRunway,
            newRunway,
            pressure: cash > 0 ? (goalAmount / cash) * 100 : 100 // % of liquid cash wiped out
        };
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
            wealthData,
            updateWealth,
            getDynamicLiquidCash,
            getBlindSpots,
            simulateGoalAffordability,
            loading
        }}>
            {children}
        </FinanceContext.Provider>
    );
};
