import { pipeline, env } from '@xenova/transformers';
import { CATEGORIES, CATEGORY_HIERARCHY } from './categoryIcons';

// Configure transformers.js for the browser
env.allowLocalModels = false;

/**
 * Keyword mapping rules for automatic categorization.
 * Maps raw lowercase keywords (in Spanish and English) to standard Categories and Subcategories.
 */
const KEYWORD_MAP = {
    // Housing
    'alquiler': { category: 'Housing', subcategory: 'Alquiler' },
    'hipoteca': { category: 'Housing', subcategory: 'Hipoteca' },
    'comunidad': { category: 'Housing', subcategory: 'Comunidad' },
    'ibi': { category: 'Housing', subcategory: 'IBI y Tasas' },
    'muebles': { category: 'Housing', subcategory: 'Muebles y Decoración' },
    'ikea': { category: 'Housing', subcategory: 'Muebles y Decoración' },
    'leroy merlin': { category: 'Housing', subcategory: 'Mantenimiento y Obras' },
    'bricomart': { category: 'Housing', subcategory: 'Mantenimiento y Obras' },

    // Utilities
    'luz': { category: 'Utilities', subcategory: 'Luz' },
    'iberdrola': { category: 'Utilities', subcategory: 'Luz' },
    'endesa': { category: 'Utilities', subcategory: 'Luz' },
    'agua': { category: 'Utilities', subcategory: 'Agua' },
    'gas': { category: 'Utilities', subcategory: 'Gas' },
    'internet': { category: 'Utilities', subcategory: 'Internet y Fibra' },
    'movistar': { category: 'Utilities', subcategory: 'Teléfono Móvil' },
    'vodafone': { category: 'Utilities', subcategory: 'Teléfono Móvil' },

    // Food
    'mercadona': { category: 'Food', subcategory: 'Supermercado' },
    'carrefour': { category: 'Food', subcategory: 'Supermercado' },
    'consum': { category: 'Food', subcategory: 'Supermercado' },
    'supermercado': { category: 'Food', subcategory: 'Supermercado' },
    'super': { category: 'Food', subcategory: 'Supermercado' },
    'leche': { category: 'Food', subcategory: 'Supermercado' },
    'carne': { category: 'Food', subcategory: 'Supermercado' },
    'fruta': { category: 'Food', subcategory: 'Frutería' },
    'fruteria': { category: 'Food', subcategory: 'Frutería' },
    'pan': { category: 'Food', subcategory: 'Panadería' },
    'panaderia': { category: 'Food', subcategory: 'Panadería' },
    'carniceria': { category: 'Food', subcategory: 'Carnicería' },

    // Transportation
    'gasolina': { category: 'Transportation', subcategory: 'Gasolina' },
    'gasolinera': { category: 'Transportation', subcategory: 'Gasolina' },
    'repsol': { category: 'Transportation', subcategory: 'Gasolina' },
    'taller': { category: 'Transportation', subcategory: 'Mantenimiento y Taller' },
    'coche': { category: 'Transportation', subcategory: 'Mantenimiento y Taller' },
    'bus': { category: 'Transportation', subcategory: 'Transporte Público' },
    'metro': { category: 'Transportation', subcategory: 'Transporte Público' },
    'taxi': { category: 'Transportation', subcategory: 'Taxi / VTC' },
    'uber': { category: 'Transportation', subcategory: 'Taxi / VTC' },
    'parking': { category: 'Transportation', subcategory: 'Peajes y Parking' },

    // Dining
    'restaurante': { category: 'Dining', subcategory: 'Restaurantes' },
    'cena': { category: 'Dining', subcategory: 'Restaurantes' },
    'bar': { category: 'Dining', subcategory: 'Bares y Pubs' },
    'cerveza': { category: 'Dining', subcategory: 'Bares y Pubs' },
    'cafeteria': { category: 'Dining', subcategory: 'Cafetería' },
    'cafe': { category: 'Dining', subcategory: 'Cafetería' },
    'glovo': { category: 'Dining', subcategory: 'Comida a Domicilio' },
    'uber eats': { category: 'Dining', subcategory: 'Comida a Domicilio' },

    // Entertainment
    'cine': { category: 'Entertainment', subcategory: 'Cine y Entradas' },
    'netflix': { category: 'Entertainment', subcategory: 'Suscripciones Digitales' },
    'spotify': { category: 'Entertainment', subcategory: 'Suscripciones Digitales' },
    'juego': { category: 'Entertainment', subcategory: 'Videojuegos' },
    'steam': { category: 'Entertainment', subcategory: 'Videojuegos' },
    'libro': { category: 'Entertainment', subcategory: 'Libros y Cultura' },

    // Shopping
    'ropa': { category: 'Shopping', subcategory: 'Ropa y Calzado' },
    'zara': { category: 'Shopping', subcategory: 'Ropa y Calzado' },
    'amazon': { category: 'Shopping', subcategory: 'Electrónica' },
    'regalo': { category: 'Shopping', subcategory: 'Regalos' },

    // Healthcare
    'farmacia': { category: 'Healthcare', subcategory: 'Farmacia' },
    'medico': { category: 'Healthcare', subcategory: 'Consultas Médicas' },
    'sanitas': { category: 'Healthcare', subcategory: 'Seguro Médico' },
    'gimnasio': { category: 'Healthcare', subcategory: 'Gimnasio' },
    'gym': { category: 'Healthcare', subcategory: 'Gimnasio' },
    'peluqueria': { category: 'Healthcare', subcategory: 'Estética y Peluquería' },
    'pelu': { category: 'Healthcare', subcategory: 'Estética y Peluquería' },
    'dentista': { category: 'Healthcare', subcategory: 'Dentista' },

    // Travel
    'vuelo': { category: 'Travel', subcategory: 'Vuelos y Trenes' },
    'ryanair': { category: 'Travel', subcategory: 'Vuelos y Trenes' },
    'hotel': { category: 'Travel', subcategory: 'Hoteles y Alojamiento' },
    'airbnb': { category: 'Travel', subcategory: 'Hoteles y Alojamiento' },

    // Education
    'universidad': { category: 'Education', subcategory: 'Matrículas y Tasas' },
    'curso': { category: 'Education', subcategory: 'Cursos y Másters' },
    'ingles': { category: 'Education', subcategory: 'Clases Particulares' },

    // Family
    'mascota': { category: 'Family', subcategory: 'Mascotas' },
    'perro': { category: 'Family', subcategory: 'Mascotas' },
    'veterinario': { category: 'Family', subcategory: 'Veterinario' },
    'colegio': { category: 'Family', subcategory: 'Guardería y Colegio' },
    'guarderia': { category: 'Family', subcategory: 'Guardería y Colegio' },
    'juguete': { category: 'Family', subcategory: 'Gastos Niños' },

    // Finance
    'comision': { category: 'Finance', subcategory: 'Comisiones Bancarias' },
    'seguro': { category: 'Finance', subcategory: 'Seguros' },
    'impuesto': { category: 'Finance', subcategory: 'Impuestos' },
    'multa': { category: 'Finance', subcategory: 'Multas' },
    'prestamo': { category: 'Finance', subcategory: 'Préstamos' },

    // Investments
    'ahorro': { category: 'Investments', subcategory: 'Traspaso a Ahorros' },
    'bolsa': { category: 'Investments', subcategory: 'Bolsa y Fondos' },
    'cripto': { category: 'Investments', subcategory: 'Criptomonedas' },

    // Income
    'nomina': { category: 'Income', subcategory: 'Nómina' },
    'salario': { category: 'Income', subcategory: 'Nómina' },
    'venta': { category: 'Income', subcategory: 'Extras y Bonos' },
    'devolucion': { category: 'Income', subcategory: 'Devoluciones' },

    // Internal
    'bizum': { category: 'Internal', subcategory: 'Ajustes manuales' },
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

    // --- V22: USER MEMORY CHECK ---
    try {
        const memStr = localStorage.getItem('user_categorizer_memory');
        if (memStr) {
            const mem = JSON.parse(memStr);
            const savedCategory = mem[text];
            if (savedCategory && CATEGORIES.includes(savedCategory.split(' - ')[0])) {
                const root = savedCategory.split(' - ')[0];
                const sub = savedCategory.split(' - ')[1] || '';
                return { category: root, subcategory: sub };
            }
        }
    } catch (e) {
        console.error("Failed to read user memory", e);
    }
    // ------------------------------

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

// ----------------------------------------------------------------------
// V21: AI-POWERED CATEGORIZATION (TRANSFORMERS.JS)
// ----------------------------------------------------------------------

const AI_MODEL = 'Xenova/distilbert-base-uncased-mnli';
let categorizerPipeline = null;
let isModelLoading = false;
export let isModelReady = false;

/**
 * Initializes the AI model in the background.
 * Uses a singleton pattern so it only loads once context-wide.
 */
export async function initAIModel() {
    if (categorizerPipeline) return categorizerPipeline;
    if (isModelLoading) return null;

    try {
        isModelLoading = true;
        // The first time this runs, it will download ~30MB from the Hugging Face CDN
        categorizerPipeline = await pipeline('zero-shot-classification', AI_MODEL, {
            // Options to optimize for browser:
            quantized: true
        });
        isModelReady = true;
        isModelLoading = false;
        console.log("Semantic Categorizer AI loaded successfully.");
        return categorizerPipeline;
    } catch (e) {
        console.error("Error loading AI model:", e);
        isModelLoading = false;
        return null;
    }
}

/**
 * Spanish translation map for the candidate labels.
 * We pass these to the model to bridge the gap for Spanish inputs,
 * then map the winning Spanish phrase back to our internal English category.
 */
const AI_SPANISH_LABELS = {
    'Vivienda y Alquiler': 'Housing',
    'Suministros y Facturas': 'Utilities',
    'Mercado y Alimentación': 'Food',
    'Transporte y Gasolina': 'Transportation',
    'Restaurantes y Cenas': 'Dining',
    'Ocio y Entretenimiento': 'Entertainment',
    'Compras Locales y Ropa': 'Shopping',
    'Salud, Gimnasio y Farmacia': 'Healthcare',
    'Viajes y Vacaciones': 'Travel',
    'Educación y Cursos': 'Education',
    'Familia y Mascotas': 'Family',
    'Finanzas e Impuestos': 'Finance',
    'Asignación a Inversiones': 'Investments',
    'Nómina e Ingresos': 'Income',
    'Movimientos Internos': 'Internal'
};
const CANDIDATE_LABELS_ES = Object.keys(AI_SPANISH_LABELS);

/**
 * AI-powered zero-shot classification fallback.
 * Validates against precise semantic meaning rather than hardcoded keywords.
 * @param {string} description The user input description
 * @returns {Promise<object|null>} { category, subcategory } or null
 */
export async function predictCategoryAI(description) {
    if (!description || description.trim() === '') return null;

    // 1. First try the instant keyword matching (0ms overhead)
    const manualResult = predictCategory(description);
    if (manualResult) return manualResult;

    // 2. Fallback to AI (requires model to be initialized)
    // If not loaded yet, just start the load process in background and return null for now
    // to avoid blocking UI heavily on first ever type.
    if (!categorizerPipeline) {
        initAIModel();
        return null;
    }

    try {
        // Enriched Prompt: Give the English-native AI context so it understands short words
        const enrichedPrompt = `This is a financial expense. I spent money on: ${description}`;

        // Zero-shot classification prompt using SPANISH candidate labels for semantic matching
        const result = await categorizerPipeline(enrichedPrompt, CANDIDATE_LABELS_ES, {
            multi_label: false
        });

        if (result && result.labels && result.labels.length > 0) {
            const topLabelES = result.labels[0];
            const topScore = result.scores[0];

            // If confidence is too low, ignore it to avoid totally random guesses
            if (topScore < 0.25) return null;

            // Map the winning Spanish label back to our English root category
            const topCategoryEN = AI_SPANISH_LABELS[topLabelES];
            if (!topCategoryEN) return null;

            // Pick the default subcategory for this detected root category
            const subcategory = CATEGORY_HIERARCHY[topCategoryEN][0];
            return { category: topCategoryEN, subcategory };
        }
    } catch (e) {
        console.error("AI Prediction error:", e);
    }

    return null;
}
