import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme.dart';
import '../models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/finance_provider.dart';

class EditTransactionSheet extends ConsumerStatefulWidget {
  final TransactionModel transaction;
  const EditTransactionSheet({super.key, required this.transaction});

  @override
  ConsumerState<EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends ConsumerState<EditTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late TextEditingController _descController;
  late TextEditingController _amountController;
  late String _category;
  late DateTime _date;
  bool _isLoading = false;

  final _categories = [
    'General', 'Food & Dining', 'Transport', 'Housing',
    'Health', 'Entertainment', 'Shopping', 'Income', 'Savings', 'Investment'
  ];

  @override
  void initState() {
    super.initState();
    _type = widget.transaction.type;
    _descController = TextEditingController(text: widget.transaction.description);
    _amountController = TextEditingController(text: widget.transaction.amount.toStringAsFixed(2));
    _category = _categories.contains(widget.transaction.category)
        ? widget.transaction.category
        : 'General';
    _date = widget.transaction.date;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.transaction.id == null) return;

    setState(() => _isLoading = true);

    await ref.read(financeActionsProvider).updateTransaction(
      widget.transaction.id!,
      {
        'description': _descController.text.trim(),
        'amount': double.parse(_amountController.text),
        'type': _type,
        'category': _category,
        'date': _date.toIso8601String().split('T')[0],
      },
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
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

                  // Title
                  Row(
                    children: [
                      const Icon(LucideIcons.pencil, size: 18, color: AppColors.accentColor),
                      const SizedBox(width: 8),
                      const Text('Editar Transacción',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Type Selector
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
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      prefixText: '€ ',
                      prefixStyle: TextStyle(color: AppColors.textMuted),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
                  ),
                  const SizedBox(height: 16),

                  // Category
                  _buildLabel('Categoría'),
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
                        lastDate: DateTime.now().add(const Duration(days: 365)),
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
                  const SizedBox(height: 24),

                  // Save button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _submit,
                      icon: _isLoading
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(LucideIcons.check, size: 20),
                      label: const Text(
                        'Guardar Cambios',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentColor,
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
}
