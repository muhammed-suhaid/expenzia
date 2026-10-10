import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(child: Text(AppStrings.transactionHistory)),
    );
  }
}
