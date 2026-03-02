import { X } from 'lucide-react';
import { useFinance } from '../context/FinanceContext';

export default function SettingsModal({ isOpen, onClose }) {
    const { currency, setCurrency, language, setLanguage, t } = useFinance();

    if (!isOpen) return null;

    return (
        <div className="modal-overlay" style={overlayStyle}>
            <div className="modal-content glass-panel animate-fade-in" style={contentStyle}>
                <div className="modal-header" style={headerStyle}>
                    <h2>{t('appSettings')}</h2>
                    <button onClick={onClose} style={closeBtnStyle}>
                        <X size={24} />
                    </button>
                </div>

                <div className="modal-body" style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem', marginTop: '1.5rem' }}>

                    <div className="form-group">
                        <label>{t('language')}</label>
                        <select
                            className="form-input"
                            value={language}
                            onChange={(e) => setLanguage(e.target.value)}
                        >
                            <option value="en">English</option>
                            <option value="es">Español</option>
                        </select>
                    </div>

                    <div className="form-group">
                        <label>{t('currency')}</label>
                        <select
                            className="form-input"
                            value={currency}
                            onChange={(e) => setCurrency(e.target.value)}
                        >
                            <option value="USD">USD ($)</option>
                            <option value="EUR">EUR (€)</option>
                            <option value="GBP">GBP (£)</option>
                            <option value="JPY">JPY (¥)</option>
                        </select>
                    </div>

                </div>

                <div className="modal-footer" style={{ marginTop: '2rem', display: 'flex', justifyContent: 'flex-end' }}>
                    <button onClick={onClose} className="submit-btn btn-success" style={{ width: 'auto', padding: '0.5rem 1.5rem' }}>
                        {t('close')}
                    </button>
                </div>
            </div>
        </div>
    );
}

// Inline styles for Modal structure (to keep it isolated and simple)
const overlayStyle = {
    position: 'fixed',
    top: 0, left: 0, right: 0, bottom: 0,
    backgroundColor: 'rgba(0,0,0,0.5)',
    zIndex: 1000,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center'
};

const contentStyle = {
    width: '90%',
    maxWidth: '450px',
    padding: '2rem',
    position: 'relative'
};

const headerStyle = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    borderBottom: '1px solid var(--card-border)',
    paddingBottom: '1rem'
};

const closeBtnStyle = {
    background: 'transparent',
    border: 'none',
    color: 'var(--text-muted)',
    cursor: 'pointer'
};
