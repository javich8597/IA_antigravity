import { useState } from 'react';
import { PieChart, Pie, Cell, ResponsiveContainer, Tooltip as RechartsTooltip, Legend, BarChart, Bar, XAxis, YAxis, CartesianGrid } from 'recharts';
import { useFinance } from '../context/FinanceContext';
import { PieChart as ChartIcon, AlertCircle, BarChart2 } from 'lucide-react';
import { getCategoryConfig, CATEGORY_KEYS } from '../utils/categoryIcons';

export default function Analytics() {
    const { transactions, recurringTransactions, currencySymbol, formatCurrency, t } = useFinance();
    const [chartType, setChartType] = useState('pie');

    // Combine standard and recurring expenses for accurate chart and breakdown
    const allExpenses = [
        ...transactions.filter(t => t.type === 'expense'),
        ...(recurringTransactions || []).filter(t => t.type === 'expense')
    ];

    const categoryData = allExpenses.reduce((acc, curr) => {
        const rootCategory = curr.category ? curr.category.split(' - ')[0] : 'General';
        const existing = acc.find(item => item.name === rootCategory);
        const amountNum = parseFloat(curr.amount) || 0;

        if (existing) {
            existing.value += amountNum;
        } else {
            acc.push({ name: rootCategory, value: amountNum });
        }
        return acc;
    }, []);

    // Sort categoryData by value descending for the breakdown list
    categoryData.sort((a, b) => b.value - a.value);

    // Filter out categories with 0 value
    const finalCategoryData = categoryData.filter(d => d.value > 0).map(d => ({
        ...d,
        displayName: CATEGORY_KEYS[d.name] ? t(CATEGORY_KEYS[d.name]) : d.name
    }));

    const { totalIncome, totalExpenses } = useFinance().calculateTotals();
    const comparisonData = [
        { name: t('income'), amount: parseFloat(totalIncome) || 0 },
        { name: t('expenses'), amount: parseFloat(totalExpenses) || 0 }
    ];

    const COLORS = ['#6366f1', '#a855f7', '#ec4899', '#f43f5e', '#facc15', '#10b981'];

    const CustomTooltip = ({ active, payload, label }) => {
        if (active && payload && payload.length) {
            return (
                <div className="custom-tooltip glass-panel" style={{ padding: '10px', border: '1px solid var(--card-border)' }}>
                    <p className="label" style={{ color: 'var(--text-main)', fontWeight: 'bold' }}>{label || (CATEGORY_KEYS[payload[0].name] ? t(CATEGORY_KEYS[payload[0].name]) : payload[0].name)}</p>
                    <p className="desc" style={{ color: payload[0].payload?.fill || payload[0].color }}>
                        {formatCurrency(payload[0].value)}
                    </p>
                </div>
            );
        }
        return null;
    };

    return (
        <div className="page-container glass-panel animate-fade-in">
            <div className="page-header">
                <h2>
                    <ChartIcon size={28} color="var(--accent-color)" />
                    <span>{t('analytics')}</span>
                </h2>
                <p className="page-subtitle">Visualize where your money goes across different categories.</p>
            </div>

            <div className="chart-controls" style={{ display: 'flex', justifyContent: 'center', gap: '1rem', marginBottom: '2rem' }}>
                <button
                    className={`tab-btn ${chartType === 'pie' ? 'active' : ''}`}
                    onClick={() => setChartType('pie')}
                >
                    <ChartIcon size={16} style={{ display: 'inline', marginRight: '6px' }} />
                    {t('spendingByCategory')}
                </button>
                <button
                    className={`tab-btn ${chartType === 'bar' ? 'active' : ''}`}
                    onClick={() => setChartType('bar')}
                >
                    <BarChart2 size={16} style={{ display: 'inline', marginRight: '6px' }} />
                    {t('incomeVsExpense')}
                </button>
            </div>

            {(chartType === 'pie' && allExpenses.length === 0) || (chartType === 'bar' && transactions.length === 0) ? (
                <div className="empty-state">
                    <AlertCircle size={48} color="var(--text-muted)" style={{ margin: '0 auto 1rem auto', opacity: 0.5 }} />
                    <p>Not enough data to generate this chart.</p>
                </div>
            ) : (
                <div className="analytics-body" style={{ display: 'flex', flexDirection: 'column', gap: '2rem' }}>
                    <div className="chart-container">
                        <h3 className="section-title text-center mb-4">
                            {chartType === 'pie' ? t('spendingByCategory') : t('incomeVsExpense')}
                        </h3>
                        <div style={{ width: '100%', height: 400 }}>
                            {chartType === 'pie' ? (
                                <ResponsiveContainer>
                                    <PieChart>
                                        <Pie
                                            data={finalCategoryData}
                                            cx="50%"
                                            cy="50%"
                                            innerRadius={80}
                                            outerRadius={140}
                                            paddingAngle={5}
                                            dataKey="value"
                                            nameKey="displayName"
                                            stroke="none"
                                        >
                                            {finalCategoryData.map((entry, index) => (
                                                <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                                            ))}
                                        </Pie>
                                        <RechartsTooltip content={<CustomTooltip />} />
                                        <Legend verticalAlign="bottom" height={36} iconType="circle" />
                                    </PieChart>
                                </ResponsiveContainer>
                            ) : (
                                <ResponsiveContainer>
                                    <BarChart data={comparisonData} margin={{ top: 20, right: 30, left: 20, bottom: 5 }}>
                                        <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.1)" vertical={false} />
                                        <XAxis dataKey="name" stroke="var(--text-muted)" />
                                        <YAxis stroke="var(--text-muted)" tickFormatter={(value) => `${currencySymbol}${value}`} />
                                        <RechartsTooltip content={<CustomTooltip />} cursor={{ fill: 'rgba(255,255,255,0.05)' }} />
                                        <Bar dataKey="amount" radius={[4, 4, 0, 0]}>
                                            {comparisonData.map((entry, index) => (
                                                <Cell key={`cell-${index}`} fill={entry.name === t('income') ? 'var(--success)' : 'var(--danger)'} />
                                            ))}
                                        </Bar>
                                    </BarChart>
                                </ResponsiveContainer>
                            )}
                        </div>
                    </div>

                    {chartType === 'pie' && finalCategoryData.length > 0 && (
                        <div className="analytics-breakdown glass-panel" style={{ padding: '1.5rem' }}>
                            <h3 className="section-title" style={{ marginBottom: '1.5rem', textAlign: 'center' }}>Detailed Breakdown</h3>
                            <div className="transactions-list">
                                {finalCategoryData.map((item, index) => {
                                    const { icon: CatIcon, color, bg } = getCategoryConfig(item.name);
                                    const percentage = totalExpenses > 0 ? ((item.value / totalExpenses) * 100).toFixed(1) : 0;

                                    return (
                                        <div key={item.name} className="transaction-item" style={{ borderBottom: index === finalCategoryData.length - 1 ? 'none' : '1px solid var(--card-border)' }}>
                                            <div className="t-left">
                                                <div className="t-icon" style={{ backgroundColor: bg, color: color, borderRadius: '10px' }}>
                                                    <CatIcon size={20} />
                                                </div>
                                                <div className="t-details">
                                                    <h4 className="t-description" style={{ marginBottom: 0 }}>{t(CATEGORY_KEYS[item.name])}</h4>
                                                    <p className="t-meta">{percentage}% of total expenses</p>
                                                </div>
                                            </div>
                                            <span className="t-amount expense">
                                                {formatCurrency(item.value)}
                                            </span>
                                        </div>
                                    );
                                })}
                            </div>
                        </div>
                    )}
                </div>
            )}
        </div>
    );
}
