import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: Center(child: Text(AppStrings.totalBalance)));
  }
}
