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
    const [typeFilter, setTypeFilter] = useState('all');
    const [searchQuery, setSearchQuery] = useState('');
    const [isSearchFocused, setIsSearchFocused] = useState(false);
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

    // Apply Type Filter locally
    if (combined && typeFilter !== 'all') {
        transactions = transactions.filter(t => t.type === typeFilter);
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
            <div className="list-header" style={{ flexDirection: 'column', gap: '0.20rem', alignItems: 'stretch', marginBottom: '0.85rem' }}>
                {/* Row 1: Filters */}
                <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', width: '100%', flexWrap: 'wrap', gap: '0.5rem' }}>
                    <div className="filter-tabs" style={{ marginLeft: '-12px' }}>
                        <button className={`tab-btn ${filter === 'all' ? 'active' : ''}`} onClick={() => setFilter('all')} style={{ padding: '4px 10px', fontSize: '0.75rem' }}>{t('all')}</button>
                        <button className={`tab-btn ${filter === 'daily' ? 'active' : ''}`} onClick={() => setFilter('daily')} style={{ padding: '4px 10px', fontSize: '0.75rem' }}>{t('daily')}</button>
                        <button className={`tab-btn ${filter === 'monthly' ? 'active' : ''}`} onClick={() => setFilter('monthly')} style={{ padding: '4px 10px', fontSize: '0.75rem' }}>{t('monthly')}</button>
                        <button className={`tab-btn ${filter === 'yearly' ? 'active' : ''}`} onClick={() => setFilter('yearly')} style={{ padding: '4px 10px', fontSize: '0.75rem' }}>{t('yearly')}</button>
                    </div>
                    {combined && (
                        <div className="filter-tabs">
                            <button className={`tab-btn ${typeFilter === 'all' ? 'active' : ''}`} onClick={() => setTypeFilter('all')} style={{ padding: '4px 10px', fontSize: '0.75rem' }}>{t('all')}</button>
                            <button
                                className={`tab-btn ${typeFilter === 'income' ? 'active' : ''}`}
                                onClick={() => setTypeFilter('income')}
                                style={typeFilter === 'income'
                                    ? { padding: '4px 10px', fontSize: '0.75rem', backgroundColor: 'rgba(16, 185, 129, 0.15)', color: 'var(--success)', border: '1px solid rgba(16, 185, 129, 0.3)' }
                                    : { padding: '4px 10px', fontSize: '0.75rem' }
                                }
                            >
                                {t('income')}
                            </button>
                            <button
                                className={`tab-btn ${typeFilter === 'expense' ? 'active' : ''}`}
                                onClick={() => setTypeFilter('expense')}
                                style={typeFilter === 'expense'
                                    ? { padding: '4px 10px', fontSize: '0.75rem', backgroundColor: 'rgba(239, 68, 68, 0.15)', color: 'var(--danger)', border: '1px solid rgba(239, 68, 68, 0.3)' }
                                    : { padding: '4px 10px', fontSize: '0.75rem' }
                                }
                            >
                                {t('expenses')}
                            </button>
                        </div>
                    )}
                </div>

                {/* Row 2: Title & Search */}
                <div style={{ display: 'flex', alignItems: 'center', gap: '1rem', width: '100%', flexWrap: 'wrap' }}>
                    <h2 className="list-title" style={{ marginBottom: 0 }}>{title || t('recentTransactions')}</h2>
                    {combined && (
                        <div
                            className="search-bar-container"
                            style={{
                                position: 'relative',
                                width: (isSearchFocused || searchQuery) ? '100%' : '36px',
                                maxWidth: (isSearchFocused || searchQuery) ? '240px' : '36px',
                                height: '36px',
                                transition: 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)',
                                overflow: 'hidden',
                                borderRadius: '18px',
                                backgroundColor: (isSearchFocused || searchQuery) ? 'rgba(255, 255, 255, 0.05)' : 'transparent',
                                border: (isSearchFocused || searchQuery) ? '1px solid var(--card-border)' : '1px solid transparent',
                                display: 'flex',
                                alignItems: 'center',
                                cursor: (isSearchFocused || searchQuery) ? 'text' : 'pointer'
                            }}
                        >
                            <div style={{
                                position: 'absolute', left: 0, top: 0, width: '36px', height: '36px',
                                display: 'flex', alignItems: 'center', justifyContent: 'center',
                                pointerEvents: 'none', zIndex: 2
                            }}>
                                <Search size={16} color={(isSearchFocused || searchQuery) ? 'var(--text-main)' : 'var(--text-muted)'} style={{ transition: 'color 0.3s ease' }} />
                            </div>
                            <input
                                type="search"
                                value={searchQuery}
                                onChange={(e) => setSearchQuery(e.target.value)}
                                placeholder={t('searchTransactions')}
                                onFocus={() => setIsSearchFocused(true)}
                                onBlur={() => setIsSearchFocused(false)}
                                style={{
                                    width: '100%', height: '100%',
                                    padding: '0 16px 0 36px',
                                    border: 'none', background: 'transparent',
                                    color: 'var(--text-main)', fontSize: '0.9rem',
                                    outline: 'none',
                                    fontFamily: 'inherit',
                                    cursor: 'inherit'
                                }}
                            />
                        </div>
                    )}
                </div>
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
                        const isAutoGenerated = txn.description && txn.description.toUpperCase().includes('(AUTO)');
                        const isVisuallyRecurring = txn.isRecurring || isAutoGenerated;

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
                                                    {isVisuallyRecurring && (
                                                        <span style={{ marginLeft: '6px', fontSize: '0.65em', backgroundColor: 'rgba(99,102,241,0.12)', color: '#818cf8', padding: '1px 5px', borderRadius: '4px', verticalAlign: 'middle' }}>
                                                            <Repeat size={8} style={{ display: 'inline', marginRight: '2px' }} />rec
                                                        </span>
                                                    )}
                                                </h4>
                                                <p className="t-meta">
                                                    {formatCategory(txn.category)}
                                                    {(txn.date || txn.next_date || txn.start_date || txn.created_at) ? ` • ${txn.isRecurring ? 'Upcoming: ' : ''}${formatDate(txn.date || txn.next_date || txn.start_date || txn.created_at)}` : ''}
                                                </p>
                                            </div>
                                        </div>

                                        {/* Centre-right: amount */}
                                        <span className={`t-amount ${txn.type}`}>
                                            {txn.type === 'income' ? '+' : '-'} {formatCurrency(txn.amount)}
                                            {isVisuallyRecurring && <span style={{ fontSize: '0.7em', marginLeft: '2px', opacity: 0.7 }}>{getFrequencyLabel(txn.frequency || 'monthly')}</span>}
                                        </span>

                                        {/* Far right: edit + delete stacked */}
                                        <div className="t-buttons">
                                            {!isVisuallyRecurring && (
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
