import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/finance_provider.dart';
import '../theme.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financeSummaryProvider);
    final fmt = NumberFormat.currency(symbol: '€', decimalDigits: 2);

    // Group expenses by category
    final categoryTotals = <String, double>{};
    for (final tx in state.transactions.where((t) => t.type == 'expense')) {
      final cat = tx.category.split(' - ').first;
      categoryTotals[cat] = (categoryTotals[cat] ?? 0) + tx.amount;
    }

    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final colors = [
      const Color(0xFF6366F1), const Color(0xFFA855F7), const Color(0xFFEC4899),
      const Color(0xFFF43F5E), const Color(0xFFFACC15), const Color(0xFF10B981),
      const Color(0xFF3B82F6), const Color(0xFFF97316),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(LucideIcons.pieChart, size: 28, color: AppColors.accentColor),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Analytics', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textMain)),
                        Text('Visualiza a dónde va tu dinero', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Income vs Expenses cards
              Row(
                children: [
                  Expanded(child: _buildMiniCard('Ingresos', fmt.format(state.totalIncome), AppColors.success, LucideIcons.arrowUpCircle)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildMiniCard('Gastos', fmt.format(state.totalExpenses), AppColors.danger, LucideIcons.arrowDownCircle)),
                ],
              ),
              const SizedBox(height: 24),

              // Pie chart
              if (sortedCategories.isNotEmpty) ...[
                _buildGlassPanel(
                  child: Column(
                    children: [
                      const Text('Gasto por Categoría', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 220,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 50,
                            sections: sortedCategories.asMap().entries.map((e) {
                              final idx = e.key;
                              final entry = e.value;
                              final pct = state.totalExpenses > 0 ? (entry.value / state.totalExpenses * 100) : 0.0;
                              return PieChartSectionData(
                                value: entry.value,
                                title: '${pct.toStringAsFixed(0)}%',
                                color: colors[idx % colors.length],
                                radius: 55,
                                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Legend
                      Wrap(
                        spacing: 12, runSpacing: 8,
                        children: sortedCategories.asMap().entries.map((e) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[e.key % colors.length], shape: BoxShape.circle)),
                              const SizedBox(width: 6),
                              Text(e.value.key, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Category breakdown
                _buildGlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Desglose Detallado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                      const SizedBox(height: 16),
                      ...sortedCategories.asMap().entries.map((e) {
                        final idx = e.key;
                        final entry = e.value;
                        final pct = state.totalExpenses > 0 ? (entry.value / state.totalExpenses * 100) : 0.0;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: colors[idx % colors.length].withAlpha(25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(_getCategoryIcon(entry.key), size: 18, color: colors[idx % colors.length]),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textMain)),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: pct / 100,
                                        backgroundColor: AppColors.cardBorder,
                                        valueColor: AlwaysStoppedAnimation(colors[idx % colors.length]),
                                        minHeight: 4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(fmt.format(entry.value), style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMain)),
                                  Text('${pct.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ] else
                _buildGlassPanel(
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Text('No hay suficientes datos para generar gráficos.', style: TextStyle(color: AppColors.textMuted)),
                    ),
                  ),
                ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniCard(String label, String value, Color color, IconData icon) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withAlpha(180),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassPanel({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withAlpha(180),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: child,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('food') || cat.contains('dining')) return LucideIcons.utensils;
    if (cat.contains('transport') || cat.contains('gas')) return LucideIcons.car;
    if (cat.contains('housing')) return LucideIcons.home;
    if (cat.contains('health')) return LucideIcons.heartPulse;
    if (cat.contains('entertainment')) return LucideIcons.film;
    if (cat.contains('shopping')) return LucideIcons.shoppingBag;
    if (cat.contains('income') || cat.contains('salary')) return LucideIcons.banknote;
    return LucideIcons.receipt;
  }
}
