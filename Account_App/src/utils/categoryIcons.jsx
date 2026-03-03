import {
    Home, Zap, ShoppingCart, Car, Plane, ShoppingBag,
    Film, HeartPulse, GraduationCap, CreditCard,
    PiggyBank, TrendingUp, Landmark, ArrowRightLeft, Circle
} from 'lucide-react';

export const CATEGORY_HIERARCHY = {
    'Housing': ['Alquiler', 'Hipoteca', 'Comunidad', 'Mantenimiento y Reparaciones', 'Reformas', 'Seguro del Hogar', 'IBI y Tasas'],
    'Utilities': ['Electricidad', 'Gas', 'Agua', 'Internet', 'Telefonía móvil', 'Plataformas TV', 'Otros suministros'],
    'Food': ['Supermercado', 'Restaurantes', 'Comida a domicilio', 'Cafeterías', 'Snacks'],
    'Transportation': ['Combustible', 'Transporte público', 'Taxi / VTC', 'Parking', 'Peajes', 'Mantenimiento vehículo', 'Seguro vehículo', 'ITV', 'Impuesto circulación'],
    'Travel': ['Vuelos', 'Trenes / Autobuses', 'Alojamiento', 'Actividades', 'Seguro de viaje', 'Transporte en destino'],
    'Shopping': ['Ropa y calzado', 'Electrónica', 'Hogar y decoración', 'Regalos', 'Accesorios'],
    'Entertainment': ['Suscripciones digitales', 'Cine / Teatro / Conciertos', 'Eventos', 'Videojuegos', 'Vida nocturna', 'Hobbies'],
    'Healthcare': ['Farmacia', 'Consultas médicas', 'Seguro médico', 'Dentista', 'Gimnasio', 'Estética / Peluquería'],
    'Education': ['Matrículas', 'Cursos', 'Libros y material', 'Formación online', 'Idiomas'],
    'Finance': ['Préstamos personales', 'Cuota coche', 'Tarjeta de crédito', 'Intereses', 'Comisiones bancarias', 'Impuestos', 'Asesoría / Gestoría'],
    'Savings': ['Fondo de emergencia', 'Cuenta ahorro', 'Plan de pensiones', 'Ahorro para objetivos'],
    'Investments': ['Bolsa / ETFs', 'Dividendos', 'Criptomonedas', 'Inversión inmobiliaria', 'Crowdfunding', 'Compra de deuda (NPL)'],
    'Income': ['Salario fijo', 'Bonus', 'Ingresos freelance', 'Ingresos por alquiler', 'Dividendos recibidos', 'Venta de activos', 'Devoluciones'],
    'Internal': ['Transferencias entre cuentas', 'Traspasos ahorro', 'Ajustes manuales']
};

export const CATEGORIES = Object.keys(CATEGORY_HIERARCHY);

export const CATEGORY_KEYS = {
    'Housing': 'cat_Housing',
    'Utilities': 'cat_Utilities',
    'Food': 'cat_Food',
    'Transportation': 'cat_Transportation',
    'Travel': 'cat_Travel',
    'Shopping': 'cat_Shopping',
    'Entertainment': 'cat_Entertainment',
    'Healthcare': 'cat_Healthcare',
    'Education': 'cat_Education',
    'Finance': 'cat_Finance',
    'Savings': 'cat_Savings',
    'Investments': 'cat_Investments',
    'Income': 'cat_Salary',
    'Internal': 'cat_Internal'
};

export const getCategoryConfig = (categoryString) => {
    // If category string is "Housing - Alquiler", extract just "Housing"
    const rootCategory = categoryString ? categoryString.split(' - ')[0] : 'General';

    switch (rootCategory) {
        case 'Housing':
            return { icon: Home, color: '#facc15', bg: 'rgba(250, 204, 21, 0.15)' };
        case 'Utilities':
            return { icon: Zap, color: '#ec4899', bg: 'rgba(236, 72, 153, 0.15)' };
        case 'Food':
            return { icon: ShoppingCart, color: '#f43f5e', bg: 'rgba(244, 63, 94, 0.15)' };
        case 'Transportation':
            return { icon: Car, color: '#3b82f6', bg: 'rgba(59, 130, 246, 0.15)' };
        case 'Travel':
            return { icon: Plane, color: '#0ea5e9', bg: 'rgba(14, 165, 233, 0.15)' };
        case 'Shopping':
            return { icon: ShoppingBag, color: '#f97316', bg: 'rgba(249, 115, 22, 0.15)' };
        case 'Entertainment':
            return { icon: Film, color: '#a855f7', bg: 'rgba(168, 85, 247, 0.15)' };
        case 'Healthcare':
            return { icon: HeartPulse, color: '#10b981', bg: 'rgba(16, 185, 129, 0.15)' };
        case 'Education':
            return { icon: GraduationCap, color: '#6366f1', bg: 'rgba(99, 102, 241, 0.15)' };
        case 'Finance':
            return { icon: CreditCard, color: '#ef4444', bg: 'rgba(239, 68, 68, 0.15)' };
        case 'Savings':
            return { icon: PiggyBank, color: '#8b5cf6', bg: 'rgba(139, 92, 246, 0.15)' };
        case 'Investments':
            return { icon: TrendingUp, color: '#14b8a6', bg: 'rgba(20, 184, 166, 0.15)' };
        case 'Income':
            return { icon: Landmark, color: '#10b981', bg: 'rgba(16, 185, 129, 0.15)' };
        case 'Internal':
            return { icon: ArrowRightLeft, color: '#94a3b8', bg: 'rgba(148, 163, 184, 0.15)' };
        case 'General':
        default:
            return { icon: Circle, color: '#94a3b8', bg: 'rgba(148, 163, 184, 0.15)' };
    }
};
