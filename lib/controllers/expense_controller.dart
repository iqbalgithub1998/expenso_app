import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── Data model ────────────────────────────────────────────────────────────────
class TransactionModel {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String amount;
  final bool isDebit;
  final String time;
  final DateTime date;

  const TransactionModel({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isDebit,
    required this.time,
    required this.date,
  });
}

// ── Controller ────────────────────────────────────────────────────────────────
class ExpenseController extends GetxController {
  // ── Selected month/year ──────────────────────────────────────────────────────
  final selectedDate = DateTime(2023, 11).obs;

  // ── Pagination ───────────────────────────────────────────────────────────────
  static const int _pageSize = 4;
  final currentPage = 0.obs;

  // ── All transactions (in a real app: fetched per month) ──────────────────────
  final _allTransactions = <TransactionModel>[
    TransactionModel(
      icon: Icons.shopping_bag_outlined,
      iconColor: const Color(0xFFBB86FC),
      bgColor: const Color(0xFF1E1B2E),
      title: 'Luxury Boutique',
      subtitle: 'Apparel & Style',
      amount: '-\$120.00',
      isDebit: true,
      time: '14:20 PM',
      date: DateTime(2023, 11, 24),
    ),
    TransactionModel(
      icon: Icons.account_balance_rounded,
      iconColor: const Color(0xFF00E676),
      bgColor: const Color(0xFF0D1F15),
      title: 'Salary Deposit',
      subtitle: 'Tech Corp Inc.',
      amount: '+\$3,120.00',
      isDebit: false,
      time: '09:15 AM',
      date: DateTime(2023, 11, 24),
    ),
    TransactionModel(
      icon: Icons.restaurant_outlined,
      iconColor: const Color(0xFFFFB74D),
      bgColor: const Color(0xFF1E1A12),
      title: 'The Green Bistro',
      subtitle: 'Dining & Drinks',
      amount: '-\$85.50',
      isDebit: true,
      time: '20:45 PM',
      date: DateTime(2023, 11, 23),
    ),
    TransactionModel(
      icon: Icons.bolt,
      iconColor: const Color(0xFFFF5252),
      bgColor: const Color(0xFF1F1212),
      title: 'Utilities',
      subtitle: 'Monthly Billing',
      amount: '-\$145.00',
      isDebit: true,
      time: '08:00 AM',
      date: DateTime(2023, 11, 23),
    ),
    TransactionModel(
      icon: Icons.local_gas_station_outlined,
      iconColor: const Color(0xFF9CA3AF),
      bgColor: const Color(0xFF1A1D26),
      title: 'Shell Station',
      subtitle: 'Transport',
      amount: '-\$65.00',
      isDebit: true,
      time: '17:10 PM',
      date: DateTime(2023, 11, 22),
    ),
    TransactionModel(
      icon: Icons.tv_outlined,
      iconColor: const Color(0xFFBB86FC),
      bgColor: const Color(0xFF1E1B2E),
      title: 'StreamX Inc.',
      subtitle: 'Entertainment',
      amount: '-\$14.99',
      isDebit: true,
      time: '12:00 PM',
      date: DateTime(2023, 11, 21),
    ),
    TransactionModel(
      icon: Icons.shopping_cart_outlined,
      iconColor: const Color(0xFFFFB74D),
      bgColor: const Color(0xFF1E1A12),
      title: 'Supermarket',
      subtitle: 'Grocery & Staples',
      amount: '-\$145.20',
      isDebit: true,
      time: '10:30 AM',
      date: DateTime(2023, 11, 20),
    ),
    TransactionModel(
      icon: Icons.medical_services_outlined,
      iconColor: const Color(0xFFFF5252),
      bgColor: const Color(0xFF1F1212),
      title: 'City Pharmacy',
      subtitle: 'Health & Medical',
      amount: '-\$38.75',
      isDebit: true,
      time: '15:45 PM',
      date: DateTime(2023, 11, 19),
    ),
    // October transactions
    TransactionModel(
      icon: Icons.flight_outlined,
      iconColor: const Color(0xFF00E676),
      bgColor: const Color(0xFF0D1F15),
      title: 'Air Travel',
      subtitle: 'Business Trip',
      amount: '-\$520.00',
      isDebit: true,
      time: '06:00 AM',
      date: DateTime(2023, 10, 28),
    ),
    TransactionModel(
      icon: Icons.account_balance_rounded,
      iconColor: const Color(0xFF00E676),
      bgColor: const Color(0xFF0D1F15),
      title: 'Salary Deposit',
      subtitle: 'Tech Corp Inc.',
      amount: '+\$3,120.00',
      isDebit: false,
      time: '09:00 AM',
      date: DateTime(2023, 10, 27),
    ),
  ];

