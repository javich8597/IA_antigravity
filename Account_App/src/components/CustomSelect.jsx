import { useState, useRef, useEffect } from 'react';
import { ChevronDown, Check } from 'lucide-react';

/**
 * CustomSelect — a fully styled replacement for native <select> elements.
 * Supports: dark/light mode, keyboard navigation, animated dropdown panel.
 *
 * Props:
 *   value       — current selected value (string)
 *   onChange    — callback(newValue: string)
 *   options     — Array of string | { value, label }
 *   placeholder — optional placeholder text
 *   id          — optional id attribute for accessibility
 */
export default function CustomSelect({ value, onChange, options = [], placeholder = 'Select...', id }) {
    const [open, setOpen] = useState(false);
    const containerRef = useRef(null);

    // Normalise options to { value, label } objects
    const normalised = options.map(o =>
        typeof o === 'string' ? { value: o, label: o } : o
    );

    const selected = normalised.find(o => o.value === value);

    // Close on outside click
    useEffect(() => {
        const handler = (e) => {
            if (containerRef.current && !containerRef.current.contains(e.target)) {
                setOpen(false);
            }
        };
        document.addEventListener('mousedown', handler);
        return () => document.removeEventListener('mousedown', handler);
    }, []);

    const pick = (val) => {
        onChange(val);
        setOpen(false);
    };

    return (
        <div ref={containerRef} style={{ position: 'relative', width: '100%' }} id={id}>
            {/* Trigger button */}
            <button
                type="button"
                onClick={() => setOpen(prev => !prev)}
                style={{
                    width: '100%',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    padding: '0.75rem 1rem',
                    background: 'rgba(0, 0, 0, 0.2)',
                    border: `1px solid ${open ? 'var(--accent-color)' : 'var(--card-border)'}`,
                    borderRadius: '12px',
                    color: selected ? 'var(--text-main)' : 'var(--text-muted)',
                    fontSize: '1rem',
                    fontFamily: 'inherit',
                    cursor: 'pointer',
                    transition: 'all 0.2s cubic-bezier(0.4, 0, 0.2, 1)',
                    boxShadow: open ? '0 0 0 2px rgba(99, 102, 241, 0.25)' : 'none',
                }}
            >
                <span style={{ truncate: 'ellipsis', overflow: 'hidden', whiteSpace: 'nowrap' }}>
                    {selected ? selected.label : placeholder}
                </span>
                <ChevronDown
                    size={16}
                    color="var(--text-muted)"
                    style={{
                        flexShrink: 0,
                        marginLeft: '0.5rem',
                        transition: 'transform 0.25s ease',
                        transform: open ? 'rotate(180deg)' : 'rotate(0deg)'
                    }}
                />
            </button>

            {/* Dropdown panel */}
            {open && (
                <div
                    style={{
                        position: 'absolute',
                        top: 'calc(100% + 6px)',
                        left: 0,
                        right: 0,
                        zIndex: 9000,
                        background: 'rgba(15, 23, 42, 0.97)',
                        backdropFilter: 'blur(16px)',
                        WebkitBackdropFilter: 'blur(16px)',
                        border: '1px solid rgba(99, 102, 241, 0.35)',
                        borderRadius: '12px',
                        boxShadow: '0 8px 32px rgba(0, 0, 0, 0.45), 0 0 0 1px rgba(99,102,241,0.12)',
                        overflow: 'hidden',
                        animation: 'fadeIn 0.15s ease-out',
                        maxHeight: '280px',
                        overflowY: 'auto',
                    }}
                >
                    {normalised.map((opt) => {
                        const isActive = opt.value === value;
                        return (
                            <button
                                key={opt.value}
                                type="button"
                                onClick={() => pick(opt.value)}
                                style={{
                                    width: '100%',
                                    display: 'flex',
                                    alignItems: 'center',
                                    justifyContent: 'space-between',
                                    padding: '0.65rem 1rem',
                                    background: isActive
                                        ? 'rgba(99, 102, 241, 0.18)'
                                        : 'transparent',
                                    border: 'none',
                                    borderBottom: '1px solid rgba(255,255,255,0.04)',
                                    color: isActive ? '#a5b4fc' : '#e2e8f0',
                                    fontSize: '0.95rem',
                                    fontFamily: 'inherit',
                                    cursor: 'pointer',
                                    textAlign: 'left',
                                    transition: 'background 0.15s',
                                }}
                                onMouseEnter={e => {
                                    if (!isActive) e.currentTarget.style.background = 'rgba(255,255,255,0.06)';
                                }}
                                onMouseLeave={e => {
                                    if (!isActive) e.currentTarget.style.background = 'transparent';
                                }}
                            >
                                {opt.label}
                                {isActive && <Check size={14} color="#818cf8" style={{ flexShrink: 0 }} />}
                            </button>
                        );
                    })}
                </div>
            )}
        </div>
    );
}
