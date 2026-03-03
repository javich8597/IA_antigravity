import { useState } from 'react';
import { useFinance } from '../context/FinanceContext';
import { useAuth } from '../context/AuthContext';
import { User, Target, TrendingUp, PlusCircle, Trash2, ShieldCheck, AlertTriangle, Smile, Meh, Frown } from 'lucide-react';
import { getCategoryConfig } from '../utils/categoryIcons';

export default function Profile() {
    const { user } = useAuth();
    const {
        calculateTotals,
        transactions,
        recurringTransactions,
        goals,
        addGoal,
        updateGoal,
        deleteGoal,
        currencySymbol,
        formatCurrency,
        t,
        getHistoricalSavings
    } = useFinance();

    const { totalIncome: income, totalExpenses: expense } = calculateTotals();

    const [formVisible, setFormVisible] = useState(false);
    const [goalData, setGoalData] = useState({ name: '', targetAmount: '', initialAmount: '', deadline: '' });

    const [simSalaryInc, setSimSalaryInc] = useState(0);
    const [simExpenseRed, setSimExpenseRed] = useState(0);
    const [simYield, setSimYield] = useState(0);

    const { avgSavings } = getHistoricalSavings(3);
    const baseMonthlySavings = avgSavings > 0 ? avgSavings : 0;
    const simulatedMonthlySavings = baseMonthlySavings + Number(simSalaryInc) + Number(simExpenseRed);

    const formatMonths = (m) => {
        if (m === "N/A" || typeof m !== 'number') return "N/A";
        const years = Math.floor(m / 12);
        const months = Math.ceil(m % 12);
        if (years > 0 && months > 0) return `${years}y ${months}m`;
        if (years > 0) return `${years} yr`;
        return `${months} mo`;
    };

    // Quick Add Funds handlers
    const [activeGoalId, setActiveGoalId] = useState(null);
    const [addAmount, setAddAmount] = useState('');

    const handleAddGoal = (e) => {
        e.preventDefault();
        if (!goalData.name || !goalData.targetAmount) return;
        addGoal(goalData);
        setGoalData({ name: '', targetAmount: '', initialAmount: '', deadline: '' });
        setFormVisible(false);
    };

    const handleAddFunds = (e, goal) => {
        e.preventDefault();
        if (!addAmount) return;
        const newTotal = goal.currentAmount + parseFloat(addAmount);
        updateGoal(goal.id, newTotal);
        setAddAmount('');
        setActiveGoalId(null);
    };

    // Calculate Financial Health Ratios
    const savingsRate = income > 0 ? (((income - expense) / income) * 100).toFixed(1) : 0;
    const debtRatio = income > 0 ? ((expense / income) * 100).toFixed(1) : 0;

    let healthStatus = 'Good';
    let HealthIcon = ShieldCheck;
    let healthColor = 'var(--success)';

    if (savingsRate < 0) {
        healthStatus = 'Critical - Deficit';
        HealthIcon = AlertTriangle;
        healthColor = 'var(--danger)';
    } else if (savingsRate < 20) {
        healthStatus = 'Needs Attention - Low Savings';
        HealthIcon = TrendingUp;
        healthColor = 'var(--warning)';
    }

    // Category breakdown mapping — include both one-off and recurring expenses
    const allExpenses = [
        ...transactions.filter(t => t.type === 'expense'),
        ...(recurringTransactions || []).filter(t => t.type === 'expense')
    ];

    const categoryData = allExpenses.reduce((acc, curr) => {
        const existing = acc.find(item => item.name === curr.category);
        const amountNum = parseFloat(curr.amount) || 0;

        if (existing) {
            existing.value += amountNum;
        } else {
            acc.push({ name: curr.category, value: amountNum });
        }
        return acc;
    }, []);
    categoryData.sort((a, b) => b.value - a.value);

    return (
        <div className="page-container animate-fade-in" style={{ paddingBottom: '3rem' }}>
            <div className="page-header" style={{ marginBottom: '2rem' }}>
                <h2>
                    <User size={28} color="var(--accent-color)" />
                    <span>{t('profile')}</span>
                </h2>
                <p className="page-subtitle">Track your overarching financial health and save towards your specific goals.</p>
            </div>

            <div className="dashboard-lists-grid">
                {/* 1. Profile Dashboard: Health & Ratios */}
                <div className="glass-panel" style={{ padding: '1.5rem', display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
                    <h3 className="section-title">Health Overview</h3>

                    <div style={{ display: 'flex', alignItems: 'center', gap: '1rem', padding: '1rem', backgroundColor: 'rgba(255,255,255,0.03)', borderRadius: '8px', borderLeft: `4px solid ${healthColor}` }}>
                        <HealthIcon size={32} color={healthColor} />
                        <div>
                            <h4 style={{ margin: 0, fontWeight: 600 }}>Status: {healthStatus}</h4>
                            <p style={{ margin: 0, fontSize: '0.85rem', color: 'var(--text-muted)' }}>Based on your Income vs Expense ratios calculation.</p>
                        </div>
                    </div>

                    <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                        <div className="form-group" style={{ marginBottom: 0, padding: '1rem', background: 'rgba(0,0,0,0.2)', borderRadius: '8px' }}>
                            <label style={{ color: 'var(--text-muted)' }}>Savings Rate</label>
                            <p style={{ fontSize: '1.5rem', fontWeight: 'bold', color: savingsRate > 20 ? 'var(--success)' : 'var(--text-main)' }}>
                                {savingsRate}%
                            </p>
                            <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Target: &gt; 20%</span>
                        </div>
                        <div className="form-group" style={{ marginBottom: 0, padding: '1rem', background: 'rgba(0,0,0,0.2)', borderRadius: '8px' }}>
                            <label style={{ color: 'var(--text-muted)' }}>Expense (Debt) Ratio</label>
                            <p style={{ fontSize: '1.5rem', fontWeight: 'bold', color: debtRatio > 80 ? 'var(--danger)' : 'var(--text-main)' }}>
                                {debtRatio}%
                            </p>
                            <span style={{ fontSize: '0.75rem', color: 'var(--text-muted)' }}>Target: &lt; 80%</span>
                        </div>
                    </div>

                    <h3 className="section-title" style={{ marginTop: '1rem' }}>Top Expense Categories</h3>
                    {categoryData.length === 0 ? (
                        <p style={{ color: 'var(--text-muted)', fontStyle: 'italic' }}>No expense history to analyze.</p>
                    ) : (
                        <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
                            {categoryData.slice(0, 3).map((cat, idx) => {
                                const { icon: CatIcon, color, bg } = getCategoryConfig(cat.name);
                                const percentage = ((cat.value / expense) * 100).toFixed(0);
                                return (
                                    <div key={idx} style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                                        <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                                            <div style={{ backgroundColor: bg, color: color, padding: '6px', borderRadius: '50%' }}>
                                                <CatIcon size={16} />
                                            </div>
                                            <span style={{ fontWeight: 500 }}>{cat.name}</span>
                                        </div>
                                        <span style={{ fontWeight: 'bold' }}>{percentage}%</span>
                                    </div>
                                );
                            })}
                        </div>
                    )}
                </div>

                {/* 2. Goals Section */}
                <div className="glass-panel" style={{ padding: '1.5rem' }}>
                    <div className="list-header" style={{ marginBottom: '1.5rem' }}>
                        <h3 className="section-title m-0">
                            <Target size={20} className="inline mr-2" color="var(--accent-color)" />
                            Savings Goals
                        </h3>
                        <button onClick={() => setFormVisible(!formVisible)} className="tab-btn" style={{ padding: '0.25rem 0.5rem' }}>
                            <PlusCircle size={16} />
                        </button>
                    </div>

                    {formVisible && (
                        <form onSubmit={handleAddGoal} className="transaction-form" style={{ padding: '1rem', backgroundColor: 'rgba(0,0,0,0.2)', marginBottom: '1.5rem', borderRadius: '8px' }}>
                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                                <div className="form-group">
                                    <label>Goal Title</label>
                                    <input type="text" className="form-input" placeholder="e.g. Dream House" value={goalData.name} onChange={e => setGoalData({ ...goalData, name: e.target.value })} required />
                                </div>
                                <div className="form-group">
                                    <label>Target Date (Optional)</label>
                                    <input type="date" className="form-input" value={goalData.deadline} onChange={e => setGoalData({ ...goalData, deadline: e.target.value })} />
                                </div>
                            </div>
                            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
                                <div className="form-group">
                                    <label>Target Amount</label>
                                    <div className="input-with-symbol">
                                        <span className="currency-symbol">{currencySymbol}</span>
                                        <input type="number" step="0.01" className="form-input amount-input" value={goalData.targetAmount} onChange={e => setGoalData({ ...goalData, targetAmount: e.target.value })} required />
                                    </div>
                                </div>
                                <div className="form-group">
                                    <label>Initial Savings</label>
                                    <div className="input-with-symbol">
                                        <span className="currency-symbol">{currencySymbol}</span>
                                        <input type="number" step="0.01" className="form-input amount-input" value={goalData.initialAmount} onChange={e => setGoalData({ ...goalData, initialAmount: e.target.value })} />
                                    </div>
                                </div>
                            </div>
                            <button type="submit" className="submit-btn btn-success" style={{ padding: '0.5rem', marginTop: '0.5rem' }}>Create Goal</button>
                        </form>
                    )}

                    <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem' }}>
                        {goals.length === 0 && !formVisible ? (
                            <div className="empty-state">
                                <p>You have no active goals.</p>
                            </div>
                        ) : (
                            goals.map(goal => {
                                const progress = Math.min(((goal.currentAmount / goal.targetAmount) * 100), 100).toFixed(1);
                                const isComplete = progress >= 100;
                                const remainingAmount = goal.targetAmount - goal.currentAmount;

                                let baseMonthsLeft = "N/A";
                                if (baseMonthlySavings > 0 && remainingAmount > 0) {
                                    baseMonthsLeft = remainingAmount / baseMonthlySavings;
                                }

                                let simMonthsLeft = "N/A";
                                if (simulatedMonthlySavings > 0 && remainingAmount > 0) {
                                    if (Number(simYield) > 0) {
                                        let tempAmount = goal.currentAmount;
                                        let m = 0;
                                        const monthlyRate = (Number(simYield) / 100) / 12;
                                        while (tempAmount < goal.targetAmount && m < 600) {
                                            tempAmount += simulatedMonthlySavings;
                                            tempAmount += tempAmount * monthlyRate;
                                            m++;
                                        }
                                        simMonthsLeft = m < 600 ? m : "50+ years";
                                    } else {
                                        simMonthsLeft = remainingAmount / simulatedMonthlySavings;
                                    }
                                }

                                // V12: Financial Zone Calculation
                                let zone = 'green';
                                let ZoneIcon = Smile;
                                let zoneColor = 'var(--success)';
                                let requiredSavings = 0;

                                if (goal.deadline) {
                                    const deadlineDate = new Date(goal.deadline);
                                    const now = new Date();
                                    let monthsLeft = (deadlineDate.getFullYear() - now.getFullYear()) * 12 + (deadlineDate.getMonth() - now.getMonth());
                                    // Treat anything past due or due this month as 1 month remaining to avoid division by zero or infinite
                                    if (monthsLeft < 1) monthsLeft = 1;
                                    requiredSavings = remainingAmount / monthsLeft;
                                } else {
                                    // If no deadline, the user's required savings is whatever they are currently pacing at, so they remain 'green' by default.
                                    requiredSavings = remainingAmount > 0 && typeof baseMonthsLeft === 'number' ? (remainingAmount / baseMonthsLeft) : 0;
                                }

                                if (remainingAmount === 0 || requiredSavings === 0) {
                                    zone = 'green';
                                    ZoneIcon = Smile;
                                    zoneColor = 'var(--success)';
                                } else if (baseMonthlySavings >= requiredSavings) {
                                    zone = 'green';
                                    ZoneIcon = Smile;
                                    zoneColor = 'var(--success)';
                                } else if (baseMonthlySavings >= requiredSavings * 0.9) {
                                    zone = 'yellow';
                                    ZoneIcon = Meh;
                                    zoneColor = 'var(--warning)';
                                } else {
                                    zone = 'red';
                                    ZoneIcon = Frown;
                                    zoneColor = 'var(--danger)';
                                }

                                return (
                                    <div key={goal.id} style={{ padding: '1rem', backgroundColor: 'rgba(255,255,255,0.03)', border: '1px solid var(--card-border)', borderRadius: '8px' }}>
                                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '0.75rem' }}>
                                            <div>
                                                <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginBottom: '0.25rem' }}>
                                                    <h4 style={{ margin: 0, fontWeight: 600 }}>{goal.name}</h4>
                                                    {!isComplete && (
                                                        <div title={`Required Savings: ${formatCurrency(requiredSavings)}/mo. Actual: ${formatCurrency(baseMonthlySavings)}/mo`} style={{ display: 'flex', alignItems: 'center' }}>
                                                            <ZoneIcon size={20} color={zoneColor} />
                                                        </div>
                                                    )}
                                                </div>
                                                <p style={{ margin: '0 0 0.25rem 0', fontSize: '0.85rem', color: 'var(--text-muted)' }}>
                                                    {formatCurrency(goal.currentAmount)} / {formatCurrency(goal.targetAmount)}
                                                    {goal.deadline && ` • Target Date: ${goal.deadline}`}
                                                </p>
                                                {!isComplete && (
                                                    <div style={{ display: 'flex', gap: '0.75rem', marginTop: '0.5rem', flexWrap: 'wrap' }}>
                                                        <div style={{ background: 'rgba(0,0,0,0.3)', padding: '0.25rem 0.5rem', borderRadius: '4px', fontSize: '0.75rem' }}>
                                                            <span style={{ color: 'var(--text-muted)' }}>Current Est:</span>
                                                            <strong style={{ marginLeft: '4px' }}>{formatMonths(baseMonthsLeft)}</strong>
                                                        </div>
                                                        {(Number(simSalaryInc) > 0 || Number(simExpenseRed) > 0 || Number(simYield) > 0) && (
                                                            <div style={{ background: 'rgba(99, 102, 241, 0.15)', border: '1px solid rgba(99, 102, 241, 0.3)', padding: '0.25rem 0.5rem', borderRadius: '4px', fontSize: '0.75rem' }}>
                                                                <span style={{ color: 'var(--text-muted)' }}>Optimized Est:</span>
                                                                <strong style={{ marginLeft: '4px', color: '#818cf8' }}>{formatMonths(simMonthsLeft)}</strong>
                                                                {typeof baseMonthsLeft === 'number' && typeof simMonthsLeft === 'number' && baseMonthsLeft > simMonthsLeft && (
                                                                    <span style={{ marginLeft: '4px', color: 'var(--success)' }}>(-{formatMonths(baseMonthsLeft - simMonthsLeft)})</span>
                                                                )}
                                                            </div>
                                                        )}
                                                    </div>
                                                )}
                                            </div>
                                            <button onClick={() => deleteGoal(goal.id)} className="delete-btn">
                                                <Trash2 size={16} />
                                            </button>
                                        </div>

                                        <div style={{ width: '100%', height: '8px', backgroundColor: 'rgba(255,255,255,0.1)', borderRadius: '4px', overflow: 'hidden', marginBottom: '1rem', marginTop: '0.5rem' }}>
                                            <div style={{ width: `${progress}%`, height: '100%', backgroundColor: isComplete ? 'var(--success)' : 'var(--accent-color)', transition: 'width 0.5s ease-in-out' }}></div>
                                        </div>

                                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                                            <span style={{ fontWeight: 'bold', color: isComplete ? 'var(--success)' : 'var(--text-main)' }}>{progress}% {isComplete ? 'Complete!' : ''}</span>

                                            {activeGoalId === goal.id ? (
                                                <form onSubmit={(e) => handleAddFunds(e, goal)} style={{ display: 'flex', gap: '0.5rem' }}>
                                                    <input
                                                        type="number"
                                                        step="0.01"
                                                        placeholder={`+${currencySymbol} amount`}
                                                        value={addAmount}
                                                        onChange={(e) => setAddAmount(e.target.value)}
                                                        style={{ width: '100px', padding: '0.25rem 0.5rem', background: 'rgba(0,0,0,0.3)', border: '1px solid var(--card-border)', borderRadius: '4px', color: 'white' }}
                                                        autoFocus
                                                    />
                                                    <button type="submit" style={{ background: 'var(--success)', color: 'white', border: 'none', borderRadius: '4px', padding: '0 0.5rem', cursor: 'pointer' }}>Add</button>
                                                    <button type="button" onClick={() => setActiveGoalId(null)} style={{ background: 'transparent', color: 'var(--text-muted)', border: 'none', cursor: 'pointer' }}>Cancel</button>
                                                </form>
                                            ) : (
                                                !isComplete && (
                                                    <button
                                                        onClick={() => setActiveGoalId(goal.id)}
                                                        style={{ background: 'rgba(99, 102, 241, 0.15)', color: '#818cf8', border: '1px solid rgba(99, 102, 241, 0.3)', borderRadius: '4px', padding: '0.25rem 0.5rem', cursor: 'pointer', fontSize: '0.85rem' }}
                                                    >
                                                        + Add Savings
                                                    </button>
                                                )
                                            )}
                                        </div>
                                    </div>
                                )
                            })
                        )}
                    </div>
                </div>

            </div>

            {/* 3. Projection Engine Simulator */}
            <div className="glass-panel" style={{ padding: '1.5rem', gridColumn: '1 / -1' }}>
                <div className="list-header" style={{ marginBottom: '1.5rem' }}>
                    <h3 className="section-title m-0">
                        <TrendingUp size={20} className="inline mr-2" color="var(--accent-color)" />
                        Projection Engine Simulator
                    </h3>
                </div>

                <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '1.5rem' }}>
                    <div className="form-group" style={{ marginBottom: 0, padding: '1rem', background: 'rgba(0,0,0,0.2)', borderRadius: '8px', display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
                        <label style={{ color: 'var(--text-muted)' }}>Historical Avg Savings (3 mo)</label>
                        <p style={{ fontSize: '1.5rem', fontWeight: 'bold', color: 'var(--text-main)', margin: '0.5rem 0 0 0' }}>
                            {formatCurrency(baseMonthlySavings)} <span style={{ fontSize: '0.85rem', fontWeight: 'normal' }}>/mo</span>
                        </p>
                    </div>

                    <div className="form-group" style={{ marginBottom: 0 }}>
                        <label>Simulate Salary Increase /mo</label>
                        <div className="input-with-symbol">
                            <span className="currency-symbol">{currencySymbol}</span>
                            <input type="number" step="10" min="0" className="form-input" value={simSalaryInc} onChange={e => setSimSalaryInc(e.target.value)} />
                        </div>
                    </div>

                    <div className="form-group" style={{ marginBottom: 0 }}>
                        <label>Simulate Expense Reduction /mo</label>
                        <div className="input-with-symbol">
                            <span className="currency-symbol">{currencySymbol}</span>
                            <input type="number" step="10" min="0" className="form-input" value={simExpenseRed} onChange={e => setSimExpenseRed(e.target.value)} />
                        </div>
                    </div>

                    <div className="form-group" style={{ marginBottom: 0 }}>
                        <label>Simulate Annual Yield (%)</label>
                        <div className="input-with-symbol">
                            <span className="currency-symbol">%</span>
                            <input type="number" step="0.5" min="0" max="100" className="form-input" value={simYield} onChange={e => setSimYield(e.target.value)} />
                        </div>
                    </div>
                </div>

                <div style={{ marginTop: '1.5rem', padding: '1rem', background: 'rgba(99, 102, 241, 0.1)', border: '1px solid rgba(99, 102, 241, 0.3)', borderRadius: '8px', display: 'flex', justifyContent: 'space-between', alignItems: 'center', flexWrap: 'wrap', gap: '1rem' }}>
                    <div>
                        <h4 style={{ margin: '0 0 0.25rem 0' }}>Simulated Monthly Savings Capacity</h4>
                        <p style={{ margin: 0, fontSize: '0.85rem', color: 'var(--text-muted)' }}>This capacity is applied to your Goals to recalculate the Optimized Estimated Time.</p>
                    </div>
                    <p style={{ fontSize: '1.75rem', fontWeight: 'bold', color: 'var(--accent-color)', margin: 0 }}>
                        {formatCurrency(simulatedMonthlySavings)} <span style={{ fontSize: '0.85rem', fontWeight: 'normal' }}>/mo</span>
                    </p>
                </div>
            </div>

        </div>
    );
}
