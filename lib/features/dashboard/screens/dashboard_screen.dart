import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../transactions/model/transaction_model.dart';
import '../../transactions/services/transaction_database.dart';
import '../../transactions/widgets/transaction_tile.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback? onSeeAll;

  const DashboardScreen({super.key, this.onSeeAll});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  static final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 2,
  );

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> refreshDashboard() => _loadTransactions();

  Future<void> _loadTransactions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final transactions = await TransactionDatabase.instance.getAll();

      if (!mounted) return;

      setState(() {
        _transactions = transactions;
      });
    } catch (error, stackTrace) {
      debugPrint('Dashboard loading failed: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _errorMessage = AppStrings.databaseError;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final income = _transactions
        .where((t) => t.isIncome)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final expenses = _transactions
        .where((t) => !t.isIncome)
        .fold<double>(0, (sum, t) => sum + t.amount);

    final totalBalance = income - expenses;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekStart = today.subtract(
      Duration(days: today.weekday - DateTime.monday),
    );

    final weeklyExpenses = _transactions
        .where(
          (t) =>
              !t.isIncome &&
              !t.date.isBefore(weekStart) &&
              t.date.isBefore(today.add(const Duration(days: 1))),
        )
        .fold<double>(0, (sum, t) => sum + t.amount);

    final dailyAverage = weeklyExpenses / 7;

    return RefreshIndicator(
      onRefresh: _loadTransactions,
      child: _isLoading
          ? ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
            )
          : _errorMessage != null
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 150),
                Center(child: Text(_errorMessage!)),
                Center(
                  child: TextButton(
                    onPressed: _loadTransactions,
                    child: const Text(AppStrings.retry),
                  ),
                ),
              ],
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(AppDimensions.screenPadding),
              children: [
                _buildGreeting(),
                const SizedBox(height: AppDimensions.spacingLG),

                _buildBalanceCard(
                  totalBalance: totalBalance,
                  income: income,
                  expenses: expenses,
                ),

                const SizedBox(height: AppDimensions.spacingLG),

                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        AppStrings.dailyAverage,
                        dailyAverage,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacingSM),
                    Expanded(
                      child: _buildSummaryCard(
                        AppStrings.weekly,
                        weeklyExpenses,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.spacingXL),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.transactionHistory,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onSeeAll,
                      child: const Text(AppStrings.seeAll),
                    ),
                  ],
                ),

                if (_transactions.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(AppDimensions.spacingLG),
                    child: Center(child: Text(AppStrings.noTransactions)),
                  )
                else
                  ..._transactions
                      .take(3)
                      .map(
                        (transaction) => TransactionTile(
                          title: transaction.title,
                          date: transaction.date,
                          amount: transaction.amount,
                          isIncome: transaction.isIncome,
                        ),
                      ),

                const SizedBox(height: AppDimensions.spacingXL),
              ],
            ),
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;

    final greeting = hour < 12
        ? 'Good morning,'
        : hour < 17
        ? 'Good afternoon,'
        : 'Good evening,';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
        ),
        const SizedBox(height: 3),
        const Text(
          'Suhaid Muhammed',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard({
    required double totalBalance,
    required double income,
    required double expenses,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacingLG),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF388A84), Color(0xFF287C76)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.totalBalance,
            style: TextStyle(fontSize: 12, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            _currencyFormat.format(totalBalance),
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingLG),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  Icons.arrow_downward,
                  AppStrings.income,
                  income,
                ),
              ),
              Expanded(
                child: _buildBalanceItem(
                  Icons.arrow_upward,
                  AppStrings.expenses,
                  expenses,
                  alignEnd: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(
    IconData icon,
    String label,
    double amount, {
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: alignEnd
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 9,
              backgroundColor: Colors.white.withValues(alpha: 0.20),
              child: Icon(icon, size: 12, color: Colors.white),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _currencyFormat.format(amount),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            letterSpacing: 0.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSM),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingSM,
            vertical: AppDimensions.spacingMD,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            border: Border.all(color: AppColors.border),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _currencyFormat.format(amount),
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
