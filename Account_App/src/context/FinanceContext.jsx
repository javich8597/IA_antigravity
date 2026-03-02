import { createContext, useState, useEffect, useContext } from 'react';
import { v4 as uuidv4 } from 'uuid';
import { useAuth } from './AuthContext';
import { translations } from '../utils/translations';

const FinanceContext = createContext();

export const useFinance = () => useContext(FinanceContext);

export const FinanceProvider = ({ children }) => {
    const { user } = useAuth();

    // Standard Transactions
    const [allTransactions, setAllTransactions] = useState(() => {
        const saved = localStorage.getItem('finance_app_transactions');
        if (saved) {
            try {
                return JSON.parse(saved);
            } catch (e) {
                return [];
            }
        }
        return [];
    });

    // Recurring Transactions (V3)
    const [allRecurring, setAllRecurring] = useState(() => {
        const saved = localStorage.getItem('finance_app_recurring');
        if (saved) {
            try { return JSON.parse(saved); } catch (e) { return []; }
        }
        return [];
    });

    // Goals (V6)
    const [allGoals, setAllGoals] = useState(() => {
        const saved = localStorage.getItem('finance_app_goals');
        if (saved) {
            try { return JSON.parse(saved); } catch (e) { return []; }
        }
        return [];
    });

    // Preferences (V7)
    const [currency, setCurrency] = useState(() => {
        return localStorage.getItem('finance_app_currency') || 'USD';
    });

    // Language (V10)
    const [language, setLanguage] = useState(() => {
        return localStorage.getItem('finance_app_language') || 'en';
    });

    // Filter lists for the current user
    const transactions = allTransactions.filter(t => t.userId === user?.id);
    const recurringTransactions = allRecurring.filter(t => t.userId === user?.id);
    const goals = allGoals.filter(t => t.userId === user?.id);

    useEffect(() => {
        localStorage.setItem('finance_app_transactions', JSON.stringify(allTransactions));
    }, [allTransactions]);

    useEffect(() => {
        localStorage.setItem('finance_app_recurring', JSON.stringify(allRecurring));
    }, [allRecurring]);

    useEffect(() => {
        localStorage.setItem('finance_app_goals', JSON.stringify(allGoals));
    }, [allGoals]);

    useEffect(() => {
        localStorage.setItem('finance_app_currency', currency);
    }, [currency]);

    useEffect(() => {
        localStorage.setItem('finance_app_language', language);
    }, [language]);

    // i18n Translation Helper
    const t = (key) => {
        return translations[language]?.[key] || translations['en']?.[key] || key;
    };

    // Format Helpers
    const formatCurrency = (amount) => {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: currency,
        }).format(amount);
    };

    const currencySymbols = { USD: '$', EUR: '€', GBP: '£', JPY: '¥' };
    const currencySymbol = currencySymbols[currency] || '$';

    // Actions: Standard
    const addTransaction = (transaction) => {
        if (!user) return;
        setAllTransactions(prev => [{
            ...transaction,
            id: uuidv4(),
            userId: user.id,
            amount: parseFloat(transaction.amount),
            category: transaction.category || 'General'
        }, ...prev]);
    };

    const deleteTransaction = (id) => {
        setAllTransactions(prev => prev.filter(t => t.id !== id));
    };

    // Actions: Recurring
    const addRecurringTransaction = (item) => {
        if (!user) return;
        setAllRecurring(prev => [{
            ...item,
            id: uuidv4(),
            userId: user.id,
            amount: parseFloat(item.amount),
            category: item.category || 'General'
        }, ...prev]);
    };

    const deleteRecurringTransaction = (id) => {
        setAllRecurring(prev => prev.filter(t => t.id !== id));
    };

    // Actions: Goals
    const addGoal = (goal) => {
        if (!user) return;
        setAllGoals(prev => [{
            ...goal,
            id: uuidv4(),
            userId: user.id,
            targetAmount: parseFloat(goal.targetAmount),
            initialAmount: parseFloat(goal.initialAmount || 0),
            currentAmount: parseFloat(goal.currentAmount || goal.initialAmount || 0),
            deadline: goal.deadline || ''
        }, ...prev]);
    };

    const updateGoal = (id, newAmount) => {
        setAllGoals(prev => prev.map(g =>
            g.id === id ? { ...g, currentAmount: parseFloat(newAmount) } : g
        ));
    };

    const deleteGoal = (id) => {
        setAllGoals(prev => prev.filter(g => g.id !== id));
    };

    const getFilteredTransactions = (filterType) => {
        if (filterType === 'all') return transactions;

        const now = new Date();
        return transactions.filter(t => {
            if (!t.date) return true;
            const date = new Date(t.date);
            if (filterType === 'daily') {
                return date.getDate() === now.getDate() &&
                    date.getMonth() === now.getMonth() &&
                    date.getFullYear() === now.getFullYear();
            }
            if (filterType === 'monthly') {
                return date.getMonth() === now.getMonth() &&
                    date.getFullYear() === now.getFullYear();
            }
            if (filterType === 'yearly') {
                return date.getFullYear() === now.getFullYear();
            }
            return true;
        });
    };

    const getMonthlyNormalizedAmount = (amount, frequency) => {
        const numAmount = parseFloat(amount) || 0;
        switch (frequency) {
            case 'weekly': return numAmount * 4.33;
            case 'quarterly': return numAmount / 3;
            case 'biannually': return numAmount / 6;
            case 'annually': return numAmount / 12;
            case 'monthly':
            default:
                return numAmount; // default is monthly
        }
    };

    const getFrequencyLabel = (frequency) => {
        switch (frequency) {
            case 'weekly': return '/wk';
            case 'quarterly': return '/qtr';
            case 'biannually': return '/6mo';
            case 'annually': return '/yr';
            case 'monthly':
            default: return '/mo';
        }
    };

    const calculateTotals = (filteredTransactions = transactions) => {
        // Calculate standard totals
        const income = filteredTransactions
            .filter(t => t.type === 'income')
            .reduce((acc, curr) => acc + curr.amount, 0);

        const expense = filteredTransactions
            .filter(t => t.type === 'expense')
            .reduce((acc, curr) => acc + curr.amount, 0);

        // Include active recurring transactions into the main totals
        const recurringIncome = recurringTransactions
            .filter(t => t.type === 'income')
            .reduce((acc, curr) => acc + getMonthlyNormalizedAmount(curr.amount, curr.frequency), 0);

        const recurringExpense = recurringTransactions
            .filter(t => t.type === 'expense')
            .reduce((acc, curr) => acc + getMonthlyNormalizedAmount(curr.amount, curr.frequency), 0);

        const totalIncome = income + recurringIncome;
        const totalExpense = expense + recurringExpense;

        return {
            income: totalIncome,
            expense: totalExpense,
            balance: totalIncome - totalExpense
        };
    };

    const calculateForecast = () => {
        const currentTotals = calculateTotals();
        const currentBalance = currentTotals.balance;

        const recurringIncome = recurringTransactions
            .filter(t => t.type === 'income')
            .reduce((acc, curr) => acc + getMonthlyNormalizedAmount(curr.amount, curr.frequency), 0);

        const recurringExpense = recurringTransactions
            .filter(t => t.type === 'expense')
            .reduce((acc, curr) => acc + getMonthlyNormalizedAmount(curr.amount, curr.frequency), 0);

        return currentBalance + recurringIncome - recurringExpense;
    };

    // V6: Combine standard and recurring for Dashboard
    const getAllCombinedTransactions = (filterType = 'all') => {
        const standard = getFilteredTransactions(filterType);
        const recurring = recurringTransactions.map(rt => ({
            ...rt,
            isRecurring: true // flag to distinguish
        }));

        // Combine them
        const combined = [...standard, ...recurring];

        // Sort by date descending (newest first). 
        // For recurring without a specific date, we can sort them at the top or bottom, 
        // let's assume they apply to the current period and sort them conceptually recent.
        combined.sort((a, b) => {
            if (!a.date && !b.date) return 0;
            if (!a.date) return -1; // Keep recurring at top
            if (!b.date) return 1;
            return new Date(b.date) - new Date(a.date);
        });

        return combined;
    };

    const getHistoricalSavings = (months = 3) => {
        const now = new Date();
        const pastDate = new Date();
        pastDate.setMonth(now.getMonth() - months);

        const pastTransactions = transactions.filter(t => {
            if (!t.date) return false;
            const tDate = new Date(t.date);
            return tDate >= pastDate && tDate <= now;
        });

        const historicalIncome = pastTransactions
            .filter(t => t.type === 'income')
            .reduce((acc, curr) => acc + curr.amount, 0);

        const historicalExpense = pastTransactions
            .filter(t => t.type === 'expense')
            .reduce((acc, curr) => acc + curr.amount, 0);

        const avgMonthlyIncome = months > 0 ? (historicalIncome / months) : 0;
        const avgMonthlyExpense = months > 0 ? (historicalExpense / months) : 0;

        const recurringInc = recurringTransactions
            .filter(t => t.type === 'income')
            .reduce((acc, curr) => acc + getMonthlyNormalizedAmount(curr.amount, curr.frequency), 0);

        const recurringExp = recurringTransactions
            .filter(t => t.type === 'expense')
            .reduce((acc, curr) => acc + getMonthlyNormalizedAmount(curr.amount, curr.frequency), 0);

        const totalAvgMonthlyIncome = avgMonthlyIncome + recurringInc;
        const totalAvgMonthlyExpense = avgMonthlyExpense + recurringExp;

        return {
            avgIncome: totalAvgMonthlyIncome,
            avgExpense: totalAvgMonthlyExpense,
            avgSavings: totalAvgMonthlyIncome - totalAvgMonthlyExpense
        };
    };

    const getProjectedAnnualSavings = () => {
        const { avgSavings } = getHistoricalSavings(3);
        return avgSavings * 12;
    };

    return (
        <FinanceContext.Provider value={{
            transactions,
            addTransaction,
            deleteTransaction,
            recurringTransactions,
            addRecurringTransaction,
            deleteRecurringTransaction,
            goals,
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
            getProjectedAnnualSavings
        }}>
            {children}
        </FinanceContext.Provider>
    );
};
