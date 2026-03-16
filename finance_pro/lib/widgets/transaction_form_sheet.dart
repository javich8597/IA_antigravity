import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme.dart';
import '../models/transaction_model.dart';
import '../services/supabase_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/finance_provider.dart';
import '../services/smart_categorizer.dart';

class TransactionFormSheet extends ConsumerStatefulWidget {
  const TransactionFormSheet({super.key});

  @override
  ConsumerState<TransactionFormSheet> createState() => _TransactionFormSheetState();
}

class _TransactionFormSheetState extends ConsumerState<TransactionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'expense';
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String _category = 'General';
  DateTime _date = DateTime.now();
  String _currency = 'EUR';
  bool _isLoading = false;
  bool _isCategorizing = false;
  bool _isRecurring = false;
  String _frequency = 'monthly';
  Timer? _debounce;

  final _currencies = ['EUR', 'USD', 'GBP', 'JPY', 'CHF', 'CAD', 'AUD', 'MXN'];

  final _frequencies = {
    'weekly': 'Semanal',
    'monthly': 'Mensual',
    'quarterly': 'Trimestral',
    'biannually': 'Semestral',
    'annually': 'Anual',
  };

  final _categories = [
    'General', 'Food & Dining', 'Transport', 'Housing',
    'Health', 'Entertainment', 'Shopping', 'Income', 'Savings', 'Investment'
  ];

  @override
  void initState() {
    super.initState();
    _descController.addListener(_onDescChanged);
  }

  void _onDescChanged() {
    setState(() {}); // Update the button visibility
    
    // Auto-categorize magically when user stops typing for 800ms
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 800), () {
      final text = _descController.text.trim();
      if (text.isNotEmpty && text.length > 2) {
        _suggestCategory(isAutomatic: true);
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    if (_isRecurring) {
      await ref.read(financeActionsProvider).addRecurringTransaction({
        'user_id': supabaseService.currentUser!.id,
        'description': _descController.text.trim(),
        'amount': double.parse(_amountController.text),
        'currency': _currency,
        'type': _type,
        'category': _category,
        'frequency': _frequency,
        'start_date': _date.toIso8601String().split('T')[0],
        'next_date': _date.toIso8601String().split('T')[0],
      });
    } else {
      final tx = TransactionModel(
        userId: supabaseService.currentUser!.id,
        description: _descController.text.trim(),
        amount: double.parse(_amountController.text),
        type: _type,
        category: _category,
        date: _date,
      );
      await ref.read(financeActionsProvider).addTransaction(tx);
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _descController.removeListener(_onDescChanged);
    _descController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg.withAlpha(240),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: const Border(top: BorderSide(color: AppColors.cardBorder)),
          ),
          padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag handle
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.textMuted.withAlpha(80),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const Text('Nueva Transacción',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                  const SizedBox(height: 20),

                  // Type Selector (expense/income toggle)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(50),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        _buildTypeButton('expense', 'Gasto', AppColors.danger),
                        _buildTypeButton('income', 'Ingreso', AppColors.success),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  _buildLabel('Descripción'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descController,
                    decoration: const InputDecoration(hintText: 'Ej: Supermercado Lidl'),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),

                  // Amount
                  _buildLabel('Cantidad'),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: const Color(0x33000000),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _currency,
                            dropdownColor: AppColors.cardBg,
                            style: const TextStyle(color: AppColors.textMain, fontWeight: FontWeight.w600),
                            items: _currencies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                            onChanged: (v) => setState(() => _currency = v!),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            hintText: '0.00',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildLabel('Categoría'),
                      if (_descController.text.isNotEmpty)
                        TextButton.icon(
                          onPressed: _isCategorizing ? null : () => _suggestCategory(),
                          icon: _isCategorizing
                              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(LucideIcons.sparkles, size: 14, color: Colors.amber),
                          label: Text(
                            _isCategorizing ? 'Pensando...' : 'Auto-Categorizar',
                            style: const TextStyle(fontSize: 12, color: Colors.amber),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0x33000000),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _category,
                        isExpanded: true,
                        dropdownColor: AppColors.cardBg,
                        style: const TextStyle(color: AppColors.textMain),
                        items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                        onChanged: (v) => setState(() => _category = v!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date
                  _buildLabel('Fecha'),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _date,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                        builder: (ctx, child) => Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(primary: AppColors.accentColor, surface: AppColors.cardBg),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) setState(() => _date = picked);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0x33000000),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(LucideIcons.calendar, size: 16, color: AppColors.textMuted),
                          const SizedBox(width: 10),
                          Text(
                            '${_date.day.toString().padLeft(2, '0')}/${_date.month.toString().padLeft(2, '0')}/${_date.year}',
                            style: const TextStyle(color: AppColors.textMain),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Recurring Toggle
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.accentColor.withAlpha(13),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.accentColor.withAlpha(25)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(LucideIcons.repeat, size: 16, color: AppColors.accentLight),
                                const SizedBox(width: 8),
                                const Text('Hacer Recurrente', style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.textMain, fontSize: 14)),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _isRecurring = !_isRecurring),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                width: 44, height: 24,
                                decoration: BoxDecoration(
                                  color: _isRecurring ? AppColors.accentLight : AppColors.cardBorder,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: AnimatedAlign(
                                  duration: const Duration(milliseconds: 250),
                                  alignment: _isRecurring ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    margin: const EdgeInsets.all(2),
                                    width: 20, height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 4)],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Frequency selector (visible when recurring)
                        AnimatedCrossFade(
                          duration: const Duration(milliseconds: 250),
                          crossFadeState: _isRecurring ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          firstChild: const SizedBox.shrink(),
                          secondChild: Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 1,
                                  color: AppColors.accentColor.withAlpha(50),
                                  margin: const EdgeInsets.only(bottom: 12),
                                ),
                                const Text('Frecuencia', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0x33000000),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.cardBorder),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _frequency,
                                      isExpanded: true,
                                      dropdownColor: AppColors.cardBg,
                                      style: const TextStyle(color: AppColors.textMain),
                                      items: _frequencies.entries.map((e) => DropdownMenuItem(
                                        value: e.key,
                                        child: Text(e.value),
                                      )).toList(),
                                      onChanged: (v) => setState(() => _frequency = v!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _submit,
                      icon: _isLoading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(LucideIcons.plusCircle, size: 20),
                      label: Text(
                        _type == 'income' ? 'Añadir Ingreso' : 'Añadir Gasto',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _type == 'income' ? AppColors.success : AppColors.danger,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(String type, String label, Color activeColor) {
    final isActive = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isActive
                ? [BoxShadow(color: activeColor.withAlpha(76), blurRadius: 12)]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.white : AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textMuted));
  }

  Future<void> _suggestCategory({bool isAutomatic = false}) async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) return;
    
    // Don't override if user already manually changed it and this is an automatic trigger
    if (isAutomatic && _category != 'General') return;

    print('Auto-Categorizing: "$desc" (Automatic: $isAutomatic)');
    setState(() => _isCategorizing = true);
    try {
      final user = supabaseService.currentUser;
      
      final categorizer = ref.read(smartCategorizerProvider);
      final suggestion = await categorizer.suggestCategory(user?.id, desc);
      
      print('Suggestion applied: ${suggestion.category} via ${suggestion.source}');
      
      if (mounted) {
        setState(() {
          _category = suggestion.category;
        });
        
        // Solo mostramos el SnackBar si el usuario explicitly pulsó el botón. 
        // Si es automático, el cambio visual en el dropdown es suficiente (no intrusivo).
        if (!isAutomatic) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('Sugerencia: ${suggestion.category} (${suggestion.source})'),
               backgroundColor: AppColors.success,
               duration: const Duration(seconds: 2),
             )
          );
        }
      }
    } catch (e) {
      print('Categorize Exception: $e');
      if (mounted && !isAutomatic) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al auto-categorizar'), backgroundColor: AppColors.danger)
        );
      }
    } finally {
      if (mounted) setState(() => _isCategorizing = false);
    }
  }
}
