import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/ant_expense_detector.dart';
import '../theme.dart';

class WeeklyHabitSummaryScreen extends StatelessWidget {
  final AntExpenseReport report;

  const WeeklyHabitSummaryScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(symbol: '€');

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Resumen Semanal de Hábitos', style: TextStyle(color: AppColors.textMain, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textMain),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(20),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.withAlpha(80)),
              ),
              child: Column(
                children: [
                  const Text('🐜', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  const Text('Gastos Hormiga (Últ. 30 días)', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text(fmt.format(report.totalWasted), style: const TextStyle(color: Colors.amber, fontSize: 36, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Estos pequeños gastos recurrentes en categorías no esenciales están impactando tu presupuesto de forma silenciosa.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textMuted, fontSize: 13, height: 1.5)),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Patrones Detectados', style: TextStyle(color: AppColors.textMain, fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            ...report.patterns.map((p) => _buildPatternCard(p, fmt)),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternCard(AntExpensePattern pattern, NumberFormat fmt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: AppColors.dangerBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(LucideIcons.trendingDown, color: AppColors.danger, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pattern.description, style: const TextStyle(color: AppColors.textMain, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('${pattern.count} veces • Promedio ${fmt.format(pattern.averageAmount)}', 
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
              ],
            ),
          ),
          Text(fmt.format(pattern.totalAmount), 
            style: const TextStyle(color: AppColors.danger, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
