import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../services/ant_expense_detector.dart';
import '../theme.dart';
import '../screens/weekly_habit_summary_screen.dart';

class AntExpenseCard extends StatelessWidget {
  final AntExpenseReport report;

  const AntExpenseCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    if (report.patterns.isEmpty) return const SizedBox.shrink();

    final fmt = NumberFormat.currency(symbol: '€');

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => WeeklyHabitSummaryScreen(report: report)
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.amber.withAlpha(20),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.withAlpha(80)),
        ),
        child: Row(
          children: [
            const Text('🐜', style: TextStyle(fontSize: 26)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fuga Fina Detectada', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('${report.patterns.length} hábitos suman ${fmt.format(report.totalWasted)}/mes',
                    style: const TextStyle(color: AppColors.textMain, fontSize: 12)),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, size: 18, color: AppColors.textMain),
          ],
        ),
      ),
    );
  }
}