  // ── Filtered by selected month ────────────────────────────────────────────────
  List<TransactionModel> get filteredTransactions => _allTransactions
      .where(
        (t) =>
            t.date.year == selectedDate.value.year &&
            t.date.month == selectedDate.value.month,
      )
      .toList();

  // ── Grouped by day ────────────────────────────────────────────────────────────
  Map<DateTime, List<TransactionModel>> get groupedByDay {
    final map = <DateTime, List<TransactionModel>>{};
    for (final t in filteredTransactions) {
      final key = DateTime(t.date.year, t.date.month, t.date.day);
      map.putIfAbsent(key, () => []).add(t);
    }
    return Map.fromEntries(
      map.entries.toList()..sort((a, b) => b.key.compareTo(a.key)),
    );
  }

  // ── Paginated days ────────────────────────────────────────────────────────────
  List<MapEntry<DateTime, List<TransactionModel>>> get allDayEntries =>
      groupedByDay.entries.toList();

  List<MapEntry<DateTime, List<TransactionModel>>> get pagedDayEntries {
    final end = ((currentPage.value + 1) * _pageSize).clamp(
      0,
      allDayEntries.length,
    );
    return allDayEntries.sublist(0, end);
  }

  bool get hasMore => pagedDayEntries.length < allDayEntries.length;

  void loadMore() {
    if (hasMore) currentPage.value++;
  }

  // ── Summary stats for selected month ─────────────────────────────────────────
  String get totalExpense {
    final total = filteredTransactions.where((t) => t.isDebit).fold<double>(0, (
      sum,
      t,
    ) {
      final raw = t.amount.replaceAll(RegExp(r'[^\d.]'), '');
      return sum + (double.tryParse(raw) ?? 0);
    });
    return '\$${total.toStringAsFixed(0)}';
  }

  String get dailyAvg {
    final debits = filteredTransactions.where((t) => t.isDebit).toList();
    if (debits.isEmpty) return '\$0';
    final total = debits.fold<double>(
      0,
      (s, t) =>
          s +
          (double.tryParse(t.amount.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0),
    );
    final days = groupedByDay.keys.length;
    return '\$${(total / (days == 0 ? 1 : days)).toStringAsFixed(0)}';
  }

  String get topCategory {
    final cats = <String, double>{};
    for (final t in filteredTransactions.where((t) => t.isDebit)) {
      cats.update(
        t.subtitle,
        (v) =>
            v +
            (double.tryParse(t.amount.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0),
        ifAbsent: () =>
            double.tryParse(t.amount.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0,
      );
    }
    if (cats.isEmpty) return 'N/A';
    return cats.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  // ── Month navigation ──────────────────────────────────────────────────────────
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String get monthLabel => _months[selectedDate.value.month - 1];
  String get yearLabel => selectedDate.value.year.toString();

  void prevMonth() {
    currentPage.value = 0;
    final d = selectedDate.value;
    selectedDate.value = d.month == 1
        ? DateTime(d.year - 1, 12)
        : DateTime(d.year, d.month - 1);
  }

  void nextMonth() {
    final now = DateTime.now();
    final d = selectedDate.value;
    final next = d.month == 12
        ? DateTime(d.year + 1, 1)
        : DateTime(d.year, d.month + 1);
    if (next.isAfter(DateTime(now.year, now.month))) return;
    currentPage.value = 0;
    selectedDate.value = next;
  }

  bool get canGoNext {
    final now = DateTime.now();
    final d = selectedDate.value;
    final next = d.month == 12
        ? DateTime(d.year + 1, 1)
        : DateTime(d.year, d.month + 1);
    return !next.isAfter(DateTime(now.year, now.month));
  }

  // ── Day label helper ──────────────────────────────────────────────────────────
  String dayLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final d = DateTime(date.year, date.month, date.day);
    if (d == today) return 'Today';
    if (d == yesterday) return 'Yesterday';
    return '${date.day}';
  }

  String fullMonthLabel(DateTime date) {
    return '${_months[date.month - 1]} ${date.year}';
  }
}
