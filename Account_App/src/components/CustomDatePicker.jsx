import { useState, useRef, useEffect } from 'react';
import { createPortal } from 'react-dom';
import { ChevronLeft, ChevronRight, CalendarDays } from 'lucide-react';

const DAYS = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];
const MONTHS = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
];

/**
 * CustomDatePicker — a fully styled glassmorphism popover calendar.
 *
 * Props:
 *   value     — current date string in YYYY-MM-DD format
 *   onChange  — callback(dateString: string)
 *   id        — optional id attribute
 */
export default function CustomDatePicker({ value, onChange, id }) {
    const [open, setOpen] = useState(false);
    const [viewDate, setViewDate] = useState(() => value ? new Date(value + 'T12:00:00') : new Date());
    const triggerRef = useRef(null);
    const popupRef = useRef(null);
    const [position, setPosition] = useState({ top: 0, left: 0, width: 0 });

    // Parse the current selected date
    const selected = value ? new Date(value + 'T12:00:00') : null;

    const formatDisplay = (date) => {
        if (!date) return 'Select date';
        return date.toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' });
    };

    // Position the popup relative to the trigger button
    const updatePosition = () => {
        if (triggerRef.current) {
            const rect = triggerRef.current.getBoundingClientRect();
            setPosition({
                top: rect.bottom + window.scrollY + 6,
                left: rect.left + window.scrollX,
                width: rect.width
            });
        }
    };

    const openPicker = () => {
        updatePosition();
        setOpen(true);
    };

    // Close on outside click
    useEffect(() => {
        if (!open) return;
        const handler = (e) => {
            if (
                popupRef.current && !popupRef.current.contains(e.target) &&
                triggerRef.current && !triggerRef.current.contains(e.target)
            ) {
                setOpen(false);
            }
        };
        document.addEventListener('mousedown', handler);
        return () => document.removeEventListener('mousedown', handler);
    }, [open]);

    // Build calendar days for the current viewDate month
    const year = viewDate.getFullYear();
    const month = viewDate.getMonth();
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const cells = [];
    for (let i = 0; i < firstDay; i++) cells.push(null);
    for (let d = 1; d <= daysInMonth; d++) cells.push(d);

    const prevMonth = () => setViewDate(new Date(year, month - 1, 1));
    const nextMonth = () => setViewDate(new Date(year, month + 1, 1));

    const pickDay = (day) => {
        const mm = String(month + 1).padStart(2, '0');
        const dd = String(day).padStart(2, '0');
        onChange(`${year}-${mm}-${dd}`);
        setOpen(false);
    };

    const isSelected = (day) => {
        if (!selected) return false;
        return selected.getFullYear() === year && selected.getMonth() === month && selected.getDate() === day;
    };

    const isToday = (day) => {
        const d = new Date(year, month, day);
        d.setHours(0, 0, 0, 0);
        return d.getTime() === today.getTime();
    };

    return (
        <>
            {/* Trigger button */}
            <button
                ref={triggerRef}
                id={id}
                type="button"
                onClick={openPicker}
                style={{
                    width: '100%',
                    display: 'flex',
                    alignItems: 'center',
                    gap: '0.6rem',
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
                    textAlign: 'left'
                }}
            >
                <CalendarDays size={16} color="var(--text-muted)" style={{ flexShrink: 0 }} />
                <span>{formatDisplay(selected)}</span>
            </button>

            {/* Calendar popup via Portal */}
            {open && createPortal(
                <div
                    ref={popupRef}
                    style={{
                        position: 'absolute',
                        top: `${position.top}px`,
                        left: `${position.left}px`,
                        width: `${Math.max(position.width, 280)}px`,
                        zIndex: 9100,
                        background: 'rgba(15, 23, 42, 0.97)',
                        backdropFilter: 'blur(16px)',
                        WebkitBackdropFilter: 'blur(16px)',
                        border: '1px solid rgba(99, 102, 241, 0.35)',
                        borderRadius: '14px',
                        boxShadow: '0 8px 32px rgba(0, 0, 0, 0.5), 0 0 0 1px rgba(99,102,241,0.12)',
                        padding: '1rem',
                        animation: 'fadeIn 0.15s ease-out',
                        userSelect: 'none'
                    }}
                >
                    {/* Month navigation */}
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '0.85rem' }}>
                        <button
                            type="button"
                            onClick={prevMonth}
                            style={navBtnStyle}
                            onMouseEnter={e => e.currentTarget.style.background = 'rgba(255,255,255,0.1)'}
                            onMouseLeave={e => e.currentTarget.style.background = 'transparent'}
                        >
                            <ChevronLeft size={16} />
                        </button>

                        <span style={{ fontWeight: 600, fontSize: '0.95rem', color: '#e2e8f0' }}>
                            {MONTHS[month]} {year}
                        </span>

                        <button
                            type="button"
                            onClick={nextMonth}
                            style={navBtnStyle}
                            onMouseEnter={e => e.currentTarget.style.background = 'rgba(255,255,255,0.1)'}
                            onMouseLeave={e => e.currentTarget.style.background = 'transparent'}
                        >
                            <ChevronRight size={16} />
                        </button>
                    </div>

                    {/* Day-of-week headers */}
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: '2px', marginBottom: '4px' }}>
                        {DAYS.map(d => (
                            <div key={d} style={{ textAlign: 'center', fontSize: '0.72rem', fontWeight: 600, color: '#64748b', padding: '4px 0' }}>
                                {d}
                            </div>
                        ))}
                    </div>

                    {/* Calendar grid */}
                    <div style={{ display: 'grid', gridTemplateColumns: 'repeat(7, 1fr)', gap: '2px' }}>
                        {cells.map((day, i) => {
                            if (!day) return <div key={`e-${i}`} />;

                            const sel = isSelected(day);
                            const tod = isToday(day);

                            return (
                                <button
                                    key={day}
                                    type="button"
                                    onClick={() => pickDay(day)}
                                    style={{
                                        width: '100%',
                                        aspectRatio: '1',
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                        border: tod && !sel ? '1px solid rgba(99,102,241,0.5)' : '1px solid transparent',
                                        borderRadius: '8px',
                                        background: sel
                                            ? 'linear-gradient(135deg, #6366f1, #a855f7)'
                                            : 'transparent',
                                        color: sel ? 'white' : tod ? '#a5b4fc' : '#e2e8f0',
                                        fontSize: '0.85rem',
                                        fontWeight: sel || tod ? 600 : 400,
                                        cursor: 'pointer',
                                        transition: 'all 0.12s ease',
                                        boxShadow: sel ? '0 2px 8px rgba(99,102,241,0.4)' : 'none'
                                    }}
                                    onMouseEnter={e => {
                                        if (!sel) e.currentTarget.style.background = 'rgba(99,102,241,0.2)';
                                    }}
                                    onMouseLeave={e => {
                                        if (!sel) e.currentTarget.style.background = 'transparent';
                                    }}
                                >
                                    {day}
                                </button>
                            );
                        })}
                    </div>

                    {/* Today shortcut */}
                    <div style={{ marginTop: '0.75rem', display: 'flex', justifyContent: 'center' }}>
                        <button
                            type="button"
                            onClick={() => {
                                const t = new Date();
                                pickDay(t.getDate());
                                setViewDate(new Date(t.getFullYear(), t.getMonth(), 1));
                            }}
                            style={{
                                background: 'rgba(99,102,241,0.12)',
                                border: '1px solid rgba(99,102,241,0.3)',
                                borderRadius: '6px',
                                color: '#a5b4fc',
                                fontSize: '0.8rem',
                                fontFamily: 'inherit',
                                padding: '0.3rem 1rem',
                                cursor: 'pointer',
                                transition: 'all 0.15s'
                            }}
                            onMouseEnter={e => e.currentTarget.style.background = 'rgba(99,102,241,0.25)'}
                            onMouseLeave={e => e.currentTarget.style.background = 'rgba(99,102,241,0.12)'}
                        >
                            Today
                        </button>
                    </div>
                </div>,
                document.body
            )}
        </>
    );
}

const navBtnStyle = {
    background: 'transparent',
    border: 'none',
    color: '#94a3b8',
    cursor: 'pointer',
    borderRadius: '6px',
    padding: '4px 6px',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    transition: 'background 0.15s'
};
