import 'package:expenso/controllers/auth_controller.dart';
import 'package:expenso/core/constants/sizes.dart';
import 'package:expenso/widgets/monthly_expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../core/theme/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return SafeArea(
      child: Obx(() {
        return Padding(
          padding: EdgeInsets.only(top: 25.0.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👋 Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hi, ${AuthController.instance.authUser?.name.toUpperCase() ?? "User"}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // 💳 Today's Expense Card
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultPadding,
                ),
                child: _bigCard(
                  title: "Today's Expense",
                  amount: controller.todayExpense,
                  color: AppColors.expense,
                ),
              ),

              const SizedBox(height: 20),

              // 📊 Lend / Borrow
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultPadding,
                ),
                child: Row(
                  children: [
                    _smallCard(
                      title: "You Will Take",
                      amount: controller.totalTake,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 16),
                    _smallCard(
                      title: "You Will Pay",
                      amount: controller.totalPay,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ⚖ Net Balance
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.defaultPadding,
                ),
                child: _netBalanceCard(controller.netBalance),
              ),
              const SizedBox(height: 24),
              MonthlyExpenseChart(),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // ---------- UI HELPERS ----------

  Widget _bigCard({
    required String title,
    required double amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultPadding),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "₹${amount.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallCard({
    required String title,
    required double amount,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: AppColors.textLight)),
            const SizedBox(height: 6),
            Text(
              "₹${amount.toStringAsFixed(0)}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _netBalanceCard(double net) {
    Color color;
    String text;

    if (net > 0) {
      color = Colors.green;
      text = "Net Profit ₹${net.abs()}";
    } else if (net < 0) {
      color = Colors.red;
      text = "Net Payable ₹${net.abs()}";
    } else {
      color = Colors.grey;
      text = "All Settled";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
}
