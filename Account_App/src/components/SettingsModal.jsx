import { X } from 'lucide-react';
import { createPortal } from 'react-dom';
import { useFinance } from '../context/FinanceContext';
import CustomSelect from './CustomSelect';

export default function SettingsModal({ isOpen, onClose }) {
    const { currency, setCurrency, language, setLanguage, t } = useFinance();

    if (!isOpen) return null;

    // React Portal: Renders the modal directly into document.body,
    // completely escaping the <nav> stacking context that was causing the z-index overlap.
    return createPortal(
        <div style={overlayStyle} onClick={onClose}>
            <div style={contentStyle} className="glass-panel animate-fade-in" onClick={e => e.stopPropagation()}>
                <div style={headerStyle}>
                    <h2 style={{ margin: 0, fontSize: '1.25rem', fontWeight: 600 }}>{t('appSettings')}</h2>
                    <button onClick={onClose} style={closeBtnStyle}>
                        <X size={24} />
                    </button>
                </div>

                <div style={{ display: 'flex', flexDirection: 'column', gap: '1.5rem', marginTop: '1.5rem' }}>

                    <div className="form-group" style={{ marginBottom: 0 }}>
                        <label>{t('language')}</label>
                        <CustomSelect
                            value={language}
                            onChange={setLanguage}
                            options={[
                                { value: 'en', label: 'English' },
                                { value: 'es', label: 'Español' }
                            ]}
                        />
                    </div>

                    <div className="form-group" style={{ marginBottom: 0 }}>
                        <label>{t('currency')}</label>
                        <CustomSelect
                            value={currency}
                            onChange={setCurrency}
                            options={[
                                { value: 'USD', label: 'USD ($)' },
                                { value: 'EUR', label: 'EUR (€)' },
                                { value: 'GBP', label: 'GBP (£)' },
                                { value: 'JPY', label: 'JPY (¥)' }
                            ]}
                        />
                    </div>

                </div>

                <div style={{ marginTop: '2rem', display: 'flex', justifyContent: 'flex-end' }}>
                    <button onClick={onClose} className="submit-btn btn-success" style={{ width: 'auto', padding: '0.5rem 1.5rem' }}>
                        {t('close')}
                    </button>
                </div>
            </div>
        </div>,
        document.body
    );
}

const overlayStyle = {
    position: 'fixed',
    inset: 0,
    backgroundColor: 'rgba(0, 0, 0, 0.65)',
    zIndex: 9999,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
};

const contentStyle = {
    width: '90%',
    maxWidth: '450px',
    padding: '2rem',
    position: 'relative',
};

const headerStyle = {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    borderBottom: '1px solid var(--card-border)',
    paddingBottom: '1rem',
};

const closeBtnStyle = {
    background: 'transparent',
    border: 'none',
    color: 'var(--text-muted)',
    cursor: 'pointer',
    display: 'flex',
    alignItems: 'center',
};
