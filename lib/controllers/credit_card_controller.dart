import 'dart:convert';

import 'package:expenso/models/credit_card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ── Controller ────────────────────────────────────────────────────────────────

class CreditCardsController extends GetxController {
  // ── Card list ─────────────────────────────────────────────────────────────
  final cards = <CreditCardModel>[].obs;

  // ── Derived state ─────────────────────────────────────────────────────────
  bool get hasCards => cards.isNotEmpty;

  @override
  void onInit() {
    fetchCards();
    super.onInit();
  }

  /// Extracts the day-of-month from an ordinal label, e.g. "5th" → 5.
  int? dayOf(int ordinal) {
    final match = RegExp(r'\d+').firstMatch(ordinal.toString());
    return match == null ? null : int.tryParse(match.group(0)!);
  }

  /// Cards currently inside their payment window — the bill has been generated
  /// (billing day already passed this month) but the due day hasn't arrived yet.
  List<CreditCardModel> get duePayments {
    final today = DateTime.now().day;
    return cards.where((card) {
      final billing = dayOf(card.billingDate);
      final due = dayOf(card.paymentDueDate);
      if (billing == null || due == null) return false;
      return billing < today && due >= today;
    }).toList();
  }

  // ── Active nav index ──────────────────────────────────────────────────────
  final activeNavIndex = 1.obs;

  // ── Add Card form state ───────────────────────────────────────────────────
  final nameController = TextEditingController();
  final last4Controller = TextEditingController();
  final limitController = TextEditingController();
  final balanceController = TextEditingController();
  final billingController = TextEditingController();
  final paymentController = TextEditingController();

  final previewName = 'Card Name'.obs;
  final previewLast4 = '0000'.obs;
  final previewLimit = '--'.obs;
  final previewBalance = '0'.obs;
  final previewBilling = '--'.obs;
  final previewPayment = '--'.obs;
  final selectedTheme = 0.obs;

  // ── Available card gradient themes ───────────────────────────────────────
  static const List<List<Color>> cardThemes = [
    [Color(0xFF1C1C2E), Color(0xFF2D2D44)], // Dark navy
    [Color(0xFF00603A), Color(0xFF00E676)], // Green
    [Color(0xFF7C3AED), Color(0xFFBB86FC)], // Purple
    [Color(0xFF92400E), Color(0xFFD97706)], // Amber
    [Color(0xFFB71C1C), Color(0xFFFF5252)], // Red
    [Color(0xFF0D47A1), Color(0xFF42A5F5)], // Blue
    [Color(0xFF006064), Color(0xFF26C6DA)], // Teal
    [Color(0xFFAD1457), Color(0xFFF06292)], // Pink
    [Color(0xFF4A148C), Color(0xFF7E57C2)], // Deep violet
    [Color(0xFF1B5E20), Color(0xFF66BB6A)], // Forest
    [Color(0xFFE65100), Color(0xFFFFA726)], // Orange
    [Color(0xFF263238), Color(0xFF546E7A)], // Slate
    [Color(0xFF880E4F), Color(0xFFFF4081)], // Magenta
    [Color(0xFF1A237E), Color(0xFF5C6BC0)], // Indigo
  ];

  // ── Form helpers ─────────────────────────────────────────────────────────
  void onNameChanged(String v) =>
      previewName.value = v.isEmpty ? 'Card Name' : v;

  void onLast4Changed(String v) =>
      previewLast4.value = v.isEmpty ? '0000' : v.padRight(4, '0');

  void onBillingChanged(String v) =>
      previewBilling.value = v.isEmpty ? '--' : _ordinal(v);

  void onPaymentChanged(String v) =>
      previewPayment.value = v.isEmpty ? '--' : _ordinal(v);

  void onLimitChanged(String v) => previewLimit.value = v.isEmpty ? '--' : v;

  void onBalanceChanged(String v) => previewBalance.value = v.isEmpty ? '0' : v;

  void selectTheme(int index) => selectedTheme.value = index;

  /// Turns a day number into an ordinal label, e.g. 5 → "5th", 21 → "21st".
  String _ordinal(String dayStr) {
    final day = int.tryParse(dayStr);
    if (day == null) return dayStr;
    if (day >= 11 && day <= 13) return '${day}th';
    switch (day % 10) {
      case 1:
        return '${day}st';
      case 2:
        return '${day}nd';
      case 3:
        return '${day}rd';
      default:
        return '${day}th';
    }
  }

  bool get formIsValid =>
      nameController.text.trim().isNotEmpty &&
      last4Controller.text.length == 4 &&
      (double.tryParse(limitController.text.trim()) ?? 0) > 0;

  Future<void> saveCard(BuildContext context) async {
    if (!formIsValid) {
      Get.snackbar(
        'Incomplete',
        'Please enter a card name, all 4 digits and a valid credit limit.',
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
      return;
    }

    final limit = double.tryParse(limitController.text.trim()) ?? 0;
    final balance = double.tryParse(balanceController.text.trim()) ?? 0;
    final billingDay = int.tryParse(billingController.text.trim());
    final paymentDay = int.tryParse(paymentController.text.trim());

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      await Supabase.instance.client.from('credit_card').insert({
        'user_id': userId,
        'name': nameController.text.trim(),
        'last4': last4Controller.text.trim(),
        'balance': balance,
        'card_limit': limit,
        'color': selectedTheme.value.toString(),
        'billing_date': billingDay,
        'payment_due_date': paymentDay,
      });

      await fetchCards();

      _resetForm();
      Navigator.of(context).pop();

      Get.snackbar(
        'Card Added ✓',
        '${nameController.text} ending in ${last4Controller.text} added.',
        backgroundColor: const Color(0xFF0D1F15),
        colorText: const Color(0xFF00E676),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
    } on PostgrestException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
    }
  }

  Future<void> fetchCards() async {
    final userId = Supabase.instance.client.auth.currentUser!.id;

    final data = await Supabase.instance.client
        .from('credit_card')
        .select()
        .eq('user_id', userId)
        .order('created_at');
    print(data);
    cards.value = creditCardFromJson(jsonEncode(data));
  }

  void _resetForm() {
    nameController.clear();
    last4Controller.clear();
    limitController.clear();
    balanceController.clear();
    billingController.clear();
    paymentController.clear();
    previewName.value = 'Card Name';
    previewLast4.value = '0000';
    previewLimit.value = '--';
    previewBalance.value = '0';
    previewBilling.value = '--';
    previewPayment.value = '--';
    selectedTheme.value = 0;
  }

  void onNavTap(int index) => activeNavIndex.value = index;

  @override
  void onClose() {
    nameController.dispose();
    last4Controller.dispose();
    limitController.dispose();
    balanceController.dispose();
    billingController.dispose();
    paymentController.dispose();
    super.onClose();
  }
}
