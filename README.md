# Expenzia – Expense Management App

## Features

### Completed

- **Dashboard UI** – Displays total balance, income, expenses, daily average, weekly spending, and recent transactions.
- **SQLite Database** – Stores transactions locally on the device.
- **Add Transactions** – Add income or expense records with a name, amount, type, and date.
- **Transaction History** – Retrieve and display saved transactions from SQLite.
- **Edit Transactions** – Update existing transaction details.
- **Delete Transactions** – Delete transactions after confirmation.
- **Pull to Refresh** – Refresh transaction history and dashboard data.
- **Form Validation** – Validate transaction names and amounts.
- **Profile Screen UI** – Display the profile name and provide a name-editing dialog.
- **Clear Storage** – Clear transaction records from the local database.
- **Reusable Widgets** – Use shared components such as buttons, text fields, dropdowns, date pickers, and transaction tiles.

### Pending Improvements

- **Credit Screen** – The credit screen is not yet completed.
- **Dashboard Refactoring** – Split the dashboard into smaller, reusable widget files to improve readability and maintainability.
- **Profile Refactoring** – Separate profile UI components into reusable widgets where appropriate.
- **Profile Persistence** – Save profile changes so they remain available after restarting the app.
- **Profile Photo** – Implement profile image selection.

## Tech Stack

- Flutter
- Dart
- SQLite (`sqflite`)
- `path`
- `intl`

## Project Structure

```text
lib/
├── app/
│   └── theme/
├── core/
│   ├── constants/
│   └── utils/
├── features/
│   ├── dashboard/
│   │   ├── screens/
│   │   └── widgets/
│   ├── navigation/
│   ├── profile/
│   │   ├── screens/
│   │   └── widgets/
│   ├── credit/
│   │   ├── screens/
│   │   └── widgets/
│   └── transactions/
│       ├── model/
│       ├── screens/
│       ├── services/
│       └── widgets/
└── shared/
    └── widgets/
```

The project follows a feature-based structure, with shared UI components maintained separately for reuse across screens.

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or Visual Studio Code

### Installation

1. Clone the repository:

   ```bash
   git clone <your-repository-url>
   ```

2. Open the project directory:

   ```bash
   cd expenzia
   ```

3. Install dependencies:

   ```bash
   flutter pub get
   ```

4. Run the application:

   ```bash
   flutter run
   ```

## Database Operations

The SQLite database supports:

- Creating transactions
- Retrieving saved transactions
- Updating existing transactions
- Deleting individual transactions
- Clearing all transaction records

Transaction data is stored locally on the device.



