import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_date_picker.dart';
import '../../../shared/widgets/app_dropdown.dart';
import '../../../shared/widgets/app_text_field.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  String _transactionType = AppStrings.expenseType;
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // TODO: Save the transaction to SQLite.

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text(AppStrings.formValidated)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppAppBar(title: AppStrings.transaction),
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
                        // Transaction type
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

                        // Name
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

                        // Amount
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

                        // Date
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

              // Save button
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.screenPadding,
                  AppDimensions.spacingMD,
                  AppDimensions.screenPadding,
                  AppDimensions.spacingXL,
                ),
                child: AppButton(
                  label: AppStrings.save,
                  onPressed: _saveTransaction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
