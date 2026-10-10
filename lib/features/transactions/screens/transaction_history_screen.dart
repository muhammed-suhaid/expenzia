import 'package:expenzia/features/transactions/screens/edit_transaction_screen.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../model/transaction_model.dart';
import '../widgets/transaction_tile.dart';
import '../services/transaction_database.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  bool _isLoading = true;
  String? _errorMessage;
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _confirmDelete(TransactionModel transaction) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.deleteExpenseTitle),
        content: Text(
          '${AppStrings.deleteExpenseMessage}\n\n${transaction.title}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              AppStrings.delete,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      final deletedRows = await TransactionDatabase.instance.delete(
        transaction.id!,
      );

      if (!mounted) return;

      if (deletedRows == 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Transaction not found.')));
        await _loadTransactions();
        return;
      }

      await _loadTransactions();

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.expenseDeleted)));
    } catch (error, stackTrace) {
      debugPrint('Failed to delete transaction: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.databaseError)));
    }
  }

  Future<void> _loadTransactions() async {
    if (!mounted) return;

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
      debugPrint('Failed to load transactions: $error');
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
                SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_errorMessage!, textAlign: TextAlign.center),
                        TextButton(
                          onPressed: _loadTransactions,
                          child: const Text(AppStrings.retry),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : _transactions.isEmpty
          ? ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 300,
                  child: Center(child: Text(AppStrings.noTransactions)),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (_, _) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final transaction = _transactions[index];

                return TransactionTile(
                  title: transaction.title,
                  date: transaction.date,
                  amount: transaction.amount,
                  isIncome: transaction.isIncome,
                  showActions: true,
                  onEdit: () async {
                    final updated = await Navigator.of(context).push<bool>(
                      MaterialPageRoute<bool>(
                        builder: (_) => EditTransactionScreen(
                          transactionId: transaction.id!,
                          name: transaction.title,
                          amount: transaction.amount,
                          type: transaction.type,
                          date: transaction.date,
                        ),
                      ),
                    );

                    if (updated == true) {
                      await _loadTransactions();
                    }
                  },
                  onDelete: () => _confirmDelete(transaction),
                );
              },
            ),
    );
  }
}
