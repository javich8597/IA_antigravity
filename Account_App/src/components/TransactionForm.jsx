import { useState } from 'react';
import { useFinance } from '../context/FinanceContext';
import { PlusCircle } from 'lucide-react';
import { CATEGORIES, CATEGORY_KEYS } from '../utils/categoryIcons';
import CustomSelect from './CustomSelect';
import CustomDatePicker from './CustomDatePicker';

export default function TransactionForm() {
    const { addTransaction, currencySymbol, t } = useFinance();
    const [formData, setFormData] = useState({
        description: '',
        amount: '',
        type: 'expense',
        category: CATEGORIES[0],
        date: new Date().toISOString().split('T')[0]
    });

    const handleSubmit = (e) => {
        e.preventDefault();
        if (!formData.description || !formData.amount) return;

        addTransaction({
            ...formData,
            amount: parseFloat(formData.amount)
        });

        setFormData({
            description: '',
            amount: '',
            type: 'expense',
            category: CATEGORIES[0],
            date: new Date().toISOString().split('T')[0]
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
                        onChange={(e) => setFormData({ ...formData, description: e.target.value })}
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
                        onChange={(val) => setFormData({ ...formData, category: val })}
                        options={CATEGORIES.map(cat => ({ value: cat, label: t(CATEGORY_KEYS[cat]) }))}
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
