import { useState, useMemo } from 'react';
import { useFinance } from '../context/FinanceContext';
import { Trash2, Calendar, Repeat, Pencil, Check, X, Search } from 'lucide-react';
import { getCategoryConfig, CATEGORY_KEYS, CATEGORIES, CATEGORY_HIERARCHY } from '../utils/categoryIcons';

export default function TransactionList({ combined = false, title }) {
    const {
        deleteTransaction,
        deleteRecurringTransaction,
        updateTransaction,
        getFilteredTransactions,
        getAllCombinedTransactions,
        formatCurrency,
        getFrequencyLabel,
        t
    } = useFinance();

    const [filter, setFilter] = useState('all');
    const [searchQuery, setSearchQuery] = useState('');
    const [editingId, setEditingId] = useState(null);
    const [editData, setEditData] = useState({});

    let transactions = combined ? getAllCombinedTransactions(filter) : getFilteredTransactions(filter);

    // Hide auto-generated recurring items from the "Recent Transactions" view
    if (!combined) {
        transactions = transactions.filter(t => !(t.description && t.description.endsWith('(Auto)')));
    }

    // Apply Search Filter locally
    if (combined && searchQuery.trim()) {
        const query = searchQuery.toLowerCase();
        transactions = transactions.filter(t =>
            (t.description && t.description.toLowerCase().includes(query)) ||
            (t.category && t.category.toLowerCase().includes(query)) ||
            (t.amount && t.amount.toString().includes(query))
        );
    }

    const formatDate = (dateString) => {
        if (!dateString) return '';
        const date = new Date(dateString);
        return new Intl.DateTimeFormat('en-US', {
            month: 'short',
            day: 'numeric',
            year: 'numeric'
        }).format(date);
    };

    const startEdit = (txn) => {
        setEditingId(txn.id);
        const parts = txn.category ? txn.category.split(' - ') : [CATEGORIES[0]];
        setEditData({
            description: txn.description,
            amount: txn.amount,
            category: parts[0],
            subcategory: parts[1] || CATEGORY_HIERARCHY[parts[0]][0] || '',
            date: txn.date || ''
        });
    };

    const cancelEdit = () => {
        setEditingId(null);
        setEditData({});
    };

    const saveEdit = (id) => {
        const payload = { ...editData };
        payload.category = payload.subcategory ? `${payload.category} - ${payload.subcategory}` : payload.category;
        delete payload.subcategory;

        updateTransaction(id, payload);
        setEditingId(null);
        setEditData({});
    };

    const formatCategory = (catString) => {
        if (!catString) return '';
        const parts = catString.split(' - ');
        const main = t(CATEGORY_KEYS[parts[0]]) || parts[0];
        if (parts[1]) {
            return `${main} › ${parts[1]}`;
        }
        return main;
    };

    return (
        <div className="list-container glass-panel">
            <div className="list-header" style={{ flexDirection: 'column', gap: '1rem', alignItems: 'stretch' }}>
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', width: '100%', flexWrap: 'wrap', gap: '1rem' }}>
                    <h2 className="list-title" style={{ marginBottom: 0 }}>{title || t('recentTransactions')}</h2>
                    <div className="filter-tabs">
                        <button className={`tab-btn ${filter === 'all' ? 'active' : ''}`} onClick={() => setFilter('all')}>{t('all')}</button>
                        <button className={`tab-btn ${filter === 'daily' ? 'active' : ''}`} onClick={() => setFilter('daily')}>{t('daily')}</button>
                        <button className={`tab-btn ${filter === 'monthly' ? 'active' : ''}`} onClick={() => setFilter('monthly')}>{t('monthly')}</button>
                        <button className={`tab-btn ${filter === 'yearly' ? 'active' : ''}`} onClick={() => setFilter('yearly')}>{t('yearly')}</button>
                    </div>
                </div>
                {combined && (
                    <div className="search-bar-container" style={{ position: 'relative', width: '100%' }}>
                        <Search size={16} style={{ position: 'absolute', left: '14px', top: '50%', transform: 'translateY(-50%)', color: 'var(--text-muted)' }} />
                        <input
                            type="search"
                            value={searchQuery}
                            onChange={(e) => setSearchQuery(e.target.value)}
                            placeholder={t('searchTransactions')}
                            style={{
                                width: '100%',
                                padding: '10px 16px 10px 40px',
                                borderRadius: '12px',
                                border: '1px solid var(--card-border)',
                                backgroundColor: 'rgba(255, 255, 255, 0.03)',
                                color: 'var(--text-main)',
                                fontSize: '0.9rem',
                                outline: 'none',
                                transition: 'all 0.2s ease',
                                fontFamily: 'inherit'
                            }}
                            onFocus={(e) => {
                                e.target.style.backgroundColor = 'rgba(255, 255, 255, 0.06)';
                                e.target.style.borderColor = 'var(--text-muted)';
                            }}
                            onBlur={(e) => {
                                e.target.style.backgroundColor = 'rgba(255, 255, 255, 0.03)';
                                e.target.style.borderColor = 'var(--card-border)';
                            }}
                        />
                    </div>
                )}
            </div>

            {/* Scrollable container — fixed height so the panel doesn't grow */}
            <div className="transactions-list scrollable-list">
                {transactions.length === 0 ? (
                    <div className="empty-state">
                        <Calendar size={48} color="var(--text-muted)" style={{ margin: '0 auto 1rem auto', opacity: 0.5 }} />
                        <p>{t('noTransactionsFound')}</p>
                    </div>
                ) : (
                    transactions.map(txn => {
                        const { icon: CatIcon, color, bg } = getCategoryConfig(txn.category);
                        const isEditing = editingId === txn.id;

                        return (
                            <div key={txn.id} className="transaction-item" style={isEditing ? { flexDirection: 'column', alignItems: 'stretch', gap: '1rem', padding: '1.25rem', overflow: 'visible', zIndex: 10 } : {}}>
                                {isEditing ? (
                                    /* --- Inline Edit Form --- */
                                    <div style={{ display: 'flex', flexDirection: 'column', gap: '1rem', width: '100%' }}>
                                        <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
                                            <div className="form-group" style={{ marginBottom: 0 }}>
                                                <label style={{ fontSize: '0.75rem' }}>Description</label>
                                                <input
                                                    className="form-input"
                                                    style={{ padding: '0.6rem 0.75rem', fontSize: '0.9rem', backgroundColor: 'var(--bg-color)', width: '100%' }}
                                                    value={editData.description}
                                                    onChange={e => setEditData({ ...editData, description: e.target.value })}
                                                />
                                            </div>
                                            <div className="form-group" style={{ marginBottom: 0 }}>
                                                <label style={{ fontSize: '0.75rem' }}>Amount</label>
                                                <input
                                                    type="number"
                                                    step="0.01"
                                                    className="form-input"
                                                    style={{ padding: '0.6rem 0.75rem', fontSize: '0.9rem', backgroundColor: 'var(--bg-color)', width: '100%' }}
                                                    value={editData.amount}
                                                    onChange={e => setEditData({ ...editData, amount: e.target.value })}
                                                />
                                            </div>
                                            <div style={{ display: 'flex', gap: '0.5rem' }}>
                                                <div className="form-group" style={{ marginBottom: 0, flex: 1 }}>
                                                    <label style={{ fontSize: '0.75rem' }}>Category</label>
                                                    <select
                                                        className="form-input"
                                                        style={{ padding: '0.6rem 0.75rem', fontSize: '0.9rem', backgroundColor: 'var(--bg-color)', width: '100%', appearance: 'auto' }}
                                                        value={editData.category}
                                                        onChange={e => setEditData({ ...editData, category: e.target.value, subcategory: CATEGORY_HIERARCHY[e.target.value][0] })}
                                                    >
                                                        {CATEGORIES.map(cat => (
                                                            <option key={cat} value={cat}>{t(CATEGORY_KEYS[cat])}</option>
                                                        ))}
                                                    </select>
                                                </div>
                                                <div className="form-group" style={{ marginBottom: 0, flex: 1 }}>
                                                    <label style={{ fontSize: '0.75rem' }}>Subcategory</label>
                                                    <select
                                                        className="form-input"
                                                        style={{ padding: '0.6rem 0.75rem', fontSize: '0.9rem', backgroundColor: 'var(--bg-color)', width: '100%', appearance: 'auto' }}
                                                        value={editData.subcategory}
                                                        onChange={e => setEditData({ ...editData, subcategory: e.target.value })}
                                                    >
                                                        {(CATEGORY_HIERARCHY[editData.category] || []).map(sub => (
                                                            <option key={sub} value={sub}>{sub}</option>
                                                        ))}
                                                    </select>
                                                </div>
                                            </div>
                                            <div className="form-group" style={{ marginBottom: 0 }}>
                                                <label style={{ fontSize: '0.75rem' }}>Date</label>
                                                <input
                                                    type="date"
                                                    className="form-input"
                                                    style={{ padding: '0.6rem 0.75rem', fontSize: '0.9rem', backgroundColor: 'var(--bg-color)', width: '100%' }}
                                                    value={editData.date}
                                                    onChange={e => setEditData({ ...editData, date: e.target.value })}
                                                />
                                            </div>
                                        </div>
                                        <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '0.5rem', marginTop: '0.5rem' }}>
                                            <button
                                                onClick={cancelEdit}
                                                style={{ background: 'transparent', border: '1px solid var(--card-border)', color: 'var(--text-muted)', borderRadius: '8px', padding: '0.4rem 1rem', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.85rem' }}
                                                onMouseEnter={e => { e.currentTarget.style.background = 'rgba(255,255,255,0.05)'; e.currentTarget.style.color = 'var(--text-main)'; }}
                                                onMouseLeave={e => { e.currentTarget.style.background = 'transparent'; e.currentTarget.style.color = 'var(--text-muted)'; }}
                                            >
                                                <X size={15} /> Cancel
                                            </button>
                                            <button
                                                onClick={() => saveEdit(txn.id)}
                                                style={{ background: 'var(--success)', border: 'none', color: 'white', borderRadius: '8px', padding: '0.4rem 1rem', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: '6px', fontSize: '0.85rem', fontWeight: 500 }}
                                                onMouseEnter={e => e.currentTarget.style.filter = 'brightness(1.1)'}
                                                onMouseLeave={e => e.currentTarget.style.filter = 'brightness(1)'}
                                            >
                                                <Check size={15} /> Save
                                            </button>
                                        </div>
                                    </div>
                                ) : (
                                    /* --- Normal Row View --- */
                                    <>
                                        {/* Left: icon + description + meta */}
                                        <div className="t-left">
                                            <div className={`t-icon ${txn.type}`} style={{ backgroundColor: bg }}>
                                                <CatIcon size={18} color={color} />
                                            </div>
                                            <div className="t-details">
                                                <h4 className="t-description">
                                                    {txn.description}
                                                    {txn.isRecurring && (
                                                        <span style={{ marginLeft: '6px', fontSize: '0.65em', backgroundColor: 'rgba(99,102,241,0.12)', color: '#818cf8', padding: '1px 5px', borderRadius: '4px', verticalAlign: 'middle' }}>
                                                            <Repeat size={8} style={{ display: 'inline', marginRight: '2px' }} />rec
                                                        </span>
                                                    )}
                                                </h4>
                                                <p className="t-meta">
                                                    {formatCategory(txn.category)}
                                                    {(txn.date || txn.start_date || txn.created_at) ? ` • ${formatDate(txn.date || txn.start_date || txn.created_at)}` : ''}
                                                </p>
                                            </div>
                                        </div>

                                        {/* Centre-right: amount */}
                                        <span className={`t-amount ${txn.type}`}>
                                            {txn.type === 'income' ? '+' : '-'} {formatCurrency(txn.amount)}
                                            {txn.isRecurring && <span style={{ fontSize: '0.7em', marginLeft: '2px', opacity: 0.7 }}>{getFrequencyLabel(txn.frequency)}</span>}
                                        </span>

                                        {/* Far right: edit + delete stacked */}
                                        <div className="t-buttons">
                                            {!txn.isRecurring && (
                                                <button
                                                    onClick={() => startEdit(txn)}
                                                    className="delete-btn"
                                                    aria-label="Edit transaction"
                                                    title="Edit"
                                                    style={{ color: 'var(--text-muted)' }}
                                                    onMouseEnter={e => { e.currentTarget.style.background = 'rgba(99,102,241,0.15)'; e.currentTarget.style.color = '#818cf8'; }}
                                                    onMouseLeave={e => { e.currentTarget.style.background = 'transparent'; e.currentTarget.style.color = 'var(--text-muted)'; }}
                                                >
                                                    <Pencil size={13} />
                                                </button>
                                            )}
                                            <button
                                                onClick={() => txn.isRecurring ? deleteRecurringTransaction(txn.id) : deleteTransaction(txn.id)}
                                                className="delete-btn"
                                                aria-label="Delete transaction"
                                                title="Delete"
                                            >
                                                <Trash2 size={13} />
                                            </button>
                                        </div>
                                    </>
                                )}
                            </div>
                        );
                    })
                )}
            </div>
        </div>
    );
}
