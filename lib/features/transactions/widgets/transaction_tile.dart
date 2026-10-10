import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final DateTime date;
  final double amount;
  final bool isIncome;
  final bool showActions;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isIncome,
    this.showActions = false,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final amountColor = isIncome ? AppColors.success : AppColors.error;

    final amountText =
        '${isIncome ? '+' : '-'} ₹ ${NumberFormat('#,##0.00').format(amount.abs())}';

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMD,
          vertical: AppDimensions.spacingSM,
        ),
        child: Row(
          children: [
            // Transaction name and date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(date),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppDimensions.spacingSM),

            // Amount
            Text(
              amountText,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: amountColor,
              ),
            ),

            // Edit and delete actions
            if (showActions) ...[
              const SizedBox(width: AppDimensions.spacingSM),
              _ActionButton(
                icon: Icons.edit,
                backgroundColor: AppColors.surface,
                iconColor: AppColors.textPrimary,
                onPressed: onEdit,
              ),
              const SizedBox(width: 2),
              _ActionButton(
                icon: Icons.delete,
                backgroundColor: AppColors.error,
                iconColor: Colors.white,
                onPressed: onDelete,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDay = DateTime(value.year, value.month, value.day);

    if (transactionDay == today) {
      return 'Today';
    }

    if (transactionDay == yesterday) {
      return 'Yesterday';
    }

    return DateFormat('MMM d, yyyy').format(value);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 32,
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onPressed,
          child: Icon(icon, size: 16, color: iconColor),
        ),
      ),
    );
  }
}
