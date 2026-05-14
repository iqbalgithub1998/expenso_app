import 'package:expenso/controllers/navigation_controller.dart';
import 'package:expenso/screens/dashboard/credit_cards.dart';
import 'package:expenso/screens/dashboard/expense_screen.dart';
import 'package:expenso/screens/dashboard/home_screen.dart';
import 'package:expenso/screens/dashboard/lend_borrow.dart';
import 'package:expenso/screens/dashboard/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigationController>();

    final screens = [
      HomeScreen(),
      ExpenseScreen(),
      LendBorrowScreen(),
      CreditCardsScreen(),
      const ProfileScreen(),
    ];

    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeIndex,
          backgroundColor: const Color(0xFF1A1A1A),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2E9E5C),
          unselectedItemColor: const Color(0xFF666666),
          selectedFontSize: 10.sp,
          unselectedFontSize: 10.sp,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Expenses',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.handshake_outlined),
              label: 'Lend/Borrow',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.credit_card_outlined),
              label: 'Cards',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}
