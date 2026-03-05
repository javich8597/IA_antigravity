import { CATEGORIES } from './categoryIcons';

/**
 * Keyword mapping rules for automatic categorization.
 * Maps raw lowercase keywords (in Spanish and English) to standard Categories and Subcategories.
 */
const KEYWORD_MAP = {
    // Housing
    'alquiler': { category: 'Housing', subcategory: 'Alquiler' },
    'hipoteca': { category: 'Housing', subcategory: 'Hipoteca' },
    'rent': { category: 'Housing', subcategory: 'Alquiler' },
    'comunidad': { category: 'Housing', subcategory: 'Comunidad' },
    'seguro hogar': { category: 'Housing', subcategory: 'Seguro del Hogar' },
    'ibi': { category: 'Housing', subcategory: 'IBI y Tasas' },
    'leroy merlin': { category: 'Housing', subcategory: 'Mantenimiento y Reparaciones' },
    'bricomart': { category: 'Housing', subcategory: 'Mantenimiento y Reparaciones' },
    'fontanero': { category: 'Housing', subcategory: 'Mantenimiento y Reparaciones' },
    'muebles': { category: 'Housing', subcategory: 'Mantenimiento y Reparaciones' },

    // Utilities
    'luz': { category: 'Utilities', subcategory: 'Electricidad' },
    'iberdrola': { category: 'Utilities', subcategory: 'Electricidad' },
    'endesa': { category: 'Utilities', subcategory: 'Electricidad' },
    'energia': { category: 'Utilities', subcategory: 'Electricidad' },
    'agua': { category: 'Utilities', subcategory: 'Agua' },
    'gas': { category: 'Utilities', subcategory: 'Gas' },
    'internet': { category: 'Utilities', subcategory: 'Internet' },
    'wifi': { category: 'Utilities', subcategory: 'Internet' },
    'movistar': { category: 'Utilities', subcategory: 'Telefonía móvil' },
    'vodafone': { category: 'Utilities', subcategory: 'Telefonía móvil' },
    'digi': { category: 'Utilities', subcategory: 'Telefonía móvil' },
    'orange': { category: 'Utilities', subcategory: 'Telefonía móvil' },
    'yoigo': { category: 'Utilities', subcategory: 'Telefonía móvil' },
    'o2': { category: 'Utilities', subcategory: 'Telefonía móvil' },

    // Food
    'mercadona': { category: 'Food', subcategory: 'Supermercado' },
    'carrefour': { category: 'Food', subcategory: 'Supermercado' },
    'lidl': { category: 'Food', subcategory: 'Supermercado' },
    'aldi': { category: 'Food', subcategory: 'Supermercado' },
    'consum': { category: 'Food', subcategory: 'Supermercado' },
    'supermercado': { category: 'Food', subcategory: 'Supermercado' },
    'fruteria': { category: 'Food', subcategory: 'Supermercado' },
    'carniceria': { category: 'Food', subcategory: 'Supermercado' },
    'panaderia': { category: 'Food', subcategory: 'Supermercado' },
    'restaurante': { category: 'Food', subcategory: 'Restaurantes' },
    'cena': { category: 'Food', subcategory: 'Restaurantes' },
    'burger': { category: 'Food', subcategory: 'Restaurantes' },
    'mcdonalds': { category: 'Food', subcategory: 'Restaurantes' },
    'kfc': { category: 'Food', subcategory: 'Restaurantes' },
    'sushi': { category: 'Food', subcategory: 'Restaurantes' },
    'glovo': { category: 'Food', subcategory: 'Comida a domicilio' },
    'uber eats': { category: 'Food', subcategory: 'Comida a domicilio' },
    'just eat': { category: 'Food', subcategory: 'Comida a domicilio' },
    'cafeteria': { category: 'Food', subcategory: 'Cafeterías' },
    'cafe': { category: 'Food', subcategory: 'Cafeterías' },

    // Transportation
    'gasolina': { category: 'Transportation', subcategory: 'Combustible' },
    'gasolinera': { category: 'Transportation', subcategory: 'Combustible' },
    'combustible': { category: 'Transportation', subcategory: 'Combustible' },
    'estacion de servicio': { category: 'Transportation', subcategory: 'Combustible' },
    'repsol': { category: 'Transportation', subcategory: 'Combustible' },
    'cepsa': { category: 'Transportation', subcategory: 'Combustible' },
    'bp': { category: 'Transportation', subcategory: 'Combustible' },
    'galp': { category: 'Transportation', subcategory: 'Combustible' },
    'shell': { category: 'Transportation', subcategory: 'Combustible' },
    'bus': { category: 'Transportation', subcategory: 'Transporte público' },
    'autobus': { category: 'Transportation', subcategory: 'Transporte público' },
    'metro': { category: 'Transportation', subcategory: 'Transporte público' },
    'uber': { category: 'Transportation', subcategory: 'Taxi / VTC' },
    'cabify': { category: 'Transportation', subcategory: 'Taxi / VTC' },
    'taxi': { category: 'Transportation', subcategory: 'Taxi / VTC' },
    'parking': { category: 'Transportation', subcategory: 'Parking' },
    'parquimetro': { category: 'Transportation', subcategory: 'Parking' },
    'peaje': { category: 'Transportation', subcategory: 'Peajes' },
    'taller': { category: 'Transportation', subcategory: 'Mantenimiento vehículo' },
    'itv': { category: 'Transportation', subcategory: 'ITV' },

    // Travel
    'vuelo': { category: 'Travel', subcategory: 'Vuelos' },
    'ryanair': { category: 'Travel', subcategory: 'Vuelos' },
    'iberia': { category: 'Travel', subcategory: 'Vuelos' },
    'vueling': { category: 'Travel', subcategory: 'Vuelos' },
    'renfe': { category: 'Travel', subcategory: 'Trenes / Autobuses' },
    'ave': { category: 'Travel', subcategory: 'Trenes / Autobuses' },
    'hotel': { category: 'Travel', subcategory: 'Alojamiento' },
    'airbnb': { category: 'Travel', subcategory: 'Alojamiento' },

    // Shopping
    'ropa': { category: 'Shopping', subcategory: 'Ropa y calzado' },
    'zara': { category: 'Shopping', subcategory: 'Ropa y calzado' },
    'primark': { category: 'Shopping', subcategory: 'Ropa y calzado' },
    'zapatillas': { category: 'Shopping', subcategory: 'Ropa y calzado' },
    'mango': { category: 'Shopping', subcategory: 'Ropa y calzado' },
    'amazon': { category: 'Shopping', subcategory: 'Electrónica' },
    'mediamarkt': { category: 'Shopping', subcategory: 'Electrónica' },
    'apple': { category: 'Shopping', subcategory: 'Electrónica' },
    'ikea': { category: 'Shopping', subcategory: 'Hogar y decoración' },
    'regalo': { category: 'Shopping', subcategory: 'Regalos' },

    // Entertainment
    'netflix': { category: 'Entertainment', subcategory: 'Suscripciones digitales' },
    'spotify': { category: 'Entertainment', subcategory: 'Suscripciones digitales' },
    'hbo': { category: 'Entertainment', subcategory: 'Suscripciones digitales' },
    'prime video': { category: 'Entertainment', subcategory: 'Suscripciones digitales' },
    'cine': { category: 'Entertainment', subcategory: 'Cine / Teatro / Conciertos' },
    'concierto': { category: 'Entertainment', subcategory: 'Cine / Teatro / Conciertos' },
    'juego': { category: 'Entertainment', subcategory: 'Videojuegos' },
    'steam': { category: 'Entertainment', subcategory: 'Videojuegos' },
    'playstation': { category: 'Entertainment', subcategory: 'Videojuegos' },
    'nintendo': { category: 'Entertainment', subcategory: 'Videojuegos' },
    'discoteca': { category: 'Entertainment', subcategory: 'Vida nocturna' },
    'pub': { category: 'Entertainment', subcategory: 'Vida nocturna' },
    'copas': { category: 'Entertainment', subcategory: 'Vida nocturna' },
    'cervezas': { category: 'Entertainment', subcategory: 'Vida nocturna' },

    // Healthcare & P.C.
    'farmacia': { category: 'Healthcare', subcategory: 'Farmacia' },
    'medico': { category: 'Healthcare', subcategory: 'Consultas médicas' },
    'sanitas': { category: 'Healthcare', subcategory: 'Seguro médico' },
    'adeslas': { category: 'Healthcare', subcategory: 'Seguro médico' },
    'dentista': { category: 'Healthcare', subcategory: 'Dentista' },
    'gimnasio': { category: 'Healthcare', subcategory: 'Gimnasio' },
    'gym': { category: 'Healthcare', subcategory: 'Gimnasio' },
    'peluqueria': { category: 'Healthcare', subcategory: 'Estética / Peluquería' },

    // Education
    'universidad': { category: 'Education', subcategory: 'Matrículas' },
    'curso': { category: 'Education', subcategory: 'Cursos' },
    'libro': { category: 'Education', subcategory: 'Libros y material' },
    'ingles': { category: 'Education', subcategory: 'Idiomas' },

    // Finance & Debt
    'prestamo': { category: 'Finance', subcategory: 'Préstamos personales' },
    'tarjeta': { category: 'Finance', subcategory: 'Tarjeta de crédito' },
    'comision': { category: 'Finance', subcategory: 'Comisiones bancarias' },
    'mantenimiento': { category: 'Finance', subcategory: 'Comisiones bancarias' },
    'impuesto': { category: 'Finance', subcategory: 'Impuestos' },
    'gestoria': { category: 'Finance', subcategory: 'Asesoría / Gestoría' },

    // Savings
    'ahorro': { category: 'Savings', subcategory: 'Cuenta ahorro' },

    // Investments
    'bolsa': { category: 'Investments', subcategory: 'Bolsa / ETFs' },
    'ticker': { category: 'Investments', subcategory: 'Bolsa / ETFs' },
    'cripto': { category: 'Investments', subcategory: 'Criptomonedas' },
    'bitcoin': { category: 'Investments', subcategory: 'Criptomonedas' },
    'binance': { category: 'Investments', subcategory: 'Criptomonedas' },
    'coinbase': { category: 'Investments', subcategory: 'Criptomonedas' },

    // Income
    'nomina': { category: 'Income', subcategory: 'Salario fijo' },
    'salario': { category: 'Income', subcategory: 'Salario fijo' },
    'sueldo': { category: 'Income', subcategory: 'Salario fijo' },
    'bonus': { category: 'Income', subcategory: 'Bonus' },
    'paga': { category: 'Income', subcategory: 'Bonus' },
    'venta': { category: 'Income', subcategory: 'Venta de activos' },
    'wallapop': { category: 'Income', subcategory: 'Venta de activos' },
    'vinted': { category: 'Income', subcategory: 'Venta de activos' },
    'devolucion': { category: 'Income', subcategory: 'Devoluciones' },

    // Internal
    'bizum': { category: 'Internal', subcategory: 'Transferencias entre cuentas' },
    'transferencia': { category: 'Internal', subcategory: 'Transferencias entre cuentas' }
};

