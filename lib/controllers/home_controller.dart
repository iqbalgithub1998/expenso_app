import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // ── Observables ─────────────────────────────────────────────────────────────
  final totalExpense = '\$14,285.60'.obs;
  final pendingLend = '\$2,400'.obs;
  final totalBorrowed = '\$840'.obs;
  final selectedPeriod = 'Last 6 Months'.obs;
  final hasNotification = true.obs;
  final userName = 'Alex'.obs;

  final transactions = <Map<String, dynamic>>[
    {
      'icon': Icons.shopping_cart_outlined,
      'iconColor': const Color(0xFFFFB74D),
      'bgColor': const Color(0xFF1E1A12),
      'title': 'Supermarket',
      'subtitle': 'Grocery & Staples',
      'amount': '-\$145.20',
      'isDebit': true,
      'date': 'Today, 2:40 PM',
    },
    {
      'icon': Icons.tv_outlined,
      'iconColor': const Color(0xFFBB86FC),
      'bgColor': const Color(0xFF1E1B2E),
      'title': 'StreamX Inc.',
      'subtitle': 'Entertainment',
      'amount': '-\$14.99',
      'isDebit': true,
      'date': 'Yesterday',
    },
    {
      'icon': Icons.account_balance_rounded,
      'iconColor': const Color(0xFF00E676),
      'bgColor': const Color(0xFF0D1F15),
      'title': 'Salary Deposit',
      'subtitle': 'Direct Credit',
      'amount': '+\$4,200.00',
      'isDebit': false,
      'date': 'Oct 28, 2023',
    },
  ].obs;

  // ── Animation ────────────────────────────────────────────────────────────────
  late final AnimationController animController;
  late final Animation<double> fadeAnim;
  late final Animation<Offset> slideAnim;

  @override
  void onInit() {
    super.onInit();
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    fadeAnim = CurvedAnimation(parent: animController, curve: Curves.easeOut);
    slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: animController, curve: Curves.easeOutCubic),
        );

    animController.forward();
  }

  @override
  void onClose() {
    animController.dispose();
    super.onClose();
  }

  // ── Actions ──────────────────────────────────────────────────────────────────
  void onPeriodTap() => Get.snackbar('Period', 'Change period');
  void onSearchTap() => Get.snackbar('Search', 'Open search');
  void onNotificationTap() => hasNotification.value = false;
  void onViewMoreTap() => Get.snackbar('Transactions', 'View all');
  void onAddExpenseTap() => Get.snackbar('Add', 'Add new expense');
  void onFilterTap() => Get.snackbar('Filter', 'Filter transactions');
}
