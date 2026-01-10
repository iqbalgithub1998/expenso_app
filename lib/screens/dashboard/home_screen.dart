// import 'package:expenso/controllers/auth_controller.dart';
// import 'package:expenso/core/constants/sizes.dart';
// import 'package:expenso/widgets/monthly_expense_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../controllers/dashboard_controller.dart';
// import '../../core/theme/app_colors.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<DashboardController>();

//     return SafeArea(
//       child: Obx(() {
//         return Padding(
//           padding: EdgeInsets.only(top: 25.0.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 👋 Header
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: TSizes.defaultPadding,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Hi, ${AuthController.instance.authUser?.name.toUpperCase() ?? "User"}",
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 16.h),

//               // 💳 Today's Expense Card
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: TSizes.defaultPadding,
//                 ),
//                 child: _bigCard(
//                   title: "Today's Expense",
//                   amount: controller.todayExpense,
//                   color: AppColors.expense,
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // 📊 Lend / Borrow
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: TSizes.defaultPadding,
//                 ),
//                 child: Row(
//                   children: [
//                     _smallCard(
//                       title: "You Will Take",
//                       amount: controller.totalTake,
//                       color: Colors.green,
//                     ),
//                     const SizedBox(width: 16),
//                     _smallCard(
//                       title: "You Will Pay",
//                       amount: controller.totalPay,
//                       color: Colors.red,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // ⚖ Net Balance
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: TSizes.defaultPadding,
//                 ),
//                 child: _netBalanceCard(controller.netBalance),
//               ),
//               const SizedBox(height: 24),
//               MonthlyExpenseChart(),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       }),
//     );
//   }

//   // ---------- UI HELPERS ----------

//   Widget _bigCard({
//     required String title,
//     required double amount,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(TSizes.defaultPadding),
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(24),
//         border: Border.all(color: color.withOpacity(0.4)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: TextStyle(color: color)),
//           const SizedBox(height: 8),
//           Align(
//             alignment: Alignment.bottomRight,
//             child: Text(
//               "₹${amount.toStringAsFixed(0)}",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _smallCard({
//     required String title,
//     required double amount,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColors.card,
//           borderRadius: BorderRadius.circular(18),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title, style: const TextStyle(color: AppColors.textLight)),
//             const SizedBox(height: 6),
//             Text(
//               "₹${amount.toStringAsFixed(0)}",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _netBalanceCard(double net) {
//     Color color;
//     String text;

//     if (net > 0) {
//       color = Colors.green;
//       text = "Net Profit ₹${net.abs()}";
//     } else if (net < 0) {
//       color = Colors.red;
//       text = "Net Payable ₹${net.abs()}";
//     } else {
//       color = Colors.grey;
//       text = "All Settled";
//     }

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: color.withOpacity(0.4)),
//       ),
//       child: Center(
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: color,
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:expenso/controllers/auth_controller.dart';
import 'package:expenso/core/constants/sizes.dart';
import 'package:expenso/widgets/monthly_expense_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../core/theme/app_colors.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();

    return SafeArea(
      child: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👋 Header with greeting and date
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AuthController.instance.authUser?.name ?? "User",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEEE, MMMM d').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // 💳 Today's & Monthly Expense Cards
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _expenseCard(
                          title: "Today",
                          amount: controller.todayExpense,
                          color: AppColors.expense,
                          icon: Icons.today,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _expenseCard(
                          title: "This Month",
                          amount: controller.monthlyExpense,
                          color: Colors.deepPurple,
                          icon: Icons.calendar_month,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 📊 Balance Overview Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Balance Overview",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Net Balance Card
                      _netBalanceCard(controller.netBalance),

                      const SizedBox(height: 12),

                      // Lend / Borrow Cards
                      Row(
                        children: [
                          Expanded(
                            child: _balanceCard(
                              title: "You'll Get",
                              amount: controller.totalTake,
                              color: AppColors.lend,
                              icon: Icons.arrow_downward,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _balanceCard(
                              title: "You Owe",
                              amount: controller.totalPay,
                              color: AppColors.borrow,
                              icon: Icons.arrow_upward,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 📈 Monthly Expense Chart
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.defaultPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Expense Trends",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // const SizedBox(height: 12),
                      MonthlyExpenseChart(),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ---------- UI HELPERS ----------

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _expenseCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "₹${amount.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _balanceCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "₹${amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _netBalanceCard(double net) {
    Color color;
    String label;
    IconData icon;

    if (net > 0) {
      color = AppColors.lend;
      label = "Net Balance";
      icon = Icons.trending_up;
    } else if (net < 0) {
      color = AppColors.borrow;
      label = "Net Balance";
      icon = Icons.trending_down;
    } else {
      color = Colors.green;
      label = "All Settled";
      icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    net == 0 ? "₹0" : "₹${net.abs().toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (net != 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                net > 0 ? "Profit" : "Payable",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
