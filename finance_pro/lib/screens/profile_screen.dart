import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../providers/finance_provider.dart';
import '../models/goal_model.dart';
import '../services/supabase_service.dart';
import '../theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _showGoalForm = false;
  final _goalNameController = TextEditingController();
  final _goalTargetController = TextEditingController();
  final _goalInitialController = TextEditingController();
  String? _activeAddFundsId;
  final _addFundsController = TextEditingController();

  @override
  void dispose() {
    _goalNameController.dispose();
    _goalTargetController.dispose();
    _goalInitialController.dispose();
    _addFundsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = supabaseService.currentUser;
    final state = ref.watch(financeSummaryProvider);
    final goalsAsync = ref.watch(goalsProvider);
    final fmt = NumberFormat.currency(symbol: '€', decimalDigits: 2);

    final savingsRate = state.totalIncome > 0 ? ((state.totalIncome - state.totalExpenses) / state.totalIncome * 100) : 0.0;
    final debtRatio = state.totalIncome > 0 ? (state.totalExpenses / state.totalIncome * 100) : 0.0;

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
                  const Icon(LucideIcons.user, size: 28, color: AppColors.accentColor),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Perfil', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textMain)),
                        Text('Tu salud financiera y metas de ahorro', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Health Overview + Goals in a grid-like layout
              // Health Overview
              _buildGlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Salud Financiera', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                    const SizedBox(height: 16),

                    // Health Status Banner
                    _buildHealthBanner(savingsRate),
                    const SizedBox(height: 16),

                    // Ratios grid
                    Row(
                      children: [
                        Expanded(child: _buildRatioCard('Tasa de Ahorro', '${savingsRate.toStringAsFixed(1)}%', 'Objetivo: > 20%', savingsRate > 20 ? AppColors.success : AppColors.textMain)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildRatioCard('Ratio Gasto', '${debtRatio.toStringAsFixed(1)}%', 'Objetivo: < 80%', debtRatio > 80 ? AppColors.danger : AppColors.textMain)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Top 3 expense categories
                    const Text('Top Categorías de Gasto', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                    const SizedBox(height: 8),
                    _buildTopCategories(state),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Goals Section
              _buildGlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(LucideIcons.target, size: 18, color: AppColors.accentColor),
                            SizedBox(width: 8),
                            Text('Metas de Ahorro', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _showGoalForm = !_showGoalForm),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.accentColor.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.accentColor.withAlpha(76)),
                            ),
                            child: Icon(_showGoalForm ? LucideIcons.x : LucideIcons.plusCircle, size: 18, color: AppColors.accentLight),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Add Goal Form
                    if (_showGoalForm) ...[
                      _buildGoalForm(),
                      const SizedBox(height: 16),
                    ],

                    // Goals List
                    goalsAsync.when(
                      data: (goals) {
                        if (goals.isEmpty && !_showGoalForm) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Text('No tienes metas activas.\nPulsa + para crear una.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textMuted)),
                            ),
                          );
                        }
                        return Column(
                          children: goals.map((g) => _buildGoalCard(g, fmt, state)).toList(),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.accentColor)),
                      error: (e, _) => Text('Error: $e', style: const TextStyle(color: AppColors.danger)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Settings + Logout
              _buildGlassPanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Cuenta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                    const SizedBox(height: 12),
                    // Avatar row
                    Row(
                      children: [
                        Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(13),
                            border: Border.all(color: AppColors.accentColor, width: 2),
                          ),
                          child: const Center(child: Icon(LucideIcons.user, size: 24, color: AppColors.accentColor)),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.email?.split('@').first ?? 'User', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textMain)),
                            Text(user?.email ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSettingsItem(LucideIcons.globe, 'Idioma', 'Español'),
                    _buildSettingsItem(LucideIcons.currency, 'Moneda', 'EUR (€)'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => supabaseService.signOut(),
                  icon: const Icon(LucideIcons.logOut, size: 18),
                  label: const Text('Cerrar Sesión', style: TextStyle(fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  // ── Health Banner ───────────────────────────────────────
  Widget _buildHealthBanner(double savingsRate) {
    String status;
    Color color;
    IconData icon;

    if (savingsRate < 0) {
      status = 'Crítico - Déficit';
      color = AppColors.danger;
      icon = LucideIcons.alertTriangle;
    } else if (savingsRate < 20) {
      status = 'Necesita Atención';
      color = AppColors.warning;
      icon = LucideIcons.trendingUp;
    } else {
      status = 'Bueno';
      color = AppColors.success;
      icon = LucideIcons.shieldCheck;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Estado: $status', style: TextStyle(fontWeight: FontWeight.w600, color: color)),
                const Text('Basado en el ratio ingresos vs gastos', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Ratio Card ──────────────────────────────────────────
  Widget _buildRatioCard(String label, String value, String hint, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(50),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: valueColor)),
          Text(hint, style: const TextStyle(fontSize: 10, color: AppColors.textMuted)),
        ],
      ),
    );
  }

  // ── Top Categories ──────────────────────────────────────
  Widget _buildTopCategories(FinanceState state) {
    final catMap = <String, double>{};
    for (final tx in state.transactions.where((t) => t.type == 'expense')) {
      catMap[tx.category] = (catMap[tx.category] ?? 0) + tx.amount;
    }
    final sorted = catMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    if (sorted.isEmpty) {
      return const Text('Sin datos de gastos.', style: TextStyle(color: AppColors.textMuted, fontStyle: FontStyle.italic));
    }

    return Column(
      children: sorted.take(3).map((e) {
        final pct = state.totalExpenses > 0 ? (e.value / state.totalExpenses * 100).toStringAsFixed(0) : '0';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(child: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textMain))),
              Text('$pct%', style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textMain)),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ── Goal Form ───────────────────────────────────────────
  Widget _buildGoalForm() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(50),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _goalNameController,
            decoration: const InputDecoration(labelText: 'Nombre de la Meta', hintText: 'Ej: Casa de ensueño'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _goalTargetController,
                  decoration: const InputDecoration(labelText: 'Cantidad Objetivo', prefixText: '€ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _goalInitialController,
                  decoration: const InputDecoration(labelText: 'Ahorro Inicial', prefixText: '€ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitGoal,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success, foregroundColor: Colors.white),
              child: const Text('Crear Meta', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitGoal() async {
    final name = _goalNameController.text.trim();
    final target = double.tryParse(_goalTargetController.text) ?? 0;
    final initial = double.tryParse(_goalInitialController.text) ?? 0;
    if (name.isEmpty || target <= 0) return;

    final goal = GoalModel(
      userId: supabaseAuth.currentUser!.id,
      name: name,
      targetAmount: target,
      currentAmount: initial,
      initialAmount: initial,
    );
    await ref.read(goalsProvider.notifier).add(goal);

    _goalNameController.clear();
    _goalTargetController.clear();
    _goalInitialController.clear();
    setState(() => _showGoalForm = false);
  }

  // ── Goal Card ───────────────────────────────────────────
  Widget _buildGoalCard(GoalModel goal, NumberFormat fmt, FinanceState state) {
    final progress = goal.progressPercent;
    final isComplete = goal.isCompleted;
    final isAddingFunds = _activeAddFundsId == goal.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + delete
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textMain)),
                    Text('${fmt.format(goal.currentAmount)} / ${fmt.format(goal.targetAmount)}',
                      style: const TextStyle(fontSize: 13, color: AppColors.textMuted)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (goal.id != null) ref.read(goalsProvider.notifier).delete(goal.id!);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: AppColors.dangerBg, borderRadius: BorderRadius.circular(6)),
                  child: const Icon(LucideIcons.trash2, size: 14, color: AppColors.danger),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withAlpha(25),
              valueColor: AlwaysStoppedAnimation(isComplete ? AppColors.success : AppColors.accentColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),

          // Bottom: percentage + add funds
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(progress * 100).toStringAsFixed(1)}% ${isComplete ? '¡Completado!' : ''}',
                style: TextStyle(fontWeight: FontWeight.w700, color: isComplete ? AppColors.success : AppColors.textMain),
              ),
              if (!isComplete)
                isAddingFunds
                  ? Row(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 32,
                          child: TextField(
                            controller: _addFundsController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: '+€',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            final amount = double.tryParse(_addFundsController.text) ?? 0;
                            if (amount > 0 && goal.id != null) {
                              ref.read(goalsProvider.notifier).updateAmount(goal.id!, goal.currentAmount + amount);
                              _addFundsController.clear();
                              setState(() => _activeAddFundsId = null);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(6)),
                            child: const Text('Add', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => setState(() => _activeAddFundsId = null),
                          child: const Text('×', style: TextStyle(color: AppColors.textMuted, fontSize: 18)),
                        ),
                      ],
                    )
                  : GestureDetector(
                      onTap: () => setState(() => _activeAddFundsId = goal.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentColor.withAlpha(38),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.accentColor.withAlpha(76)),
                        ),
                        child: const Text('+ Añadir', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.accentLight)),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 14),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textMain))),
          Text(value, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
          const SizedBox(width: 4),
          const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textMuted),
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
