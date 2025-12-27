import 'package:expenso/controllers/expense_controller.dart';
import 'package:expenso/controllers/friend_controller.dart';
import 'package:expenso/core/constants/colors.dart';
import 'package:expenso/screens/dashboard/add_expense_sheet.dart';
import 'package:expenso/screens/dashboard/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../core/theme/app_colors.dart';
import 'home_screen.dart';
import 'expense_screen.dart';
import 'friends_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final expenseController = Get.put(ExpenseController());
  final friendController = Get.put(FriendController());
  final dashboardController = Get.put(DashboardController());

  final pages = [
    const HomeScreen(),
    const ExpenseScreen(),
    FriendsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: pages[dashboardController.currentIndex.value],

        floatingActionButton: Visibility(
          visible: dashboardController.currentIndex.value < 2,
          child: FloatingActionButton(
            backgroundColor: TColors.secondary,
            onPressed: () {
              Get.bottomSheet(
                AddExpenseSheet(),
                isScrollControlled: true,
                backgroundColor: Colors.white,
              );
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: Colors.white,
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home, 0),
                _navItem(Icons.receipt_long, 1),
                // const SizedBox(width: 40), // FAB gap
                _navItem(Icons.people_outline, 2),
                _navItem(Icons.person_outline, 3),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _navItem(IconData icon, int index, {bool disabled = false}) {
    return Obx(() {
      final isActive = dashboardController.currentIndex.value == index;
      return IconButton(
        onPressed: disabled ? null : () => dashboardController.changeTab(index),
        icon: Icon(
          icon,
          size: 28,
          color: isActive ? TColors.secondary : AppColors.textLight,
        ),
      );
    });
  }
}
