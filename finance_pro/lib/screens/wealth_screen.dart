import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/finance_provider.dart';
import '../theme.dart';

class WealthScreen extends ConsumerWidget {
  const WealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financeSummaryProvider);
    final fmt = NumberFormat.currency(symbol: '€', decimalDigits: 2);
    final netWorth = state.balance;
    final savingsRate = state.totalIncome > 0 ? ((state.totalIncome - state.totalExpenses) / state.totalIncome * 100) : 0.0;

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
                  const Icon(LucideIcons.trendingUp, size: 28, color: AppColors.accentColor),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Wealth', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textMain)),
                        Text('Tu patrimonio y ratios financieros', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Net Worth Hero Card
              _buildNetWorthHero(fmt, netWorth, savingsRate),
              const SizedBox(height: 24),

              // Financial Ratios
              _buildGlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ratios Financieros', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                    const SizedBox(height: 16),
                    _buildRatioItem('Tasa de Ahorro', '${savingsRate.toStringAsFixed(1)}%',
                        'Porcentaje del ingreso que ahorras', AppColors.accentLight),
                    _buildRatioItem('Ratio Gasto/Ingreso',
                        state.totalIncome > 0 ? '${(state.totalExpenses / state.totalIncome * 100).toStringAsFixed(1)}%' : 'N/A',
                        'Recomendado: < 80%', AppColors.warning),
                    _buildRatioItem('Balance Mensual', fmt.format(state.totalIncome - state.totalExpenses),
                        'Diferencia entre ingresos y gastos', netWorth >= 0 ? AppColors.success : AppColors.danger),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Balance Sheet
              _buildGlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Balance General', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                    const SizedBox(height: 16),
                    _buildBalanceSheetRow('Ingresos Totales', fmt.format(state.totalIncome), const Color(0xFF4ADE80)),
                    Divider(color: AppColors.cardBorder, height: 1),
                    _buildBalanceSheetRow('Gastos Totales', fmt.format(state.totalExpenses), const Color(0xFFF87171)),
                    Divider(color: AppColors.cardBorder, height: 1),
                    _buildBalanceSheetRow('Patrimonio Neto', fmt.format(netWorth), AppColors.accentLight, isBold: true),
                  ],
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNetWorthHero(NumberFormat fmt, double netWorth, double savingsRate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accentColor.withAlpha(38), AppColors.accentPurple.withAlpha(25)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentColor.withAlpha(76)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 25, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          const Text('PATRIMONIO NETO', style: TextStyle(
            fontSize: 13, color: AppColors.textMuted, letterSpacing: 2, fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => AppColors.accentGradient.createShader(bounds),
            child: Text(fmt.format(netWorth),
              style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w800, color: Colors.white, height: 1.1)),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: savingsRate >= 0 ? AppColors.successBg : AppColors.dangerBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: savingsRate >= 0 ? AppColors.success.withAlpha(76) : AppColors.danger.withAlpha(76)),
            ),
            child: Text(
              'Tasa de ahorro: ${savingsRate.toStringAsFixed(1)}%',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13,
                color: savingsRate >= 0 ? const Color(0xFF4ADE80) : const Color(0xFFF87171)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatioItem(String title, String score, String desc, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textMain)),
                Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withAlpha(76)),
            ),
            child: Text(score, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSheetRow(String label, String value, Color color, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(
            fontSize: isBold ? 16 : 14, fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
            color: isBold ? AppColors.textMain : AppColors.textMuted)),
          Text(value, style: TextStyle(fontSize: isBold ? 18 : 15, fontWeight: FontWeight.w600, color: color)),
        ],
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
}
