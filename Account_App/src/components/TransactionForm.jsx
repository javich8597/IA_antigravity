import { useState } from 'react';
import { useFinance } from '../context/FinanceContext';
import { PlusCircle } from 'lucide-react';
import { CATEGORIES, CATEGORY_KEYS, CATEGORY_HIERARCHY } from '../utils/categoryIcons';
import { predictCategory } from '../utils/smartCategorizer';
import CustomSelect from './CustomSelect';
import CustomDatePicker from './CustomDatePicker';

export default function TransactionForm() {
    const { addTransaction, currencySymbol, t } = useFinance();
    const [formData, setFormData] = useState({
        description: '',
        amount: '',
        type: 'expense',
        category: CATEGORIES[0],
        subcategory: CATEGORY_HIERARCHY[CATEGORIES[0]][0],
        date: new Date().toISOString().split('T')[0]
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

    const handleSubmit = (e) => {
        e.preventDefault();
        if (!formData.description || !formData.amount) return;

        // Store as "MainCategory - SubCategory"
        const finalCategory = `${formData.category} - ${formData.subcategory}`;

        addTransaction({
            ...formData,
            category: finalCategory,
            amount: parseFloat(formData.amount)
        });

        setFormData({
            description: '',
            amount: '',
            type: 'expense',
            category: CATEGORIES[0],
            subcategory: CATEGORY_HIERARCHY[CATEGORIES[0]][0],
            date: new Date().toISOString().split('T')[0]
        });
    };

    const handleCategoryChange = (cat) => {
        setFormData({
            ...formData,
            category: cat,
            subcategory: CATEGORY_HIERARCHY[cat][0] // Reset subcategory when main changes
        });
    };

    return (
        <div className="form-container glass-panel">
            <h2 className="form-title">{t('newTransaction')}</h2>
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

                <button type="submit" className={`submit-btn ${formData.type === 'income' ? 'btn-success' : 'btn-danger'}`}>
                    <PlusCircle size={20} />
                    <span>{formData.type === 'income' ? t('addIncome') : t('addExpense')}</span>
                </button>
            </form>
        </div>
    );
}
