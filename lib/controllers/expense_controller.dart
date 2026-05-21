import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

class ExpenseController extends GetxController {
  final selectedDate = DateTime.now().obs;
  static const int _pageSize = 4;
  final currentPage = 0.obs;
  final isLoading = true.obs;

  final _allTransactions = <TransactionModel>[].obs;

  static const Map<String, Map<String, dynamic>> _categoryStyles = {
    'Food': {'icon': Icons.restaurant_outlined, 'iconColor': Color(0xFFFFB74D), 'bgColor': Color(0xFF1E1A12)},
    'Snacks': {'icon': Icons.fastfood_outlined, 'iconColor': Color(0xFFFFB74D), 'bgColor': Color(0xFF1E1A12)},
    'Coffee': {'icon': Icons.coffee_outlined, 'iconColor': Color(0xFFFFB74D), 'bgColor': Color(0xFF1E1A12)},
    'Travel': {'icon': Icons.directions_bus_outlined, 'iconColor': Color(0xFF00E676), 'bgColor': Color(0xFF0D1F15)},
    'Shopping': {'icon': Icons.shopping_bag_outlined, 'iconColor': Color(0xFFBB86FC), 'bgColor': Color(0xFF1E1B2E)},
    'Online Shopping': {'icon': Icons.shopping_cart_outlined, 'iconColor': Color(0xFFBB86FC), 'bgColor': Color(0xFF1E1B2E)},
    'Clothing': {'icon': Icons.checkroom_outlined, 'iconColor': Color(0xFFBB86FC), 'bgColor': Color(0xFF1E1B2E)},
    'Bills': {'icon': Icons.home_outlined, 'iconColor': Color(0xFFFF5252), 'bgColor': Color(0xFF1F1212)},
    'Electricity': {'icon': Icons.lightbulb_outline, 'iconColor': Color(0xFFFFB74D), 'bgColor': Color(0xFF1E1A12)},
    'Water Bill': {'icon': Icons.water_drop_outlined, 'iconColor': Color(0xFF2196F3), 'bgColor': Color(0xFF1A1D26)},
    'Internet': {'icon': Icons.wifi_outlined, 'iconColor': Color(0xFF2196F3), 'bgColor': Color(0xFF1A1D26)},
    'Mobile Recharge': {'icon': Icons.phone_android_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'OTT & Subscriptions': {'icon': Icons.tv_outlined, 'iconColor': Color(0xFFE91E63), 'bgColor': Color(0xFF1F1215)},
    'Entertainment': {'icon': Icons.movie_outlined, 'iconColor': Color(0xFFE91E63), 'bgColor': Color(0xFF1F1215)},
    'Groceries': {'icon': Icons.local_grocery_store_outlined, 'iconColor': Color(0xFFFFB74D), 'bgColor': Color(0xFF1E1A12)},
    'Health': {'icon': Icons.medical_services_outlined, 'iconColor': Color(0xFFFF5252), 'bgColor': Color(0xFF1F1212)},
    'Fitness': {'icon': Icons.fitness_center_outlined, 'iconColor': Color(0xFF00E676), 'bgColor': Color(0xFF0D1F15)},
    'Beauty': {'icon': Icons.spa_outlined, 'iconColor': Color(0xFFE91E63), 'bgColor': Color(0xFF1F1215)},
    'Taxi': {'icon': Icons.local_taxi_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'Fuel': {'icon': Icons.local_gas_station_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'Train': {'icon': Icons.train_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'Flights': {'icon': Icons.flight_outlined, 'iconColor': Color(0xFF00E676), 'bgColor': Color(0xFF0D1F15)},
    'Bike': {'icon': Icons.two_wheeler_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'Parking': {'icon': Icons.local_parking_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'EMI': {'icon': Icons.account_balance_wallet_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'Credit Card': {'icon': Icons.credit_card_outlined, 'iconColor': Color(0xFFFF5252), 'bgColor': Color(0xFF1F1212)},
    'Loan': {'icon': Icons.payments_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'Savings': {'icon': Icons.savings_outlined, 'iconColor': Color(0xFF00E676), 'bgColor': Color(0xFF0D1F15)},
    'Investment': {'icon': Icons.currency_rupee_outlined, 'iconColor': Color(0xFF00E676), 'bgColor': Color(0xFF0D1F15)},
    'Tax': {'icon': Icons.receipt_long_outlined, 'iconColor': Color(0xFFFF5252), 'bgColor': Color(0xFF1F1212)},
    'Insurance': {'icon': Icons.security_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'Education': {'icon': Icons.school_outlined, 'iconColor': Color(0xFF2196F3), 'bgColor': Color(0xFF1A1D26)},
    'Kids': {'icon': Icons.child_care_outlined, 'iconColor': Color(0xFFFFB74D), 'bgColor': Color(0xFF1E1A12)},
    'Pets': {'icon': Icons.pets_outlined, 'iconColor': Color(0xFFFFB74D), 'bgColor': Color(0xFF1E1A12)},
    'Gifts': {'icon': Icons.card_giftcard_outlined, 'iconColor': Color(0xFFE91E63), 'bgColor': Color(0xFF1F1215)},
    'Donation': {'icon': Icons.favorite_outline, 'iconColor': Color(0xFFFF5252), 'bgColor': Color(0xFF1F1212)},
    'Office': {'icon': Icons.work_outline, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'Software': {'icon': Icons.laptop_mac_outlined, 'iconColor': Color(0xFF2196F3), 'bgColor': Color(0xFF1A1D26)},
    'Stationery': {'icon': Icons.print_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'Business': {'icon': Icons.business_center_outlined, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
    'Gaming': {'icon': Icons.sports_esports_outlined, 'iconColor': Color(0xFFE91E63), 'bgColor': Color(0xFF1F1215)},
    'Music': {'icon': Icons.music_note_outlined, 'iconColor': Color(0xFFE91E63), 'bgColor': Color(0xFF1F1215)},
    'Books': {'icon': Icons.book_outlined, 'iconColor': Color(0xFFBB86FC), 'bgColor': Color(0xFF1E1B2E)},
    'Vacation': {'icon': Icons.beach_access_outlined, 'iconColor': Color(0xFF00E676), 'bgColor': Color(0xFF0D1F15)},
    'Miscellaneous': {'icon': Icons.more_horiz, 'iconColor': Color(0xFF9CA3AF), 'bgColor': Color(0xFF1A1D26)},
  };

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    isLoading.value = true;
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        _allTransactions.value = [];
        return;
      }

      final response = await Supabase.instance.client
          .from('expense')
          .select('*')
          .eq('user_id', userId)
          .order('date', ascending: false)
          .order('created_at', ascending: false);

      if (response.isEmpty) {
        _allTransactions.value = [];
        return;
      }

      final transactions = <TransactionModel>[];
      for (final item in response) {
        final category = item['category'] as String? ?? 'Other';
        final style = _categoryStyles[category] ?? _categoryStyles['Other']!;
        final amountVal = (item['amount'] as num?)?.toDouble() ?? 0.0;
        final dateStr = item['date'] as String?;
        final createdAt = item['created_at'] as String?;

        DateTime date;
        if (dateStr != null) {
          date = DateTime.tryParse(dateStr) ?? DateTime.now();
        } else {
          date = DateTime.now();
        }

        String time = '';
        if (createdAt != null) {
          final dt = DateTime.tryParse(createdAt);
          if (dt != null) {
            final hour = dt.hour;
            final minute = dt.minute.toString().padLeft(2, '0');
            final period = hour >= 12 ? 'PM' : 'AM';
            final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
            time = '$displayHour:$minute $period';
          }
        }

        transactions.add(TransactionModel(
          icon: style['icon'] as IconData,
          iconColor: style['iconColor'] as Color,
          bgColor: style['bgColor'] as Color,
          title: category,
          subtitle: item['note'] as String? ?? category,
          amount: '-\$${amountVal.toStringAsFixed(2)}',
          isDebit: true,
          time: time,
          date: date,
        ));
      }

      _allTransactions.value = transactions;
    } catch (e) {
      debugPrint('Error fetching expenses: $e');
      _allTransactions.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void refreshData() {
    fetchExpenses();
  }

  void addExpenseDirect({
    required String category,
    required double amount,
    required String note,
    required DateTime date,
  }) {
    final style = _categoryStyles[category] ?? _categoryStyles['Miscellaneous']!;
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    final time = '$displayHour:$minute $period';

    final transaction = TransactionModel(
      icon: style['icon'] as IconData,
      iconColor: style['iconColor'] as Color,
      bgColor: style['bgColor'] as Color,
      title: category,
      subtitle: note.isEmpty ? category : note,
      amount: '-\$${amount.toStringAsFixed(2)}',
      isDebit: true,
      time: time,
      date: date,
    );

    _allTransactions.insert(0, transaction);
    currentPage.value = 0;
  }

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
        t.title,
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
