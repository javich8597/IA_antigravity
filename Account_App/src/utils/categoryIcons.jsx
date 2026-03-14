import {
    Home, Zap, ShoppingCart, Car, Plane, ShoppingBag,
    Film, HeartPulse, GraduationCap, CreditCard,
    PiggyBank, TrendingUp, Landmark, ArrowRightLeft, Circle,
    Coffee, Users, FileText, Wallet
} from 'lucide-react';

export const CATEGORY_HIERARCHY = {
    'Housing': ['Alquiler', 'Hipoteca', 'Comunidad', 'IBI y Tasas', 'Muebles y Decoración', 'Mantenimiento y Obras'],
    'Utilities': ['Luz', 'Agua', 'Gas', 'Internet y Fibra', 'Teléfono Móvil'],
    'Food': ['Supermercado', 'Frutería', 'Carnicería', 'Panadería', 'Mercado'],
    'Transportation': ['Gasolina', 'Mantenimiento y Taller', 'Seguro Vehículo', 'Transporte Público', 'Taxi / VTC', 'Peajes y Parking'],
    'Dining': ['Restaurantes', 'Bares y Pubs', 'Cafetería', 'Comida a Domicilio'],
    'Entertainment': ['Cine y Entradas', 'Suscripciones Digitales', 'Videojuegos', 'Libros y Cultura'],
    'Shopping': ['Ropa y Calzado', 'Electrónica', 'Regalos', 'Caprichos', 'Cuidado Personal'],
    'Healthcare': ['Farmacia', 'Consultas Médicas', 'Seguro Médico', 'Gimnasio', 'Estética y Peluquería', 'Dentista'],
    'Travel': ['Vuelos y Trenes', 'Hoteles y Alojamiento', 'Actividades de Viaje'],
    'Education': ['Matrículas y Tasas', 'Material Escolar', 'Cursos y Másters', 'Clases Particulares'],
    'Family': ['Mascotas', 'Veterinario', 'Gastos Niños', 'Guardería y Colegio'],
    'Finance': ['Comisiones Bancarias', 'Seguros', 'Impuestos', 'Multas', 'Préstamos'],
    'Investments': ['Traspaso a Ahorros', 'Bolsa y Fondos', 'Criptomonedas', 'Plan de Pensiones'],
    'Income': ['Nómina', 'Bizums y Transferencias', 'Intereses', 'Extras y Bonos', 'Devoluciones'],
    'Internal': ['Transferencias entre cuentas', 'Ajustes manuales']
};

export const CATEGORIES = Object.keys(CATEGORY_HIERARCHY);

export const CATEGORY_KEYS = {
    'Housing': 'cat_Housing',
    'Utilities': 'cat_Utilities',
    'Food': 'cat_Food',
    'Transportation': 'cat_Transportation',
    'Dining': 'cat_Dining',
    'Entertainment': 'cat_Entertainment',
    'Shopping': 'cat_Shopping',
    'Healthcare': 'cat_Healthcare',
    'Travel': 'cat_Travel',
    'Education': 'cat_Education',
    'Family': 'cat_Family',
    'Finance': 'cat_Finance',
    'Investments': 'cat_Investments',
    'Income': 'cat_Income',
    'Internal': 'cat_Internal'
};

export const getCategoryConfig = (categoryString) => {
    const rootCategory = categoryString ? categoryString.split(' - ')[0] : 'General';

    switch (rootCategory) {
        case 'Housing': return { icon: Home, color: '#facc15', bg: 'rgba(250, 204, 21, 0.15)' };
        case 'Utilities': return { icon: Zap, color: '#ec4899', bg: 'rgba(236, 72, 153, 0.15)' };
        case 'Food': return { icon: ShoppingCart, color: '#f43f5e', bg: 'rgba(244, 63, 94, 0.15)' };
        case 'Transportation': return { icon: Car, color: '#3b82f6', bg: 'rgba(59, 130, 246, 0.15)' };
        case 'Dining': return { icon: Coffee, color: '#f97316', bg: 'rgba(249, 115, 22, 0.15)' };
        case 'Entertainment': return { icon: Film, color: '#a855f7', bg: 'rgba(168, 85, 247, 0.15)' };
        case 'Shopping': return { icon: ShoppingBag, color: '#d946ef', bg: 'rgba(217, 70, 239, 0.15)' };
        case 'Healthcare': return { icon: HeartPulse, color: '#10b981', bg: 'rgba(16, 185, 129, 0.15)' };
        case 'Travel': return { icon: Plane, color: '#0ea5e9', bg: 'rgba(14, 165, 233, 0.15)' };
        case 'Education': return { icon: GraduationCap, color: '#6366f1', bg: 'rgba(99, 102, 241, 0.15)' };
        case 'Family': return { icon: Users, color: '#f472b6', bg: 'rgba(244, 114, 182, 0.15)' };
        case 'Finance': return { icon: FileText, color: '#ef4444', bg: 'rgba(239, 68, 68, 0.15)' };
        case 'Investments': return { icon: TrendingUp, color: '#14b8a6', bg: 'rgba(20, 184, 166, 0.15)' };
        case 'Income': return { icon: Wallet, color: '#22c55e', bg: 'rgba(34, 197, 94, 0.15)' };
        case 'Internal': return { icon: ArrowRightLeft, color: '#94a3b8', bg: 'rgba(148, 163, 184, 0.15)' };
        case 'General':
        default:
            return { icon: Circle, color: '#94a3b8', bg: 'rgba(148, 163, 184, 0.15)' };
    }
};
