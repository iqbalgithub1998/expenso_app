import 'package:expenso/core/constants/sizes.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/expense_controller.dart';
import '../core/theme/app_colors.dart';

class MonthlyExpenseChart extends StatelessWidget {
  MonthlyExpenseChart({super.key});

  final expenseController = Get.find<ExpenseController>();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Obx(() {
      final data = expenseController.getMonthlyExpenseMap(now);

      if (data.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(child: Text("No expenses this month")),
        );
      }

      // Get days in current month
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

      // Create spots for all days with data
      final spots =
          data.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList()
            ..sort((a, b) => a.x.compareTo(b.x));

      // Calculate max values for scaling
      final maxExpense = data.values.reduce((a, b) => a > b ? a : b);
      final maxY = (maxExpense * 1.2).ceilToDouble();

      return Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 250,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: maxY / 5,
                      // getDrawingHorizontalLine: (value) {
                      //   return FlLine(
                      //     color: Colors.grey.withOpacity(0.2),
                      //     strokeWidth: 1,
                      //   );
                      // },
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: Colors.grey.withOpacity(0.3)),
                        bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                      ),
                    ),
                    minX: 0,
                    maxX: daysInMonth.toDouble(),
                    minY: 0,
                    maxY: maxY,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        // axisNameWidget: const Padding(
                        //   padding: EdgeInsets.only(bottom: 8),
                        //   child: Text(
                        //     "₹",
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //       color: Colors.grey,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          interval: maxY / 5,
                          getTitlesWidget: (value, meta) {
                            if (value == 0) return const SizedBox.shrink();
                            return Text(
                              value >= 1000
                                  ? '${(value / 1000).toStringAsFixed(1)}k'
                                  : value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        axisNameWidget: Text(
                          "Day",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: daysInMonth > 15 ? 5 : 2,
                          getTitlesWidget: (value, meta) {
                            if (value == 0 || value > daysInMonth) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              'Day ${spot.x.toInt()}\n₹${spot.y.toStringAsFixed(0)}',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        isCurved: true,
                        color: AppColors.expense,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: AppColors.expense,
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [
                              AppColors.expense.withOpacity(0.3),
                              AppColors.expense.withOpacity(0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
