import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../data/local/database.dart';
import '../data/local/daos/user_category_memory_dao.dart';
import '../models/user_category_memory_model.dart';

// Constantes de las categorías predefinidas
const List<String> kAppCategories = [
  'General', 'Food & Dining', 'Transport', 'Housing',
  'Health', 'Entertainment', 'Shopping', 'Income', 'Savings', 'Investment'
];

final smartCategorizerProvider = Provider<SmartCategorizerService>((ref) {
  // Configured with a placeholder key. User MUST provide their own API key for Gemini to work.
  // In a production app, this would be injected via String.fromEnvironment or flutter_dotenv.
  const String apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'REPLACE_ME');
  return SmartCategorizerService(localDb.userCategoryMemoryDao, apiKey);
});

class CategorySuggestion {
  final String category;
  final String? subcategory;
  final String source; // 'local', 'rules', 'ai', 'fallback'

  const CategorySuggestion({
    required this.category,
    this.subcategory,
    required this.source,
  });
}

class SmartCategorizerService {
  final UserCategoryMemoryDao _memoryDao;
  final String _geminiApiKey;
  late final GenerativeModel? _model;

  SmartCategorizerService(this._memoryDao, this._geminiApiKey) {
    if (_geminiApiKey != 'REPLACE_ME' && _geminiApiKey.isNotEmpty) {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _geminiApiKey,
      );
    } else {
      _model = null; // AI feature disabled if no key
    }
  }

  Future<CategorySuggestion> suggestCategory(String? userId, String description) async {
    final cleanDesc = description.trim();
    if (cleanDesc.isEmpty) {
      return const CategorySuggestion(category: 'General', source: 'fallback');
    }

    // Nivel 1: Memoria Local del Usuario (Solo si el usuario está logueado)
    if (userId != null) {
      try {
        final existing = await _memoryDao.findBestMatch(userId, cleanDesc);

        // Ignoramos la memoria si es 'General', queremos que las reglas/IA intenten adivinarlo mejor.
        if (existing != null && kAppCategories.contains(existing.category) && existing.category != 'General') {
          return CategorySuggestion(
            category: existing.category,
            subcategory: existing.subcategory,
            source: 'memory'
          );
        }
      } catch (e) {
        print('Categorizer Local Memory ignored (DB might not be migrated): $e');
      }
    }

    // Nivel 2: Reglas estáticas básicas (Heurísticas visuales rápidas offline y fallback de seguridad)
    final ruleMatch = _applyBasicRules(cleanDesc.toLowerCase());
    if (ruleMatch != null) {
      return CategorySuggestion(category: ruleMatch, source: 'rules');
    }

    // Nivel 3: Inteligencia Artificial (Gemini API)
    if (_model != null) {
      try {
        final suggestion = await _askGemini(cleanDesc);
        if (suggestion != null && kAppCategories.contains(suggestion.category)) {
          return CategorySuggestion(
            category: suggestion.category,
            subcategory: suggestion.subcategory,
            source: 'ai'
          );
        }
      } catch (e) {
        print('Error with Gemini AI categorization: $e');
        // Falls through to fallback
      }
    }

    // Nivel 4: Fallback
    return const CategorySuggestion(category: 'General', source: 'fallback');
  }

  Future<void> saveUserCorrection(String userId, String keyword, String category, {String? subcategory}) async {
    final cleanKeyword = keyword.trim().toLowerCase();
    if (cleanKeyword.isEmpty) return;

    try {
      final existing = await _memoryDao.findBestMatch(userId, cleanKeyword);
      
      if (existing != null) {
        // User changed their mind or reinforced it
        if (existing.category == category && existing.subcategory == subcategory) {
          await _memoryDao.saveMemoryLocally(existing.copyWith(
            timesUsed: existing.timesUsed + 1,
            updatedAt: DateTime.now(),
          ));
        } else {
          // Overwrite standard behavior
          await _memoryDao.saveMemoryLocally(existing.copyWith(
            category: category,
            subcategory: subcategory,
            updatedAt: DateTime.now(),
          ));
        }
      } else {
        // New memory learning
        await _memoryDao.saveMemoryLocally(UserCategoryMemoryModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // Simple UUID placeholder
          userId: userId,
          keyword: cleanKeyword,
          category: category,
          subcategory: subcategory,
          updatedAt: DateTime.now(),
        ));
      }
    } catch (e) {
      print('Categorizer Save Memory failed (DB might not be migrated): $e');
    }
  }

  // --- Internals ---

  String? _applyBasicRules(String input) {
    if (input.contains('mercadona') || input.contains('carrefour') || input.contains('lidl') || input.contains('supermercado')) {
      return 'Food & Dining';
    }
    if (input.contains('netflix') || input.contains('spotify') || input.contains('hbo') || input.contains('cine')) {
      return 'Entertainment';
    }
    if (input.contains('uber') || input.contains('gasolina') || input.contains('repsol') || input.contains('renfe')) {
      return 'Transport';
    }
    if (input.contains('farmacia') || input.contains('médico') || input.contains('dentista')) {
      return 'Health';
    }
    if (input.contains('alquiler') || input.contains('luz') || input.contains('agua') || input.contains('internet')) {
      return 'Housing';
    }
    if (input.contains('nomina') || input.contains('bizum') && !input.contains('-')) { // Simplistic approach to income
       return null; // Let AI or explicit form take over logic
    }
    return null;
  }

  Future<({String category, String subcategory})?> _askGemini(String input) async {
    final prompt = '''
Eres un asistente experto en finanzas personales.
Clasifica la siguiente descripción de un gasto o ingreso: "$input"

Debes devolver EXACTAMENTE 2 líneas, sin formato markdown ni texto adicional.
La línea 1 debe ser una de estas categorías principales: ${kAppCategories.join(', ')}
La línea 2 debe ser una subcategoría breve (máximo 2 palabras, ej: Supermercado, Restaurante, Combustible, etc).
Si no tienes idea, devuelve "General" y "Varios".
''';

    final content = [Content.text(prompt)];
    final response = await _model!.generateContent(content);
    
    final responseText = response.text?.trim() ?? '';
    final lines = responseText.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    
    if (lines.length >= 2) {
      return (category: lines[0], subcategory: lines[1]);
    } else if (lines.isNotEmpty) {
      return (category: lines[0], subcategory: 'General');
    }
    
    return null;
  }
}
