class DashboardSummary {
  final double totalIncome;
  final double totalExpenses;
  final double balance;
  final Map<String, double> expensesByCategory;
  final List<TransactionModel> recentTransactions;
  
  DashboardSummary({
    required this.totalIncome,
    required this.totalExpenses,
    required this.balance,
    required this.expensesByCategory,
    required this.recentTransactions,
  });
}