/**
 * Removes diacritics / accents from a string
 */
function normalizeText(str) {
    if (!str) return '';
    return str
        .toLowerCase()
        .normalize("NFD")
        .replace(/[\u0300-\u036f]/g, ""); // Strips accents
}

function escapeRegExp(string) {
    return string.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// Compute keyword list once. We sort descending by length so "seguro hogar" is tested before "seguro"
const SORTED_KEYWORDS = Object.entries(KEYWORD_MAP)
    .map(([rawKey, result]) => {
        return {
            key: normalizeText(rawKey),
            result
        };
    })
    .sort((a, b) => b.key.length - a.key.length);

/**
 * Predicts the category and subcategory based on the transaction description.
 * @param {string} description The user input description
 * @returns {object|null} { category, subcategory } or null
 */
export function predictCategory(description) {
    if (!description || description.trim() === '') return null;

    const text = normalizeText(description);

    for (const { key, result } of SORTED_KEYWORDS) {
        // Enforce word boundaries around the matched keyword.
        // (^|[^a-z0-9]) ensures the match either starts at the beginning or after a non-alphanumeric character (like space, punctuation).
        // ([^a-z0-9]|$) ensures the match either ends at the end or before a non-alphanumeric character.
        // This stops "luz" from matching "andaluz" or "dia" from matching "diario".
        const regex = new RegExp(`(^|[^a-z0-9])${escapeRegExp(key)}([^a-z0-9]|$)`, 'i');

        if (regex.test(text)) {
            if (CATEGORIES.includes(result.category)) {
                return result;
            }
        }
    }

    return null;
}
