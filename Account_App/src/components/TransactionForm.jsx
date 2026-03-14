import { useState, useRef, useEffect } from 'react';
import { useFinance } from '../context/FinanceContext';
import { Sparkles, PlusCircle, Plus, X, Repeat } from 'lucide-react';
import { CATEGORIES, CATEGORY_KEYS, CATEGORY_HIERARCHY } from '../utils/categoryIcons';
import { predictCategoryAI } from '../utils/smartCategorizer';
import CustomSelect from './CustomSelect';
import CustomDatePicker from './CustomDatePicker';

export default function TransactionForm() {
    const { addTransaction, addRecurringTransaction, currencySymbol, t } = useFinance();
    const [formData, setFormData] = useState({
        description: '',
        amount: '',
        type: 'expense',
        category: CATEGORIES[0],
        subcategory: CATEGORY_HIERARCHY[CATEGORIES[0]][0],
        date: new Date().toISOString().split('T')[0],
        isRecurring: false,
        frequency: 'monthly'
    });
    const [isExpanded, setIsExpanded] = useState(false);
    const [isPredicting, setIsPredicting] = useState(false);
    const debounceTimer = useRef(null);

    // Run prediction when description mounts/updates but debounced
    const handleDescriptionChange = (e) => {
        const val = e.target.value;
        setFormData(prev => ({ ...prev, description: val }));

        if (debounceTimer.current) clearTimeout(debounceTimer.current);

        if (!val.trim()) {
            setIsPredicting(false);
            return;
        }

        setIsPredicting(true);
        debounceTimer.current = setTimeout(async () => {
            const auto = await predictCategoryAI(val);
            if (auto) {
                setFormData(prev => ({
                    ...prev,
                    category: auto.category,
                    subcategory: auto.subcategory
                }));
            }
            setIsPredicting(false);
        }, 600); // Wait 600ms after user stops typing to run AI
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        if (!formData.description || !formData.amount) return;

        // Store as "MainCategory - SubCategory"
        const finalCategory = `${formData.category} - ${formData.subcategory}`;

        if (formData.isRecurring) {
            addRecurringTransaction({
                ...formData,
                category: finalCategory,
                amount: parseFloat(formData.amount),
                startDate: formData.date
            });
        } else {
            addTransaction({
                ...formData,
                category: finalCategory,
                amount: parseFloat(formData.amount)
            });
        }

        setFormData({
            description: '',
            amount: '',
            type: 'expense',
            category: CATEGORIES[0],
            subcategory: CATEGORY_HIERARCHY[CATEGORIES[0]][0],
            date: new Date().toISOString().split('T')[0],
            isRecurring: false,
            frequency: 'monthly'
        });
    };

    const handleCategoryChange = (cat) => {
        setFormData({
            ...formData,
            category: cat,
            subcategory: CATEGORY_HIERARCHY[cat][0] // Reset subcategory when main changes
        });
    };

    if (!isExpanded) {
        return (
            <button
                onClick={() => setIsExpanded(true)}
                className="glass-panel"
                style={{
                    width: '100%', padding: '1.25rem', display: 'flex', alignItems: 'center',
                    justifyContent: 'center', gap: '0.75rem', fontSize: '1.1rem',
                    fontWeight: 600, color: 'var(--text-main)', border: '1px dashed var(--card-border)',
                    cursor: 'pointer', transition: 'all 0.2s', background: 'rgba(255,255,255,0.02)',
                    boxShadow: 'none'
                }}
                onMouseEnter={e => { e.currentTarget.style.background = 'rgba(99,102,241,0.08)'; e.currentTarget.style.borderColor = '#818cf8'; }}
                onMouseLeave={e => { e.currentTarget.style.background = 'rgba(255,255,255,0.02)'; e.currentTarget.style.borderColor = 'var(--card-border)'; }}
            >
                <Plus size={20} color="#818cf8" /> {t('newTransaction')}
            </button>
        );
    }

    return (
        <div className="form-container glass-panel" style={{ animation: 'slideDown 0.3s ease-out', position: 'relative' }}>
            <button
                onClick={() => setIsExpanded(false)}
                style={{ position: 'absolute', top: '1.35rem', right: '1.25rem', background: 'transparent', border: 'none', color: 'var(--text-muted)', cursor: 'pointer', zIndex: 10 }}
                title="Cancel"
                onMouseEnter={e => e.currentTarget.style.color = 'var(--text-main)'}
                onMouseLeave={e => e.currentTarget.style.color = 'var(--text-muted)'}
            >
                <X size={18} />
            </button>
            <h2 className="form-title" style={{ paddingRight: '2rem' }}>{t('newTransaction')}</h2>
            <form onSubmit={handleSubmit} className="transaction-form">
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
                        {t('expenses')}
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
                        {t('income')}
                    </label>
                </div>

                <div className="form-group">
                    <label style={{ display: 'flex', alignItems: 'center', gap: '0.4rem' }}>
                        {t('description')}
                        {isPredicting && (
                            <Sparkles size={14} color="#818cf8" style={{ animation: 'pulse 1.5s infinite' }} />
                        )}
                    </label>
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
                    <label>{t('amount')}</label>
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

                <div className="form-group">
                    <label>{t('date')}</label>
                    <CustomDatePicker
                        value={formData.date}
                        onChange={(val) => setFormData({ ...formData, date: val })}
                    />
                </div>

                <div className="form-group" style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem', marginBottom: '1.5rem', padding: '1rem', backgroundColor: 'rgba(99,102,241,0.05)', borderRadius: '12px', border: '1px solid rgba(99,102,241,0.1)' }}>
                    <label style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', cursor: 'pointer', margin: 0 }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                            <Repeat size={16} color="#818cf8" />
                            <span style={{ fontWeight: 500, color: 'var(--text-main)', fontSize: '0.95rem' }}>Make Recurring</span>
                        </div>
                        <div style={{ width: '40px', height: '22px', background: formData.isRecurring ? '#818cf8' : 'var(--card-border)', borderRadius: '20px', position: 'relative', transition: 'all 0.3s' }}>
                            <div style={{ width: '18px', height: '18px', background: 'white', borderRadius: '50%', position: 'absolute', top: '2px', left: formData.isRecurring ? '20px' : '2px', transition: 'all 0.3s', boxShadow: '0 2px 4px rgba(0,0,0,0.2)' }} />
                            <input
                                type="checkbox"
                                checked={formData.isRecurring}
                                onChange={(e) => setFormData({ ...formData, isRecurring: e.target.checked })}
                                className="sr-only"
                            />
                        </div>
                    </label>

                    {formData.isRecurring && (
                        <div style={{ marginTop: '0.75rem', paddingTop: '0.75rem', borderTop: '1px dashed rgba(99,102,241,0.2)' }}>
                            <label style={{ fontSize: '0.8rem', color: 'var(--text-muted)', marginBottom: '6px', display: 'block' }}>Frequency</label>
                            <CustomSelect
                                value={formData.frequency}
                                onChange={(val) => setFormData({ ...formData, frequency: val })}
                                options={[
                                    { value: 'weekly', label: t('weekly') || 'Weekly' },
                                    { value: 'monthly', label: t('monthly') || 'Monthly' },
                                    { value: 'quarterly', label: t('quarterly') || 'Quarterly' },
                                    { value: 'biannually', label: t('biannually') || 'Biannually' },
                                    { value: 'annually', label: t('annually') || 'Annually' }
                                ]}
                            />
                        </div>
                    )}
                </div>

                <button type="submit" className={`submit-btn ${formData.type === 'income' ? 'btn-success' : 'btn-danger'}`}>
                    <PlusCircle size={20} />
                    <span>{formData.type === 'income' ? t('addIncome') : t('addExpense')}</span>
                </button>
            </form>
        </div>
    );
}
