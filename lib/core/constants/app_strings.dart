class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'Expenzia';

  // Splash
  static const String splashAppName = appName;

  // Common actions
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String confirm = 'Confirm';
  static const String retry = 'Try Again';
  static const String clear = 'Clear';
  static const String seeAll = 'See all';
  static const String getStarted = 'Get Started';

  // Navigation
  static const String home = 'Home';
  static const String transactions = 'Transactions';
  static const String addExpense = 'Add Expense';
  static const String credit = 'Credit';
  static const String profile = 'Profile';

  // Onboarding
  static const String onboardingTitle = 'spend smarter\nsave more'; 


  // Dashboard
  static const String greeting = 'Good afternoon,';
  static const String totalBalance = 'Total Balance';
  static const String income = 'Income';
  static const String expenses = 'Expenses';
  static const String dailyAverage = 'Daily Average';
  static const String weekly = 'Weekly';
  static const String transactionHistory = 'Transaction History';

  // Expense form
  static const String editTransaction = 'Edit Transaction';
  static const String transactionType = 'Transaction Type';
  static const String expenseTitle = 'Expense Title';
  static const String amount = 'Amount';
  static const String category = 'Category';
  static const String date = 'Date';
  static const String description = 'Description';
  static const String enterTitle = 'Enter expense title';
  static const String enterAmount = 'Enter amount';
  static const String selectCategory = 'Select category';
  static const String selectDate = 'Select date';
  static const String optionalDescription = 'Description (optional)';

  // Expense categories
  static const String food = 'Food';
  static const String transport = 'Transport';
  static const String shopping = 'Shopping';
  static const String subscriptions = 'Subscriptions';
  static const String bills = 'Bills';
  static const String entertainment = 'Entertainment';
  static const String health = 'Health';
  static const String other = 'Other';

  // Transaction types
  static const String expenseType = 'Expense';
  static const String incomeType = 'Income';

  // Credit
  static const String creditType = 'Credit Type';
  static const String to = 'To';
  static const String planType = 'Plan Type';
  static const String monthly = 'Monthly';
  static const String oneTime = 'One-Time';
  static const String yourSavedLists = 'Your Saved Lists';

  // Profile
  static const String clearStorage = 'Clear Storage';
  static const String editProfile = 'Edit Profile';

  // Validation
  static const String requiredField = 'This field is required.';
  static const String invalidAmount = 'Enter a valid amount greater than zero.';
  static const String titleRequired = 'Please enter a title.';
  static const String categoryRequired = 'Please select a category.';
  static const String dateRequired = 'Please select a date.';

  // Dialogs
  static const String deleteExpenseTitle = 'Delete Expense';
  static const String deleteExpenseMessage =
      'Are you sure you want to delete this expense?';
  static const String clearStorageTitle = 'Clear Storage';
  static const String clearStorageMessage =
      'Are you sure you want to clear all saved data?';

  // Empty states
  static const String noExpenses = 'No expenses yet';
  static const String noExpensesDescription =
      'Add your first expense to get started.';
  static const String noTransactions = 'No transactions found';

  // Feedback
  static const String expenseSaved = 'Expense saved successfully.';
  static const String expenseUpdated = 'Expense updated successfully.';
  static const String expenseDeleted = 'Expense deleted successfully.';
  static const String genericError = 'Something went wrong. Please try again.';
  static const String databaseError =
      'Unable to access saved data. Please try again.';
}
