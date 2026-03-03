import { ArrowUpCircle, ArrowDownCircle, DollarSign, Repeat, Trash2 } from 'lucide-react';
import { useFinance } from '../context/FinanceContext';
import TransactionList from './TransactionList';

export default function Dashboard() {
    const { calculateTotals, recurringTransactions, deleteRecurringTransaction, formatCurrency, getFrequencyLabel, t } = useFinance();
    const { totalIncome: income, totalExpenses: expense, balance } = calculateTotals();

    return (
        <div className="dashboard-wrapper">
            <div className="dashboard-grid">
                <div className="dashboard-card glass-panel primary-card">
                    <div className="card-header">
                        <h3>{t('totalBalance')}</h3>
                        <div className="icon-wrapper">
                            <DollarSign size={24} color="var(--accent-color)" />
                        </div>
                    </div>
                    <p className="card-amount balance-text">{formatCurrency(balance)}</p>
                </div>

                <div className="dashboard-card glass-panel">
                    <div className="card-header">
                        <h3>{t('income')}</h3>
                        <div className="icon-wrapper success-wrapper">
                            <ArrowUpCircle size={20} color="var(--success)" />
                        </div>
                    </div>
                    <p className="card-amount">{formatCurrency(income)}</p>
                </div>

                <div className="dashboard-card glass-panel">
                    <div className="card-header">
                        <h3>{t('expenses')}</h3>
                        <div className="icon-wrapper danger-wrapper">
                            <ArrowDownCircle size={20} color="var(--danger)" />
                        </div>
                    </div>
                    <p className="card-amount">{formatCurrency(expense)}</p>
                </div>
            </div>

            <div className="dashboard-lists-grid mt-6">
                <TransactionList combined={false} />

                <div className="list-container glass-panel">
                    <div className="list-header">
                        <h2 className="list-title">
                            <Repeat size={20} className="inline mr-2" color="var(--accent-color)" />
                            {t('activeRecurring')}
                        </h2>
                    </div>
                    <div className="transactions-list scrollable-list" style={{ minHeight: '300px' }}>
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
                                        <span className="monthly-label" style={{ fontSize: '0.7em', marginLeft: '2px', opacity: 0.7 }}>{getFrequencyLabel(t.frequency)}</span>
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
            <div className="mt-8">
                <TransactionList combined={true} title={t('totalTransactions')} />
            </div>
        </div>
    );
}
