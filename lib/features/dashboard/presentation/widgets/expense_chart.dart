import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../config/theme/app_colors.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gastos por Categoría',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: 450,
                      title: 'Alimentación',
                      color: AppColors.primary,
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: 300,
                      title: 'Transporte',
                      color: AppColors.success,
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: 800,
                      title: 'Vivienda',
                      color: AppColors.warning,
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: 200,
                      title: 'Ocio',
                      color: AppColors.accent,
                      radius: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}