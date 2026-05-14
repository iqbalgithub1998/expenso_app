import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── Data Models ────────────────────────────────────────────────────────────────

class TxModel {
  final String title;
  final String subtitle;
  final double amount;
  final String time;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final bool isHighlighted;

  const TxModel({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.isHighlighted = false,
  });
}

class DayGroup {
  final int day;
  final String label;
  final String month;
  final List<TxModel> txs;
  const DayGroup({
    required this.day,
    required this.label,
    required this.month,
    required this.txs,
  });
}

// ── Controller ─────────────────────────────────────────────────────────────────

class CreditCardDetailsController extends GetxController {
  // ── Card active toggle ──────────────────────────────────────────────────────
  final cardActive = true.obs;

  // ── Payment due date (passed from previous screen) ───────────────────────────
  final paymentDueDate = ''.obs;

  CreditCardDetailsController() {
    // Get payment due date from navigation arguments
    final args = Get.arguments;
    if (args != null && args['paymentDueDate'] != null) {
      paymentDueDate.value = args['paymentDueDate'] as String;
    }
  }

  String get nextPaymentDate => getNextPaymentDate(paymentDueDate.value);

  void toggleCard(bool value) => cardActive.value = value;

  // ── Static transaction data ────────────────────────────────────────────────
  static const List<DayGroup> groups = [
    DayGroup(
      day: 24,
      label: 'Today',
      month: 'November 2023',
      txs: [
        TxModel(
          title: 'Luxury Boutique',
          subtitle: 'Apparel & Style',
          amount: -120.00,
          time: '14:20 PM',
          icon: Icons.shopping_bag_outlined,
          iconBg: Color(0xFF1E1530),
          iconColor: Color(0xFFBB86FC),
        ),
        TxModel(
          title: 'Salary Deposit',
          subtitle: 'Tech Corp Inc.',
          amount: 3120.00,
          time: '09:15 AM',
          icon: Icons.account_balance_wallet_outlined,
          iconBg: Color(0xFF0F2318),
          iconColor: Color(0xFF2E9E5C),
        ),
      ],
    ),
    DayGroup(
      day: 23,
      label: 'Yesterday',
      month: 'November 2023',
      txs: [
        TxModel(
          title: 'The Green Bistro',
          subtitle: 'Dining & Drinks',
          amount: -85.50,
          time: '20:45 PM',
          icon: Icons.restaurant_outlined,
          iconBg: Color(0xFF231A0D),
          iconColor: Color(0xFFD97706),
        ),
        TxModel(
          title: 'Delta Air Lines',
          subtitle: 'Vacation Booking',
          amount: -1250.00,
          time: '13:00 PM',
          icon: Icons.flight_takeoff_outlined,
          iconBg: Color(0xFF7C3AED),
          iconColor: Colors.white,
          isHighlighted: true,
        ),
        TxModel(
          title: 'Utilities',
          subtitle: 'Monthly Billing',
          amount: -145.00,
          time: '08:00 AM',
          icon: Icons.bolt_outlined,
          iconBg: Color(0xFF230D0D),
          iconColor: Color(0xFFE53935),
        ),
      ],
    ),
    DayGroup(
      day: 21,
      label: 'Earlier',
      month: 'November 2023',
      txs: [
        TxModel(
          title: 'Shell Station',
          subtitle: 'Transport',
          amount: -65.00,
          time: '17:10 PM',
          icon: Icons.local_gas_station_outlined,
          iconBg: Color(0xFF1A1A24),
          iconColor: Color(0xFF8888AA),
        ),
      ],
    ),
  ];

  // ── Amount helpers (used by view) ──────────────────────────────────────────
  String amountText(TxModel tx) {
    final abs = tx.amount.abs().toStringAsFixed(2);
    return tx.amount >= 0 ? '+\$$abs' : '-\$$abs';
  }

  Color amountColor(TxModel tx) =>
      tx.amount >= 0 ? const Color(0xFF2E9E5C) : const Color(0xFFE53935);

  // ── Next Payment Date Calculation ───────────────────────────────────────────
  String getNextPaymentDate(String dueDateStr) {
    // Extract day from string like "9th", "15th"
    final dayMatch = RegExp(r'(\d+)').firstMatch(dueDateStr);
    if (dayMatch == null) return '--';

    final dueDay = int.tryParse(dayMatch.group(1)!) ?? 9;
    final now = DateTime.now();
    final today = now.day;

    DateTime nextPayment;

    if (today > dueDay) {
      // After due date → next month
      nextPayment = DateTime(now.year, now.month + 1, dueDay);
    } else {
      // On or before due date → this month
      nextPayment = DateTime(now.year, now.month, dueDay);
    }

    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[nextPayment.month - 1]} ${nextPayment.day}';
  }
}
