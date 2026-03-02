import { useState } from 'react';
import { useFinance } from '../context/FinanceContext';
import { Trash2, Calendar, Repeat } from 'lucide-react';
import { getCategoryConfig } from '../utils/categoryIcons';

export default function TransactionList({ combined = false }) {
    const { deleteTransaction, deleteRecurringTransaction, getFilteredTransactions, getAllCombinedTransactions, formatCurrency, getFrequencyLabel, t } = useFinance();
    const [filter, setFilter] = useState('all');

    const transactions = combined ? getAllCombinedTransactions(filter) : getFilteredTransactions(filter);

    const formatDate = (dateString) => {
        if (!dateString) return '';
        const date = new Date(dateString);
        return new Intl.DateTimeFormat('en-US', {
            month: 'short',
            day: 'numeric',
            year: 'numeric'
        }).format(date);
    };

    return (
        <div className="list-container glass-panel">
            <div className="list-header">
                <h2 className="list-title">{combined ? t('recentTransactions') : t('recentTransactions')}</h2>
                <div className="filter-tabs">
                    <button
                        className={`tab-btn ${filter === 'all' ? 'active' : ''}`}
                        onClick={() => setFilter('all')}
                    >
                        {t('all')}
                    </button>
                    <button
                        className={`tab-btn ${filter === 'daily' ? 'active' : ''}`}
                        onClick={() => setFilter('daily')}
                    >
                        {t('daily')}
                    </button>
                    <button
                        className={`tab-btn ${filter === 'monthly' ? 'active' : ''}`}
                        onClick={() => setFilter('monthly')}
                    >
                        {t('monthly')}
                    </button>
                    <button
                        className={`tab-btn ${filter === 'yearly' ? 'active' : ''}`}
                        onClick={() => setFilter('yearly')}
                    >
                        {t('yearly')}
                    </button>
                </div>
            </div>

            <div className="transactions-list">
                {transactions.length === 0 ? (
                    <div className="empty-state">
                        <Calendar size={48} color="var(--text-muted)" style={{ margin: '0 auto 1rem auto', opacity: 0.5 }} />
                        <p>{t('noTransactionsFound')}</p>
                    </div>
                ) : (
                    transactions.map(t => {
                        const { icon: CatIcon, color, bg } = getCategoryConfig(t.category);
                        return (
                            <div key={t.id} className="transaction-item">
                                <div className="t-info">
                                    <div className={`t-icon ${t.type}`} style={{ backgroundColor: bg }}>
                                        <CatIcon size={20} color={color} />
                                    </div>
                                    <div className="t-details">
                                        <h4>
                                            {t.description}
                                            {t.isRecurring && (
                                                <span className="badge-recurring" style={{ marginLeft: '8px', fontSize: '0.7em', backgroundColor: 'rgba(99, 102, 241, 0.1)', color: '#818cf8', padding: '2px 6px', borderRadius: '4px', verticalAlign: 'middle' }}>
                                                    <Repeat size={10} style={{ display: 'inline', marginRight: '2px' }} /> Recurring
                                                </span>
                                            )}
                                        </h4>
                                        <p>{t.category} {t.date ? `• ${formatDate(t.date)}` : ''}</p>
                                    </div>
                                </div>

                                <div className="t-actions">
                                    <span className={`t-amount ${t.type}`}>
                                        {t.type === 'income' ? '+' : '-'}{formatCurrency(t.amount)}
                                        {t.isRecurring && <span style={{ fontSize: '0.7em', marginLeft: '2px', opacity: 0.7 }}>{getFrequencyLabel(t.frequency)}</span>}
                                    </span>
                                    <button
                                        onClick={() => t.isRecurring ? deleteRecurringTransaction(t.id) : deleteTransaction(t.id)}
                                        className="delete-btn"
                                        aria-label="Delete transaction"
                                    >
                                        <Trash2 size={18} />
                                    </button>
                                </div>
                            </div>
                        )
                    })
                )}
            </div>
        </div>
    );
}
