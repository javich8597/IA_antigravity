import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme.dart';
import '../screens/dashboard_screen.dart';
import '../screens/analytics_screen.dart';
import '../screens/wealth_screen.dart';
import '../screens/profile_screen.dart';
import '../widgets/transaction_form_sheet.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  final _screens = const [
    DashboardScreen(),
    AnalyticsScreen(),
    SizedBox(), // placeholder for FAB
    WealthScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: IndexedStack(
        index: _currentIndex >= 2 ? _currentIndex : _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTransactionForm(context),
        backgroundColor: AppColors.accentColor,
        shape: const CircleBorder(),
        child: const Icon(LucideIcons.plus, color: Colors.white, size: 26),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  void _showTransactionForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const TransactionFormSheet(),
    );
  }

  Widget _buildBottomBar() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg.withAlpha(230),
            border: const Border(top: BorderSide(color: AppColors.cardBorder)),
          ),
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, LucideIcons.layoutDashboard, 'Dashboard'),
                _buildNavItem(1, LucideIcons.pieChart, 'Analytics'),
                const SizedBox(width: 48), // Space for FAB
                _buildNavItem(3, LucideIcons.trendingUp, 'Wealth'),
                _buildNavItem(4, LucideIcons.target, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accentColor.withAlpha(38) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive ? Border.all(color: AppColors.accentColor.withAlpha(76)) : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isActive ? AppColors.accentLight : AppColors.textMuted),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              color: isActive ? AppColors.accentLight : AppColors.textMuted,
            )),
          ],
        ),
      ),
    );
  }
}
