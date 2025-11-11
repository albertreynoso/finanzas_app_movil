import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../data/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final color = isIncome ? AppColors.success : AppColors.error;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getCategoryIcon(transaction.category),
            color: color,
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getCategoryLabel(transaction.category),
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              DateFormatter.formatDate(transaction.date),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'}${CurrencyFormatter.format(transaction.amount)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (transaction.isRecurring)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.repeat, size: 10, color: AppColors.accent),
                    SizedBox(width: 2),
                    Text(
                      'Recurrente',
                      style: TextStyle(fontSize: 10, color: AppColors.accent),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    final icons = {
      'alimentacion': Icons.restaurant,
      'transporte': Icons.directions_car,
      'vivienda': Icons.home,
      'ocio': Icons.sports_esports,
      'salud': Icons.local_hospital,
      'educacion': Icons.school,
      'servicios': Icons.lightbulb,
      'salario': Icons.work,
      'freelance': Icons.computer,
      'inversion': Icons.trending_up,
      'regalo': Icons.card_giftcard,
      'venta': Icons.sell,
      'reembolso': Icons.money,
    };
    return icons[category] ?? Icons.category;
  }

  String _getCategoryLabel(String category) {
    final labels = {
      'alimentacion': 'Alimentación',
      'transporte': 'Transporte',
      'vivienda': 'Vivienda',
      'ocio': 'Ocio',
      'salud': 'Salud',
      'educacion': 'Educación',
      'servicios': 'Servicios',
      'salario': 'Salario',
      'freelance': 'Freelance',
      'inversion': 'Inversión',
      'regalo': 'Regalo',
      'venta': 'Venta',
      'reembolso': 'Reembolso',
      'otros': 'Otros',
    };
    return labels[category] ?? category;
  }
}