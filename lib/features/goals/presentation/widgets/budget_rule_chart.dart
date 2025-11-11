import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../config/theme/app_colors.dart';

class BudgetRuleChart extends StatelessWidget {
  const BudgetRuleChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Regla 50/30/20',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Distribución ideal: 50% necesidades, 30% gustos, 20% ahorros',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.mutedForegroundLight,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Distribución Ideal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 150,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 30,
                            sections: [
                              PieChartSectionData(
                                value: 50,
                                title: '50%',
                                color: AppColors.primary,
                                radius: 40,
                              ),
                              PieChartSectionData(
                                value: 30,
                                title: '30%',
                                color: AppColors.accent,
                                radius: 40,
                              ),
                              PieChartSectionData(
                                value: 20,
                                title: '20%',
                                color: AppColors.success,
                                radius: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        'Tu Distribución',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 150,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 30,
                            sections: [
                              PieChartSectionData(
                                value: 55,
                                title: '55%',
                                color: AppColors.primary,
                                radius: 40,
                              ),
                              PieChartSectionData(
                                value: 35,
                                title: '35%',
                                color: AppColors.accent,
                                radius: 40,
                              ),
                              PieChartSectionData(
                                value: 10,
                                title: '10%',
                                color: AppColors.success,
                                radius: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildCategoryBar('Necesidades', 55, 50, AppColors.primary),
            const SizedBox(height: 12),
            _buildCategoryBar('Gustos', 35, 30, AppColors.accent),
            const SizedBox(height: 12),
            _buildCategoryBar('Ahorros', 10, 20, AppColors.success),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBar(String name, int current, int ideal, Color color) {
    final difference = current - ideal;
    final isOver = difference > 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Text('$current% / $ideal%'),
                if (difference != 0) ...[
                  const SizedBox(width: 8),
                  Text(
                    '${isOver ? '+' : ''}$difference%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isOver ? AppColors.error : AppColors.success,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: current / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
