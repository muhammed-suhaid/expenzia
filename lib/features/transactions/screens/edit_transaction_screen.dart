import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_date_picker.dart';
import '../../../shared/widgets/app_dropdown.dart';
import '../../../shared/widgets/app_text_field.dart';

class EditTransactionScreen extends StatefulWidget {
  final int transactionId;
  final String name;
  final double amount;
  final String type;
  final DateTime date;

  const EditTransactionScreen({
    super.key,
    required this.transactionId,
    required this.name,
    required this.amount,
    required this.type,
    required this.date,
  });

  @override
  State<EditTransactionScreen> createState() => _EditTransactionScreenState();
}

class _EditTransactionScreenState extends State<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _amountController;

  late String _transactionType;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.name);
    _amountController = TextEditingController(
      text: widget.amount.toStringAsFixed(2),
    );

    _transactionType = widget.type;
    _selectedDate = widget.date;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _updateTransaction() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || !amount.isFinite || amount <= 0) return;

    // TODO: Update this transaction in SQLite using widget.transactionId.
    // Values to update:
    // name, amount, _transactionType, _selectedDate.

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AppStrings.formValidated)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.editTransaction),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.screenPadding),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.spacingLG),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppDropdown<String>(
                          label: AppStrings.transactionType,
                          value: _transactionType,
                          items: const [
                            DropdownMenuItem(
                              value: AppStrings.expenseType,
                              child: Text(AppStrings.expenseType),
                            ),
                            DropdownMenuItem(
                              value: AppStrings.incomeType,
                              child: Text(AppStrings.incomeType),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;

                            setState(() {
                              _transactionType = value;
                            });
                          },
                        ),
                        const SizedBox(height: AppDimensions.spacingLG),
                        AppTextField(
                          label: AppStrings.name,
                          hintText: AppStrings.enterName,
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.nameRequired;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppDimensions.spacingLG),
                        AppTextField(
                          label: AppStrings.amount,
                          hintText: AppStrings.enterAmount,
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          prefix: const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Center(
                              widthFactor: 1,
                              child: Text(
                                AppStrings.currencySymbol,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          suffix: TextButton(
                            onPressed: _amountController.clear,
                            child: const Text(
                              AppStrings.clear,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return AppStrings.amountRequired;
                            }

                            final amount = double.tryParse(value.trim());

                            if (amount == null ||
                                !amount.isFinite ||
                                amount <= 0) {
                              return AppStrings.invalidAmount;
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: AppDimensions.spacingLG),
                        AppDatePicker(
                          label: AppStrings.date,
                          value: _selectedDate,
                          onChanged: (date) {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.screenPadding,
                  AppDimensions.spacingMD,
                  AppDimensions.screenPadding,
                  AppDimensions.spacingXL,
                ),
                child: AppButton(
                  label: AppStrings.save,
                  onPressed: _updateTransaction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
