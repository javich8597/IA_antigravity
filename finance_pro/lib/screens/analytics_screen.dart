import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/analytics_provider.dart';
import '../theme.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(analyticsDataProvider);
    final period = ref.watch(analyticsPeriodProvider);
    final fmt = NumberFormat.currency(symbol: '€', decimalDigits: 2);

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
              const SizedBox(height: 20),

              // ── Period Filter Chips ──────────────────────────
              _buildPeriodFilter(ref, period),
              const SizedBox(height: 20),

              // ── Summary Cards ───────────────────────────────
              Row(
                children: [
                  Expanded(child: _buildMiniCard('Ingresos', fmt.format(data.totalIncome), AppColors.success, LucideIcons.arrowUpCircle)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildMiniCard('Gastos', fmt.format(data.totalExpenses), AppColors.danger, LucideIcons.arrowDownCircle)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildMiniCard('Balance', fmt.format(data.totalIncome - data.totalExpenses),
                    (data.totalIncome - data.totalExpenses) >= 0 ? AppColors.accentColor : AppColors.danger,
                    LucideIcons.scale)),
                ],
              ),
              const SizedBox(height: 24),

              // ── Trend Line Chart ────────────────────────────
              if (data.monthlyTrend.length >= 2) ...[
                _buildGlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.trendingUp, size: 16, color: AppColors.accentColor),
                          const SizedBox(width: 8),
                          const Text('Tendencia Mensual', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildLegendDot(AppColors.success, 'Ingresos'),
                          const SizedBox(width: 16),
                          _buildLegendDot(AppColors.danger, 'Gastos'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _buildTrendLineChart(data),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Monthly Comparison Bar Chart ────────────────
              if (data.monthlyTrend.isNotEmpty) ...[
                _buildGlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(LucideIcons.barChart3, size: 16, color: AppColors.accentPurple),
                          const SizedBox(width: 8),
                          const Text('Comparación Mensual', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _buildBarChart(data),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Pie Chart ───────────────────────────────────
              if (data.categoryBreakdown.isNotEmpty) ...[
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
                            sections: data.categoryBreakdown.asMap().entries.map((e) {
                              return PieChartSectionData(
                                value: e.value.amount,
                                title: '${e.value.percentage.toStringAsFixed(0)}%',
                                color: colors[e.key % colors.length],
                                radius: 55,
                                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12, runSpacing: 8,
                        children: data.categoryBreakdown.asMap().entries.map((e) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(width: 10, height: 10, decoration: BoxDecoration(color: colors[e.key % colors.length], shape: BoxShape.circle)),
                              const SizedBox(width: 6),
                              Text(e.value.name, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ── Category Breakdown (Enhanced with progress bars) ──
                _buildGlassPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Desglose Detallado', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                      const SizedBox(height: 16),
                      ...data.categoryBreakdown.asMap().entries.map((e) {
                        final idx = e.key;
                        final entry = e.value;
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
                                child: Icon(_getCategoryIcon(entry.name), size: 18, color: colors[idx % colors.length]),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(entry.name, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textMain)),
                                    const SizedBox(height: 4),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: LinearProgressIndicator(
                                        value: entry.percentage / 100,
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
                                  Text(fmt.format(entry.amount), style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textMain)),
                                  Text('${entry.percentage.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
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
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(LucideIcons.barChart3, size: 48, color: AppColors.textMuted.withAlpha(100)),
                          const SizedBox(height: 12),
                          const Text('No hay suficientes datos para generar gráficos.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMuted)),
                          const SizedBox(height: 4),
                          const Text('Añade transacciones desde el Dashboard.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),

              // ── Averages Row ────────────────────────────────
              if (data.monthlyTrend.isNotEmpty) ...[
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _buildMiniCard('Promedio Ingresos/mes', fmt.format(data.avgMonthlyIncome), AppColors.success, LucideIcons.calculator)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildMiniCard('Promedio Gastos/mes', fmt.format(data.avgMonthlyExpense), AppColors.danger, LucideIcons.calculator)),
                  ],
                ),
              ],

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  // ── Period Filter ──────────────────────────────────────
  Widget _buildPeriodFilter(WidgetRef ref, AnalyticsPeriod current) {
    final items = [
      (AnalyticsPeriod.month, 'Mes'),
      (AnalyticsPeriod.quarter, 'Trimestre'),
      (AnalyticsPeriod.year, 'Año'),
      (AnalyticsPeriod.all, 'Todo'),
    ];

    return Row(
      children: items.map((item) {
        final isActive = current == item.$1;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => ref.read(analyticsPeriodProvider.notifier).state = item.$1,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppColors.accentColor.withAlpha(38) : AppColors.cardBg.withAlpha(160),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? AppColors.accentColor : AppColors.cardBorder,
                ),
              ),
              child: Text(
                item.$2,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.accentLight : AppColors.textMuted,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Trend Line Chart ───────────────────────────────────
  Widget _buildTrendLineChart(AnalyticsData data) {
    final months = data.monthlyTrend;
    final maxVal = months.fold(0.0, (max, m) {
      final mMax = m.income > m.expense ? m.income : m.expense;
      return mMax > max ? mMax : max;
    });

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxVal > 0 ? maxVal / 4 : 1,
          getDrawingHorizontalLine: (value) => FlLine(color: AppColors.cardBorder, strokeWidth: 0.5),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= months.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateFormat('MMM').format(months[idx].month),
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (months.length - 1).toDouble(),
        minY: 0,
        maxY: maxVal * 1.15,
        lineBarsData: [
          // Income line
          LineChartBarData(
            spots: months.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.income)).toList(),
            isCurved: true,
            color: AppColors.success,
            barWidth: 2.5,
            dotData: FlDotData(show: months.length <= 12),
            belowBarData: BarAreaData(show: true, color: AppColors.success.withAlpha(20)),
          ),
          // Expense line
          LineChartBarData(
            spots: months.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.expense)).toList(),
            isCurved: true,
            color: AppColors.danger,
            barWidth: 2.5,
            dotData: FlDotData(show: months.length <= 12),
            belowBarData: BarAreaData(show: true, color: AppColors.danger.withAlpha(20)),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final label = spot.barIndex == 0 ? 'Ing' : 'Gas';
                return LineTooltipItem(
                  '$label: €${spot.y.toStringAsFixed(0)}',
                  TextStyle(color: spot.barIndex == 0 ? AppColors.success : AppColors.danger, fontSize: 12, fontWeight: FontWeight.w600),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  // ── Bar Chart ──────────────────────────────────────────
  Widget _buildBarChart(AnalyticsData data) {
    final months = data.monthlyTrend;
    final maxVal = months.fold(0.0, (max, m) {
      final mMax = m.income > m.expense ? m.income : m.expense;
      return mMax > max ? mMax : max;
    });

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxVal * 1.15,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxVal > 0 ? maxVal / 4 : 1,
          getDrawingHorizontalLine: (value) => FlLine(color: AppColors.cardBorder, strokeWidth: 0.5),
        ),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= months.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    DateFormat('MMM').format(months[idx].month),
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: months.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.income,
                color: AppColors.success,
                width: 10,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
              BarChartRodData(
                toY: e.value.expense,
                color: AppColors.danger,
                width: 10,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final label = rodIndex == 0 ? 'Ingresos' : 'Gastos';
              return BarTooltipItem(
                '$label\n€${rod.toY.toStringAsFixed(0)}',
                TextStyle(color: rodIndex == 0 ? AppColors.success : AppColors.danger, fontSize: 12, fontWeight: FontWeight.w600),
              );
            },
          ),
        ),
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────
  Widget _buildLegendDot(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ],
    );
  }

  Widget _buildMiniCard(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg.withAlpha(160),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Flexible(child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
          ),
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

  IconData _getCategoryIcon(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('food') || cat.contains('comida') || cat.contains('dining')) return LucideIcons.utensils;
    if (cat.contains('transport') || cat.contains('gas') || cat.contains('coche')) return LucideIcons.car;
    if (cat.contains('housing') || cat.contains('vivienda') || cat.contains('alquiler')) return LucideIcons.home;
    if (cat.contains('health') || cat.contains('salud') || cat.contains('seguro')) return LucideIcons.heartPulse;
    if (cat.contains('entertainment') || cat.contains('ocio') || cat.contains('cine')) return LucideIcons.film;
    if (cat.contains('shopping') || cat.contains('ropa') || cat.contains('compra')) return LucideIcons.shoppingBag;
    if (cat.contains('income') || cat.contains('salary') || cat.contains('nómina')) return LucideIcons.banknote;
    if (cat.contains('gym') || cat.contains('deporte') || cat.contains('fitness')) return LucideIcons.dumbbell;
    if (cat.contains('farmacia') || cat.contains('pharmacy')) return LucideIcons.pill;
    return LucideIcons.receipt;
  }
}
