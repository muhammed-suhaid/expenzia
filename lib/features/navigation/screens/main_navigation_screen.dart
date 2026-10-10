import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../features/credit/screens/credit_screen.dart';
import '../../../features/dashboard/screens/dashboard_screen.dart';
import '../../../features/profile/screens/profile_screen.dart';
import '../../../shared/widgets/app_app_bar.dart';
import '../../transactions/screens/transaction_screen.dart';
import '../../transactions/screens/transaction_history_screen.dart';
import '../../../shared/widgets/app_bottom_navigation.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    TransactionHistoryScreen(),
    CreditScreen(),
    ProfileScreen(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _openAddExpense() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const TransactionScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final String? appBarTitle = switch (_currentIndex) {
      1 => AppStrings.transactions,
      2 => AppStrings.credit,
      3 => AppStrings.profile,
      _ => null,
    };

    return Scaffold(
      appBar: appBarTitle == null
          ? null
          : AppAppBar(title: appBarTitle, showBackButton: false),
      body: IndexedStack(index: _currentIndex, children: _screens),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: _openAddExpense,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shape: const CircleBorder(
            side: BorderSide(color: AppColors.background, width: 5),
          ),
          child: const Icon(Icons.add, size: 32),
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        onAddPressed: _openAddExpense,
      ),
    );
  }
}
