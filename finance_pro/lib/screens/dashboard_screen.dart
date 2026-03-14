import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/finance_provider.dart';
import '../models/transaction_model.dart';
import '../services/supabase_service.dart';
import '../theme.dart';
import '../widgets/edit_transaction_sheet.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _filter = 'all';
  String _typeFilter = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final financeState = ref.watch(financeSummaryProvider);
    final recurringAsync = ref.watch(recurringProvider);
    final fmt = NumberFormat.currency(symbol: '€', decimalDigits: 2);

    // Apply filters
    List<TransactionModel> filteredTxs = _applyFilters(financeState.transactions);

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          // Radial gradient overlays
          Positioned(
            top: -100, right: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppColors.accentColor.withAlpha(38), Colors.transparent]),
              ),
            ),
          ),
          Positioned(
            bottom: -100, left: -100,
            child: Container(
              width: 400, height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [AppColors.accentPurple.withAlpha(38), Colors.transparent]),
              ),
            ),
          ),

          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(transactionsProvider);
                ref.invalidate(recurringProvider);
              },
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildNavbar(context)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildDashboardCards(financeState, fmt),
                    ),
                  ),
                  // Transaction list with filters
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                      child: _buildTransactionPanel(filteredTxs, fmt),
                    ),
                  ),
                  // Recurring transactions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: recurringAsync.maybeWhen(
                        data: (recs) => _buildRecurringPanel(recs, fmt),
                        orElse: () => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TransactionModel> _applyFilters(List<TransactionModel> txs) {
    var result = txs;
    final now = DateTime.now();

    if (_filter == 'daily') {
      result = result.where((t) => t.date.year == now.year && t.date.month == now.month && t.date.day == now.day).toList();
    } else if (_filter == 'monthly') {
      result = result.where((t) => t.date.year == now.year && t.date.month == now.month).toList();
    } else if (_filter == 'yearly') {
      result = result.where((t) => t.date.year == now.year).toList();
    }

    if (_typeFilter == 'income') {
      result = result.where((t) => t.type == 'income').toList();
    } else if (_typeFilter == 'expense') {
      result = result.where((t) => t.type == 'expense').toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((t) =>
        t.description.toLowerCase().contains(q) ||
        t.category.toLowerCase().contains(q) ||
        t.amount.toString().contains(q)
      ).toList();
    }

    return result;
  }

  // ── Navbar ──────────────────────────────────────────────
  Widget _buildNavbar(BuildContext context) {
    final user = supabaseService.currentUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(13),
              border: Border.all(color: AppColors.accentColor),
            ),
            child: const Center(child: Icon(LucideIcons.user, size: 18, color: AppColors.accentColor)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.email?.split('@').first ?? 'User',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textMain)),
              Text(user?.email ?? '',
                style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
            ],
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () => supabaseService.signOut(),
            icon: const Icon(LucideIcons.logOut, size: 16),
            label: const Text('Salir'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textMuted,
              side: const BorderSide(color: AppColors.cardBorder),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  // ── Dashboard Cards ─────────────────────────────────────
  Widget _buildDashboardCards(FinanceState state, NumberFormat fmt) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 700;
        final cards = [
          _buildGlassCard(title: 'Balance Total', value: fmt.format(state.balance),
            icon: LucideIcons.dollarSign, iconColor: AppColors.accentColor,
            iconBgColor: Colors.white.withAlpha(13), isPrimary: true),
          _buildGlassCard(title: 'Ingresos', value: fmt.format(state.totalIncome),
            icon: LucideIcons.arrowUpCircle, iconColor: AppColors.success,
            iconBgColor: AppColors.successBg),
          _buildGlassCard(title: 'Gastos', value: fmt.format(state.totalExpenses),
            icon: LucideIcons.arrowDownCircle, iconColor: AppColors.danger,
            iconBgColor: AppColors.dangerBg),
        ];

        if (isWide) {
          return Row(children: cards.map((c) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: c))).toList());
        }
        return Column(children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList());
      },
    );
  }

  Widget _buildGlassCard({required String title, required String value, required IconData icon,
    required Color iconColor, required Color iconBgColor, bool isPrimary = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withAlpha(180),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isPrimary ? AppColors.accentColor : AppColors.cardBorder),
            boxShadow: isPrimary ? [BoxShadow(color: AppColors.accentColor.withAlpha(38), blurRadius: 20)] : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(color: AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.w500)),
                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(shape: BoxShape.circle, color: iconBgColor),
                    child: Icon(icon, size: 20, color: iconColor)),
                ],
              ),
              const SizedBox(height: 12),
              isPrimary
                ? ShaderMask(shaderCallback: (bounds) => AppColors.accentGradient.createShader(bounds),
                    child: Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white)))
                : Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.textMain)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Transaction Panel with Filters ──────────────────────
  Widget _buildTransactionPanel(List<TransactionModel> txs, NumberFormat fmt) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withAlpha(180),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter tabs row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Todo', 'all'),
                    _buildFilterChip('Hoy', 'daily'),
                    _buildFilterChip('Mes', 'monthly'),
                    _buildFilterChip('Año', 'yearly'),
                    const SizedBox(width: 12),
                    _buildTypeChip('Todo', 'all'),
                    _buildTypeChip('Ingresos', 'income', AppColors.success),
                    _buildTypeChip('Gastos', 'expense', AppColors.danger),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Search bar
              Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(13),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(LucideIcons.search, size: 16, color: AppColors.textMuted),
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (v) => setState(() => _searchQuery = v),
                        style: const TextStyle(fontSize: 13, color: AppColors.textMain),
                        decoration: const InputDecoration(
                          hintText: 'Buscar transacciones...',
                          hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text('Transacciones (${txs.length})',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textMain)),
              const SizedBox(height: 12),
              if (txs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(25),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.cardBorder, style: BorderStyle.none),
                  ),
                  child: const Center(
                    child: Column(
                      children: [
                        Icon(LucideIcons.calendar, size: 48, color: AppColors.textMuted),
                        SizedBox(height: 12),
                        Text('No hay transacciones', style: TextStyle(color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                )
              else
                ...txs.take(20).map((tx) => _buildDismissibleTransaction(tx, fmt)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isActive = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.cardBg : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? AppColors.textMuted.withAlpha(50) : Colors.transparent),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500,
          color: isActive ? AppColors.textMain : AppColors.textMuted,
        )),
      ),
    );
  }

  Widget _buildTypeChip(String label, String value, [Color? activeColor]) {
    final isActive = _typeFilter == value;
    final color = activeColor ?? AppColors.textMain;
    return GestureDetector(
      onTap: () => setState(() => _typeFilter = value),
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive && activeColor != null ? activeColor.withAlpha(38) : (isActive ? AppColors.cardBg : Colors.transparent),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive && activeColor != null ? activeColor.withAlpha(76) : (isActive ? AppColors.textMuted.withAlpha(50) : Colors.transparent)),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 12, fontWeight: FontWeight.w500,
          color: isActive ? (activeColor ?? AppColors.textMain) : AppColors.textMuted,
        )),
      ),
    );
  }

  // ── Dismissible Transaction Item ────────────────────────
  Widget _buildDismissibleTransaction(TransactionModel tx, NumberFormat fmt) {
    final isExpense = tx.type == 'expense';
    return Dismissible(
      key: Key(tx.id ?? tx.description + tx.date.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.danger.withAlpha(50),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(LucideIcons.trash2, color: AppColors.danger),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.cardBg,
            title: const Text('Eliminar', style: TextStyle(color: AppColors.textMain)),
            content: Text('¿Eliminar "${tx.description}"?', style: const TextStyle(color: AppColors.textMuted)),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Eliminar', style: TextStyle(color: AppColors.danger)),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (_) {
        if (tx.id != null) {
          ref.read(financeActionsProvider).deleteTransaction(tx.id!);
        }
      },
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => EditTransactionSheet(transaction: tx),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: isExpense ? AppColors.dangerBg : AppColors.successBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(_getCategoryIcon(tx.category), size: 18,
                    color: isExpense ? AppColors.danger : AppColors.success),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tx.description, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textMain),
                        overflow: TextOverflow.ellipsis),
                      Text(tx.category, style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                        overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${isExpense ? '-' : '+'}${fmt.format(tx.amount)}',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14,
                        color: isExpense ? AppColors.danger : AppColors.success)),
                    Text(DateFormat('dd MMM').format(tx.date),
                      style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Recurring Transactions Panel ────────────────────────
  Widget _buildRecurringPanel(List<Map<String, dynamic>> recs, NumberFormat fmt) {
    if (recs.isEmpty) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBg.withAlpha(180),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.repeat, size: 18, color: AppColors.accentColor),
                  const SizedBox(width: 8),
                  const Text('Recurrentes Activos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                ],
              ),
              const SizedBox(height: 12),
              ...recs.map((r) {
                final isExp = r['type'] == 'expense';
                final freq = _getFreqLabel(r['frequency'] ?? 'monthly');
                return Dismissible(
                  key: Key(r['id']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withAlpha(50),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(LucideIcons.trash2, color: AppColors.danger),
                  ),
                  onDismissed: (_) => ref.read(financeActionsProvider).deleteRecurringTransaction(r['id']),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(8),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r['description'] ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textMain)),
                                Text(r['category'] ?? '', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
                              ],
                            ),
                          ),
                          Text(
                            '${isExp ? '-' : '+'}${fmt.format((r['amount'] as num).toDouble())}',
                            style: TextStyle(fontWeight: FontWeight.w600, color: isExp ? AppColors.danger : AppColors.success),
                          ),
                          Text(' $freq', style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String _getFreqLabel(String freq) {
    const map = {'weekly': '/sem', 'monthly': '/mes', 'quarterly': '/trim', 'biannually': '/6m', 'annually': '/año'};
    return map[freq] ?? '/$freq';
  }

  IconData _getCategoryIcon(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('food') || cat.contains('comida') || cat.contains('dining')) return LucideIcons.utensils;
    if (cat.contains('transport') || cat.contains('gas')) return LucideIcons.car;
    if (cat.contains('income') || cat.contains('nómina') || cat.contains('salary')) return LucideIcons.banknote;
    if (cat.contains('health') || cat.contains('salud')) return LucideIcons.heartPulse;
    if (cat.contains('housing') || cat.contains('vivienda') || cat.contains('alquiler')) return LucideIcons.home;
    if (cat.contains('entertainment') || cat.contains('ocio') || cat.contains('cinema')) return LucideIcons.film;
    if (cat.contains('shopping') || cat.contains('clothing') || cat.contains('ropa')) return LucideIcons.shoppingBag;
    if (cat.contains('investment') || cat.contains('savings')) return LucideIcons.trendingUp;
    return LucideIcons.receipt;
  }
}
