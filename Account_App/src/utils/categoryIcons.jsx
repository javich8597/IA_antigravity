import {
    Home,
    Zap,
    ShoppingCart,
    Plane,
    Film,
    HeartPulse,
    Landmark,
    Circle,
    Briefcase
} from 'lucide-react';

export const CATEGORIES = [
    'Housing',
    'Utilities',
    'Food & Groceries',
    'Transportation & Travel',
    'Entertainment',
    'Healthcare',
    'Salary / Income',
    'General'
];

export const getCategoryConfig = (category) => {
    switch (category) {
        case 'Housing':
            return { icon: Home, color: '#facc15', bg: 'rgba(250, 204, 21, 0.15)' }; // Yellow
        case 'Utilities':
            return { icon: Zap, color: '#ec4899', bg: 'rgba(236, 72, 153, 0.15)' }; // Pink
        case 'Food & Groceries':
            return { icon: ShoppingCart, color: '#f43f5e', bg: 'rgba(244, 63, 94, 0.15)' }; // Rose
        case 'Transportation & Travel':
            return { icon: Plane, color: '#3b82f6', bg: 'rgba(59, 130, 246, 0.15)' }; // Blue
        case 'Entertainment':
            return { icon: Film, color: '#a855f7', bg: 'rgba(168, 85, 247, 0.15)' }; // Purple
        case 'Healthcare':
            return { icon: HeartPulse, color: '#10b981', bg: 'rgba(16, 185, 129, 0.15)' }; // Emerald
        case 'Salary / Income':
            return { icon: Landmark, color: '#10b981', bg: 'rgba(16, 185, 129, 0.15)' }; // Emerald (Success)
        case 'General':
        default:
            return { icon: Circle, color: '#94a3b8', bg: 'rgba(148, 163, 184, 0.15)' }; // Slate
    }
};
