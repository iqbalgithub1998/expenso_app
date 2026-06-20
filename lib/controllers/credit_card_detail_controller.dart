import 'dart:convert';

import 'package:expenso/models/credit_card_transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final String dateKey; // yyyy-MM-dd — used to merge paginated pages in place
  final int day;
  final String label;
  final String month;
  final List<TxModel> txs;
  DayGroup({
    required this.dateKey,
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
  late String cardId;

  // ── Payment due date (passed from previous screen) ───────────────────────────
  final paymentDueDate = ''.obs;

  CreditCardDetailsController() {
    // Get payment due date from navigation arguments
    final args = Get.arguments;
    if (args != null && args['paymentDueDate'] != null) {
      paymentDueDate.value = args['paymentDueDate'].toString();
    }

    // Get card id from navigation arguments
    if (args != null && args['card'] != null) {
      print(args['card'].id);
      cardId = args['card'].id;
    }
  }

  // ── Pagination state ─────────────────────────────────────────────────────────
  final isLoading = false.obs; // initial load
  final isLoadingMore = false.obs; // loading next page
  final hasMore = true.obs;
  final int _pageSize = 20;
  int _offset = 0;

  // dateKey → group, so a new page appends to an existing day in O(1)
  // instead of rebuilding every group on each fetch.
  final Map<String, DayGroup> _groupIndex = {};

  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    scrollController.addListener(_onScroll);
    fetchTransaction(initial: true);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final position = scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200 &&
        !isLoadingMore.value &&
        hasMore.value) {
      fetchTransaction();
    }
  }

  String get nextPaymentDate => getNextPaymentDate(paymentDueDate.value);

  void toggleCard(bool value) => cardActive.value = value;

  List<CreditCardTransaction> transactions = [];

  // ── Static transaction data ────────────────────────────────────────────────
  // static const List<DayGroup> groups = [
  //   DayGroup(
  //     day: 24,
  //     label: 'Today',
  //     month: 'November 2023',
  //     txs: [
  //       TxModel(
  //         title: 'Luxury Boutique',
  //         subtitle: 'Apparel & Style',
  //         amount: -120.00,
  //         time: '14:20 PM',
  //         icon: Icons.shopping_bag_outlined,
  //         iconBg: Color(0xFF1E1530),
  //         iconColor: Color(0xFFBB86FC),
  //       ),
  //       TxModel(
  //         title: 'Salary Deposit',
  //         subtitle: 'Tech Corp Inc.',
  //         amount: 3120.00,
  //         time: '09:15 AM',
  //         icon: Icons.account_balance_wallet_outlined,
  //         iconBg: Color(0xFF0F2318),
  //         iconColor: Color(0xFF2E9E5C),
  //       ),
  //     ],
  //   ),
  //   DayGroup(
  //     day: 23,
  //     label: 'Yesterday',
  //     month: 'November 2023',
  //     txs: [
  //       TxModel(
  //         title: 'The Green Bistro',
  //         subtitle: 'Dining & Drinks',
  //         amount: -85.50,
  //         time: '20:45 PM',
  //         icon: Icons.restaurant_outlined,
  //         iconBg: Color(0xFF231A0D),
  //         iconColor: Color(0xFFD97706),
  //       ),
  //       TxModel(
  //         title: 'Delta Air Lines',
  //         subtitle: 'Vacation Booking',
  //         amount: -1250.00,
  //         time: '13:00 PM',
  //         icon: Icons.flight_takeoff_outlined,
  //         iconBg: Color(0xFF7C3AED),
  //         iconColor: Colors.white,
  //         isHighlighted: true,
  //       ),
  //       TxModel(
  //         title: 'Utilities',
  //         subtitle: 'Monthly Billing',
  //         amount: -145.00,
  //         time: '08:00 AM',
  //         icon: Icons.bolt_outlined,
  //         iconBg: Color(0xFF230D0D),
  //         iconColor: Color(0xFFE53935),
  //       ),
  //     ],
  //   ),
  //   DayGroup(
  //     day: 21,
  //     label: 'Earlier',
  //     month: 'November 2023',
  //     txs: [
  //       TxModel(
  //         title: 'Shell Station',
  //         subtitle: 'Transport',
  //         amount: -65.00,
  //         time: '17:10 PM',
  //         icon: Icons.local_gas_station_outlined,
  //         iconBg: Color(0xFF1A1A24),
  //         iconColor: Color(0xFF8888AA),
  //       ),
  //     ],
  //   ),
  // ];

  RxList<DayGroup> groups = RxList<DayGroup>([]);

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
    return '${months[nextPayment.month - 1]} ${nextPayment.day}';
  }

  /// Merges a freshly-fetched page (already newest-first) into [groups]
  /// in place — existing day groups are appended to, never rebuilt.
  void _mergePage(List<CreditCardTransaction> page) {
    for (final tx in page) {
      final key = DateFormat('yyyy-MM-dd').format(tx.usedOn);
      final model = _mapTx(tx);

      final existing = _groupIndex[key];
      if (existing != null) {
        existing.txs.add(model);
      } else {
        final group = DayGroup(
          dateKey: key,
          day: tx.usedOn.day,
          label: _dayLabel(tx.usedOn),
          month: DateFormat('MMMM yyyy').format(tx.usedOn),
          txs: [model],
        );
        _groupIndex[key] = group;
        groups.add(group);
      }
    }
  }

  TxModel _mapTx(CreditCardTransaction tx) {
    return TxModel(
      title: tx.friend != null
          ? tx.friend!.name.isNotEmpty
                ? tx.friend!.name
                : "Transaction"
          : 'Paid',
      subtitle: tx.note ?? "No note found",
      amount: tx.type == 'used' ? -tx.amount : tx.amount,
      time: DateFormat('hh:mm a').format(tx.createdAt),
      icon: _getIcon(tx.type),
      iconBg: const Color(0xFF1E1530),
      iconColor: const Color(0xFFBB86FC),
    );
  }

  String _dayLabel(DateTime date) {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    if (_isSameDate(date, now)) return 'Today';
    if (_isSameDate(date, yesterday)) return 'Yesterday';
    return 'Earlier';
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'expense':
      case 'debit':
        return Icons.shopping_bag_outlined;
      case 'credit':
      case 'income':
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  Future<void> fetchTransaction({bool initial = false}) async {
    if (initial) {
      isLoading.value = true;
      _offset = 0;
      transactions = [];
      _groupIndex.clear();
      groups.clear();
      hasMore.value = true;
    } else {
      if (isLoadingMore.value || !hasMore.value) return;
      isLoadingMore.value = true;
    }

    try {
      final data = await Supabase.instance.client
          .from('credit_card_transaction')
          .select('''
            *,
            friend:used_by (
              id,
              name,
              phone
            )
          ''')
          .eq('card_id', cardId)
          .order('created_at', ascending: false)
          .range(_offset, _offset + _pageSize - 1);
      print(jsonEncode(data));
      final tsn = creditCardTransactionFromJson(jsonEncode(data));

      // No full page returned → reached the end
      if (tsn.length < _pageSize) hasMore.value = false;

      transactions.addAll(tsn);
      _offset += tsn.length;

      _mergePage(tsn);
      groups.refresh();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch transactions: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1A1D26),
        colorText: const Color(0xFFEF4444),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void addTransaction(Map<String, dynamic> result) {
    print("in card detail controller");
    print(result);
  }
}
