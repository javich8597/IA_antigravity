import { useState } from 'react';
import { PlusCircle, Trash2, Repeat } from 'lucide-react';
import { useFinance } from '../context/FinanceContext';
import { CATEGORIES } from '../utils/categoryIcons';

export default function Recurring() {
    const {
        recurringTransactions,
        addRecurringTransaction,
        deleteRecurringTransaction,
        calculateTotals,
        formatCurrency,
        currencySymbol,
        getFrequencyLabel,
        t
    } = useFinance();
    const [formData, setFormData] = useState({
        description: '',
        amount: '',
        frequency: 'monthly',
        type: 'expense',
        category: CATEGORIES[0]
    });

    const handleSubmit = (e) => {
        e.preventDefault();
        if (!formData.description || !formData.amount) return;

        addRecurringTransaction({
            ...formData,
            amount: parseFloat(formData.amount)
        });
        setFormData({
            description: '',
            amount: '',
            frequency: 'monthly',
            type: 'expense',
            category: CATEGORIES[0]
        });
    };

    return (
        <div className="page-container glass-panel animate-fade-in">
            <div className="page-header">
                <h2>
                    <Repeat size={28} color="var(--accent-color)" />
                    <span>{t('recurringTitle')}</span>
                </h2>
                <p className="page-subtitle">{t('recurringSubtitle')}</p>
            </div>

            <div className="recurring-grid">
                <div className="form-container">
                    <form onSubmit={handleSubmit} className="transaction-form p-0">
                        <div className="form-group type-selector">
                            <label className={`type-btn ${formData.type === 'expense' ? 'active-expense' : ''}`}>
                                <input
                                    type="radio"
                                    name="type"
                                    value="expense"
                                    checked={formData.type === 'expense'}
                                    onChange={(e) => setFormData({ ...formData, type: e.target.value })}
                                    className="sr-only"
                                />
                                Fixed Expense
                            </label>
                            <label className={`type-btn ${formData.type === 'income' ? 'active-income' : ''}`}>
                                <input
                                    type="radio"
                                    name="type"
                                    value="income"
                                    checked={formData.type === 'income'}
                                    onChange={(e) => setFormData({ ...formData, type: e.target.value })}
                                    className="sr-only"
                                />
                                Fixed Income
                            </label>
                        </div>

                        <div className="form-group">
                            <label>{t('description')}</label>
                            <input
                                type="text"
                                placeholder={t('descriptionPlaceholder')}
                                value={formData.description}
                                onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                                required
                                className="form-input"
                            />
                        </div>

                        <div className="form-group">
                            <label>{t('amount')} (Per Cycle)</label>
                            <div className="input-with-symbol">
                                <span className="currency-symbol">{currencySymbol}</span>
                                <input
                                    type="number"
                                    step="0.01"
                                    placeholder="0.00"
                                    value={formData.amount}
                                    onChange={(e) => setFormData({ ...formData, amount: e.target.value })}
                                    required
                                    className="form-input amount-input"
                                />
                            </div>
                        </div>

                        <div className="form-group">
                            <label>{t('frequency')}</label>
                            <select
                                className="form-input"
                                value={formData.frequency}
                                onChange={(e) => setFormData({ ...formData, frequency: e.target.value })}
                            >
                                <option value="weekly">{t('weekly')}</option>
                                <option value="monthly">{t('monthly_freq')}</option>
                                <option value="quarterly">{t('quarterly')}</option>
                                <option value="biannually">{t('biannually')}</option>
                                <option value="annually">{t('annually')}</option>
                            </select>
                        </div>

                        <div className="form-group">
                            <label>{t('category')}</label>
                            <select
                                className="form-input"
                                value={formData.category}
                                onChange={(e) => setFormData({ ...formData, category: e.target.value })}
                            >
                                {CATEGORIES.map(cat => (
                                    <option key={cat} value={cat}>{cat}</option>
                                ))}
                            </select>
                        </div>

                        <button type="submit" className={`submit-btn ${formData.type === 'income' ? 'btn-success' : 'btn-danger'}`}>
                            <PlusCircle size={20} />
                            <span>{t('addRecurring')}</span>
                        </button>
                    </form>
                </div>

                <div className="recurring-list-container">
                    <h3 className="section-title">{t('activeRecurring')}</h3>
                    <div className="transactions-list">
                        {(!recurringTransactions || recurringTransactions.length === 0) ? (
                            <div className="empty-state">
                                <p>{t('noRecurringFound')}</p>
                            </div>
                        ) : (
                            recurringTransactions.map(t => (
                                <div key={t.id} className="transaction-item">
                                    <div className="t-info">
                                        <div className="t-details">
                                            <h4>{t.description}</h4>
                                            <p>{t.category}</p>
                                        </div>
                                    </div>

                                    <div className="t-actions">
                                        <span className={`t-amount ${t.type}`}>
                                            {t.type === 'income' ? '+' : '-'}{formatCurrency(t.amount)}
                                            <span className="monthly-label">{getFrequencyLabel(t.frequency)}</span>
                                        </span>
                                        <button
                                            onClick={() => deleteRecurringTransaction(t.id)}
                                            className="delete-btn"
                                            aria-label="Delete recurring item"
                                        >
                                            <Trash2 size={18} />
                                        </button>
                                    </div>
                                </div>
                            ))
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
}
