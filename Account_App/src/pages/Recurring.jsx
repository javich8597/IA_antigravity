import { useState } from 'react';
import { PlusCircle, Trash2, Repeat } from 'lucide-react';
import { useFinance } from '../context/FinanceContext';
import { CATEGORIES, CATEGORY_KEYS, CATEGORY_HIERARCHY } from '../utils/categoryIcons';
import { predictCategory } from '../utils/smartCategorizer';
import CustomSelect from '../components/CustomSelect';
import CustomDatePicker from '../components/CustomDatePicker';

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
        category: CATEGORIES[0],
        subcategory: CATEGORY_HIERARCHY[CATEGORIES[0]][0],
        startDate: new Date().toISOString().split('T')[0]
    });

    const handleDescriptionChange = (e) => {
        const val = e.target.value;
        const auto = predictCategory(val);

        let updates = { description: val };
        if (auto) {
            updates.category = auto.category;
            updates.subcategory = auto.subcategory;
        }

        setFormData(prev => ({
            ...prev,
            ...updates
        }));
    };

    const handleCategoryChange = (cat) => {
        setFormData({
            ...formData,
            category: cat,
            subcategory: CATEGORY_HIERARCHY[cat][0]
        });
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        if (!formData.description || !formData.amount || !formData.startDate) return;

        const finalCategory = `${formData.category} - ${formData.subcategory}`;

        addRecurringTransaction({
            ...formData,
            category: finalCategory,
            amount: parseFloat(formData.amount)
        });
        setFormData({
            description: '',
            amount: '',
            frequency: 'monthly',
            type: 'expense',
            category: CATEGORIES[0],
            subcategory: CATEGORY_HIERARCHY[CATEGORIES[0]][0],
            startDate: new Date().toISOString().split('T')[0]
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
                                {t('fixedExpense')}
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
                                {t('fixedIncome')}
                            </label>
                        </div>

                        <div className="form-group">
                            <label>{t('description')}</label>
                            <input
                                type="text"
                                placeholder={t('descriptionPlaceholder')}
                                value={formData.description}
                                onChange={handleDescriptionChange}
                                required
                                className="form-input"
                            />
                        </div>

                        <div className="form-group">
                            <label>{t('date')} (Start Date)</label>
                            <input
                                type="date"
                                className="form-input"
                                value={formData.startDate}
                                onChange={(e) => setFormData({ ...formData, startDate: e.target.value })}
                                required
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
                            <CustomSelect
                                value={formData.frequency}
                                onChange={(val) => setFormData({ ...formData, frequency: val })}
                                options={[
                                    { value: 'weekly', label: t('weekly') },
                                    { value: 'monthly', label: t('monthly_freq') },
                                    { value: 'quarterly', label: t('quarterly') },
                                    { value: 'biannually', label: t('biannually') },
                                    { value: 'annually', label: t('annually') }
                                ]}
                            />
                        </div>

                        <div className="form-group">
                            <label>{t('category')}</label>
                            <CustomSelect
                                value={formData.category}
                                onChange={handleCategoryChange}
                                options={CATEGORIES.map(cat => ({ value: cat, label: t(CATEGORY_KEYS[cat]) }))}
                            />
                        </div>

                        <div className="form-group">
                            <label>{t('subcategory')}</label>
                            <CustomSelect
                                value={formData.subcategory}
                                onChange={(val) => setFormData({ ...formData, subcategory: val })}
                                options={CATEGORY_HIERARCHY[formData.category].map(sub => ({ value: sub, label: sub }))}
                            />
                        </div>

                        <button type="submit" className={`submit-btn ${formData.type === 'income' ? 'btn-success' : 'btn-danger'}`}>
                            <PlusCircle size={20} />
                            <span>{t('addRecurring')}</span>
                        </button>
                    </form>
                </div>

                <div className="recurring-list-container">
                    <h3 className="section-title">{t('activeRecurring')}</h3>
                    <div className="transactions-list scrollable-list">
                        {(!recurringTransactions || recurringTransactions.length === 0) ? (
                            <div className="empty-state">
                                <p>{t('noRecurringFound')}</p>
                            </div>
                        ) : (
                            recurringTransactions.map(t => (
                                <div key={t.id} className="transaction-item">
                                    {/* Left side: text block */}
                                    <div className="t-left">
                                        <div className="t-details">
                                            <h4 className="t-description" style={{ marginBottom: 0 }}>{t.description}</h4>
                                            <p className="t-meta">{t.category}</p>
                                        </div>
                                    </div>

                                    {/* Centre-right: amount */}
                                    <span className={`t-amount ${t.type}`}>
                                        {t.type === 'income' ? '+' : '-'}{formatCurrency(t.amount)}
                                        <span className="monthly-label" style={{ fontSize: '0.7em', marginLeft: '4px', opacity: 0.7 }}>{getFrequencyLabel(t.frequency)}</span>
                                    </span>

                                    {/* Far right: delete button */}
                                    <div className="t-buttons">
                                        <button
                                            onClick={() => deleteRecurringTransaction(t.id)}
                                            className="delete-btn"
                                            aria-label="Delete recurring item"
                                        >
                                            <Trash2 size={13} />
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
