import { useState } from 'react';
import { useFinance } from '../context/FinanceContext';
import {
    LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
    PieChart, Pie, Cell, Legend
} from 'recharts';
import {
    PiggyBank, TrendingUp, Home, CreditCard, ShieldAlert, Target, Search, Clock, PlusCircle
} from 'lucide-react';

export default function Wealth() {
    const {
        wealthData,
        updateWealth,
        getDynamicLiquidCash,
        getBlindSpots,
        simulateGoalAffordability,
        formatCurrency,
        t
    } = useFinance();

    const [editMode, setEditMode] = useState(false);
    const [formData, setFormData] = useState({
        liquid_cash: wealthData?.liquid_cash || 0,
        investments: wealthData?.investments || 0,
        real_estate: wealthData?.real_estate || 0,
        liabilities: wealthData?.liabilities || 0
    });

    const [goalTarget, setGoalTarget] = useState('');

    // Safety check during initial load
    if (!wealthData) return <div className="loading-state">{t('Loading...')}</div>;

    const dynamicCash = getDynamicLiquidCash();
    const netWorth = dynamicCash + Number(wealthData.investments) + Number(wealthData.real_estate) - Number(wealthData.liabilities);

    const blindSpots = getBlindSpots();
    const simulation = goalTarget ? simulateGoalAffordability(Number(goalTarget)) : null;

    const handleSaveSnapshot = () => {
        // If liquid cash was changed, we must recalibrate the date so flow calculates cleanly from today
        const hasCashChanged = Number(formData.liquid_cash) !== Number(wealthData.liquid_cash);

        updateWealth({
            liquid_cash: Number(formData.liquid_cash),
            investments: Number(formData.investments),
            real_estate: Number(formData.real_estate),
            liabilities: Number(formData.liabilities),
            ...(hasCashChanged && { last_recalibrated_date: new Date().toISOString() })
        });
        setEditMode(false);
    };

    // Calculate Asset Distribution for Pie Chart
    const assetsData = [
        { name: t('Liquid Cash'), value: Math.max(0, dynamicCash) },
        { name: t('Investments'), value: Math.max(0, Number(wealthData.investments)) },
        { name: t('Real Estate'), value: Math.max(0, Number(wealthData.real_estate)) }
    ].filter(a => a.value > 0);
    const COLORS = ['#22c55e', '#3b82f6', '#8b5cf6'];

    return (
        <div className="wealth-container">
            <header className="page-header">
                <div>
                    <h1>{t('Financial Health')}</h1>
                    <p className="subtitle">{t('Track your net worth and analyze your wealth-building trajectory.')}</p>
                </div>
            </header>

            {/* Top Stat: Net Worth */}
            <div className="net-worth-hero">
                <div className="nw-label">{t('Total Net Worth')}</div>
                <div className="nw-value">{formatCurrency(netWorth)}</div>
                <div className="nw-badge">
                    {netWorth >= 0 ? <TrendingUp size={16} /> : <TrendingUp size={16} className="down" />}
                    <span>{netWorth >= 0 ? t('Positive Equity') : t('Negative Equity')}</span>
                </div>
            </div>

            <div className="dashboard-grid wealth-grid">

                {/* Balance Sheet Panel */}
                <div className="card balance-sheet-card">
                    <div className="card-header">
                        <h2>{t('Balance Sheet')}</h2>
                        <button className="btn-secondary small" onClick={() => setEditMode(!editMode)}>
                            {editMode ? t('Cancel') : t('Edit Assets')}
                        </button>
                    </div>

                    <div className="bs-item">
                        <div className="bs-label">
                            <PiggyBank size={18} className="text-green" />
                            <div>
                                <strong>{t('Liquid Cash')}</strong>
                                <span className="help-text">{t('Live calculating from txns')}</span>
                            </div>
                        </div>
                        {editMode ? (
                            <input
                                type="number"
                                value={formData.liquid_cash}
                                onChange={(e) => setFormData({ ...formData, liquid_cash: e.target.value })}
                                placeholder="Recalibrate base cash"
                            />
                        ) : (
                            <span className="bs-value">{formatCurrency(dynamicCash)}</span>
                        )}
                    </div>

                    <div className="bs-item">
                        <div className="bs-label">
                            <TrendingUp size={18} className="text-blue" />
                            <strong>{t('Investments')}</strong>
                        </div>
                        {editMode ? (
                            <input
                                type="number"
                                value={formData.investments}
                                onChange={(e) => setFormData({ ...formData, investments: e.target.value })}
                            />
                        ) : (
                            <span className="bs-value">{formatCurrency(wealthData.investments)}</span>
                        )}
                    </div>

                    <div className="bs-item">
                        <div className="bs-label">
                            <Home size={18} className="text-purple" />
                            <div>
                                <strong>{t('Real Estate')}</strong>
                                <span className="help-text" title="Enter a conservative current market value, not your purchase price.">
                                    ⓘ {t('Market Value')}
                                </span>
                            </div>
                        </div>
                        {editMode ? (
                            <input
                                type="number"
                                value={formData.real_estate}
                                onChange={(e) => setFormData({ ...formData, real_estate: e.target.value })}
                            />
                        ) : (
                            <span className="bs-value">{formatCurrency(wealthData.real_estate)}</span>
                        )}
                    </div>

                    <div className="bs-item liability">
                        <div className="bs-label">
                            <CreditCard size={18} className="text-red" />
                            <strong>{t('Total Liabilities (Debt)')}</strong>
                        </div>
                        {editMode ? (
                            <input
                                type="number"
                                value={formData.liabilities}
                                onChange={(e) => setFormData({ ...formData, liabilities: e.target.value })}
                            />
                        ) : (
                            <span className="bs-value text-red">-{formatCurrency(wealthData.liabilities)}</span>
                        )}
                    </div>

                    {editMode && (
                        <button className="btn-primary w-full mt-1em" onClick={handleSaveSnapshot}>
                            {t('Save Snapshot')}
                        </button>
                    )}
                </div>

                {/* Health Ratios & Pie */}
                <div className="card health-ratios-card">
                    <div className="card-header">
                        <h2>{t('Wealth Ratios')}</h2>
                    </div>

                    <div className="ratio-item">
                        <div className="ratio-info">
                            <span className="ratio-title">{t('Emergency Runway')}</span>
                            <span className="ratio-desc">{t('Months you can survive on cash alone')}</span>
                        </div>
                        <div className="ratio-score">
                            {simulation ? simulation.currentRunway.toFixed(1) : (dynamicCash / 1000).toFixed(1) /* fallback */} {t('mos')}
                        </div>
                    </div>

                    <div className="ratio-item">
                        <div className="ratio-info">
                            <span className="ratio-title">{t('Debt Burden')}</span>
                            <span className="ratio-desc">{t('Percentage of total assets owed')}</span>
                        </div>
                        <div className="ratio-score">
                            {netWorth > 0 ? ((Number(wealthData.liabilities) / (netWorth + Number(wealthData.liabilities))) * 100).toFixed(0) : 0}%
                        </div>
                    </div>

                    <div className="chart-container" style={{ height: 200, marginTop: '20px' }}>
                        {assetsData.length > 0 ? (
                            <ResponsiveContainer width="100%" height="100%">
                                <PieChart>
                                    <Pie data={assetsData} cx="50%" cy="50%" innerRadius={60} outerRadius={80} paddingAngle={5} dataKey="value">
                                        {assetsData.map((entry, index) => (
                                            <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                                        ))}
                                    </Pie>
                                    <Tooltip formatter={(value) => formatCurrency(value)} />
                                </PieChart>
                            </ResponsiveContainer>
                        ) : (
                            <div className="empty-state">{t('Not enough data')}</div>
                        )}
                    </div>
                </div>

            </div>

            <div className="dashboard-grid wealth-grid" style={{ marginTop: '30px' }}>

                {/* Blind Spots Detector */}
                <div className="card blind-spots-card">
                    <div className="card-header highlight-red">
                        <Search size={20} />
                        <h2>{t('Blind Spot Detector')}</h2>
                    </div>
                    <p className="help-text" style={{ marginBottom: '15px' }}>
                        {t('Identifying high-frequency micro-expenses and passive subscriptions draining your wealth.')}
                    </p>

                    <h3 className="section-title text-sm">{t('Micro-Expenses (Last 30 Days)')}</h3>
                    <div className="list-group">
                        {blindSpots.smallFrequent.length > 0 ? blindSpots.smallFrequent.map((spot, i) => (
                            <div className="list-item" key={i}>
                                <div>
                                    <strong>{spot.category}</strong>
                                    <span className="sub-text block">{spot.count} {t('transactions')} ({formatCurrency(spot.avg)} {t('avg')})</span>
                                </div>
                                <span className="warning-text">-{formatCurrency(spot.total)}</span>
                            </div>
                        )) : (
                            <div className="empty-state text-sm">{t('No significant micro-leaks found.')}</div>
                        )}
                    </div>

                    <h3 className="section-title text-sm mt-1em">{t('Active Subscriptions')}</h3>
                    <div className="list-group">
                        {blindSpots.subscriptions.length > 0 ? blindSpots.subscriptions.map((sub, i) => (
                            <div className="list-item" key={i}>
                                <div>
                                    <strong>{sub.description}</strong>
                                    <span className="sub-text block">{sub.category}</span>
                                </div>
                                <span className="warning-text">-{formatCurrency(sub.amount)}</span>
                            </div>
                        )) : (
                            <div className="empty-state text-sm">{t('No active subscriptions found.')}</div>
                        )}
                    </div>
                </div>

                {/* Major Purchase Simulator */}
                <div className="card simulator-card">
                    <div className="card-header highlight-blue">
                        <Target size={20} />
                        <h2>{t('Major Purchase Simulator')}</h2>
                    </div>
                    <p className="help-text" style={{ marginBottom: '15px' }}>
                        {t('Test the impact of buying a house or car on your financial safety net.')}
                    </p>

                    <div className="input-group">
                        <label>{t('Simulate Expense Target')}</label>
                        <input
                            type="number"
                            placeholder="e.g. 15000"
                            value={goalTarget}
                            onChange={(e) => setGoalTarget(e.target.value)}
                        />
                    </div>

                    {simulation && (
                        <div className="simulation-results">
                            <div className={`sim-alert ${simulation.affordable ? 'success' : 'danger'}`}>
                                {simulation.affordable
                                    ? t('You can technically afford this in cash.')
                                    : t('Insufficient liquid cash for this purchase.')}
                            </div>

                            <div className="sim-stats">
                                <div className="sim-stat">
                                    <span>{t('Cash Leftover')}</span>
                                    <strong>{formatCurrency(simulation.remainingCash)}</strong>
                                </div>
                                <div className="sim-stat">
                                    <span>{t('New Runway (Survival)')}</span>
                                    <strong className={simulation.newRunway < 3 ? 'text-red' : ''}>
                                        {simulation.newRunway.toFixed(1)} {t('months')} (-{(simulation.currentRunway - simulation.newRunway).toFixed(1)})
                                    </strong>
                                </div>
                                <div className="sim-stat">
                                    <span>{t('Liquidity Wiped')}</span>
                                    <strong>{simulation.pressure.toFixed(1)}%</strong>
                                </div>
                            </div>
                        </div>
                    )}
                </div>

            </div>
        </div>
    );
}
