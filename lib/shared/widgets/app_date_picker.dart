import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_dimensions.dart';
import '../../app/theme/app_text_styles.dart';

class AppDatePicker extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String dateFormat;

  const AppDatePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.dateFormat = 'EEE, dd MMM yyyy',
  });

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      onChanged(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.label.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingSM),
        InkWell(
          onTap: () => _selectDate(context),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
          child: InputDecorator(
            decoration: InputDecoration(
              suffixIcon: const Icon(
                Icons.calendar_month,
                color: AppColors.textSecondary,
                size: 20,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingMD,
                vertical: AppDimensions.spacingMD,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusSM),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
            child: Text(
              DateFormat(dateFormat).format(value),
              style: AppTextStyles.body,
            ),
          ),
        ),
      ],
    );
  }
}
