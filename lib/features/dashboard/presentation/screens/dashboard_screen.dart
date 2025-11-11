import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../transactions/providers/transaction_provider.dart';
import '../../../cards/providers/card_provider.dart';
import '../widgets/stat_card.dart';
import '../widgets/expense_chart.dart';
import '../widgets/trend_chart.dart';
import '../widgets/upcoming_payments.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  void _initData() {
    Provider.of<TransactionProvider>(context, listen: false).initTransactions();
    Provider.of<CardProvider>(context, listen: false).initCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDashboardContent(),
          _buildTransactionsPlaceholder(),
          _buildMorePlaceholder(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.of(context).pushNamed(AppRoutes.transactions);
          } else if (index == 2) {
            // Show more options
            _showMoreOptions();
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            activeIcon: Icon(Icons.receipt),
            label: 'Transacciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            activeIcon: Icon(Icons.more_horiz),
            label: 'Más',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.addTransaction);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: () async {
        _initData();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message
            Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen Financiero',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tus finanzas personales',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedForegroundLight,
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Stats Grid
            Consumer<TransactionProvider>(
              builder: (context, transactionProvider, child) {
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    StatCard(
                      title: 'Gastos del Mes',
                      value: '\$${transactionProvider.totalExpenses.toStringAsFixed(2)}',
                      icon: Icons.wallet_outlined,
                      trend: '12% vs mes anterior',
                      isPositive: false,
                      color: AppColors.primary,
                    ),
                    StatCard(
                      title: 'Balance',
                      value: '\$${transactionProvider.balance.toStringAsFixed(2)}',
                      icon: Icons.trending_down,
                      trend: '24% del total',
                      isPositive: true,
                      color: AppColors.success,
                    ),
                    StatCard(
                      title: 'Próximo Pago',
                      value: 'Netflix',
                      icon: Icons.calendar_today_outlined,
                      trend: 'en 2 días',
                      isPositive: true,
                      color: AppColors.warning,
                    ),
                    StatCard(
                      title: 'Meta de Ahorro',
                      value: '65%',
                      icon: Icons.savings_outlined,
                      trend: '\$1,300 / \$2,000',
                      isPositive: true,
                      color: AppColors.success,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Charts
            const ExpenseChart(),
            
            const SizedBox(height: 16),
            
            const TrendChart(),

            const SizedBox(height: 24),

            // Upcoming Payments
            const UpcomingPayments(),

            const SizedBox(height: 80), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsPlaceholder() {
    return const Center(
      child: Text('Transacciones'),
    );
  }

  Widget _buildMorePlaceholder() {
    return const Center(
      child: Text('Más opciones'),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Tarjetas'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(AppRoutes.cards);
                },
              ),
              ListTile(
                leading: const Icon(Icons.category),
                title: const Text('Categorías'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(AppRoutes.categories);
                },
              ),
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text('Metas'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(AppRoutes.goals);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Perfil'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(AppRoutes.profile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).pushNamed(AppRoutes.settings);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
