import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ── Models ────────────────────────────────────────────────────────────────────

class CardModel {
  final String name;
  final String last4;
  final double balance;
  final double limit;
  final List<Color> gradient;
  final bool isDark;
  final String billingDate;
  final String paymentDueDate;

  const CardModel({
    required this.name,
    required this.last4,
    required this.balance,
    required this.limit,
    required this.gradient,
    required this.isDark,
    required this.billingDate,
    required this.paymentDueDate,
  });

  double get usedPercent => (balance / limit).clamp(0.0, 1.0);
  String get usedLabel => '${(usedPercent * 100).toStringAsFixed(1)}% USED';
  String get limitLabel => 'LIMIT  ₹${(limit / 1000).toStringAsFixed(0)}K';

  String get formattedBalance {
    final parts = balance.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$intPart.${parts[1]}';
  }
}

class PaymentModel {
  final String cardName;
  final String last4;
  final double minDue;
  final String dueLabel;
  final bool isUrgent;

  const PaymentModel({
    required this.cardName,
    required this.last4,
    required this.minDue,
    required this.dueLabel,
    required this.isUrgent,
  });

  String get formattedDue => '₹${minDue.toStringAsFixed(2)}';
}

// ── Controller ────────────────────────────────────────────────────────────────

class CreditCardsController extends GetxController {
  // ── Card list ─────────────────────────────────────────────────────────────
  final cards = <CardModel>[
    const CardModel(
      name: 'Platinum Elite',
      last4: '8024',
      balance: 4120.45,
      limit: 15000,
      gradient: [Color(0xFF1C1C2E), Color(0xFF2D2D44)],
      isDark: true,
      billingDate: '5th',
      paymentDueDate: '15th',
    ),
    const CardModel(
      name: 'Obsidian Infinite',
      last4: '4112',
      balance: 8450.00,
      limit: 70000,
      gradient: [Color(0xFF1A1D26), Color(0xFF2A2D3A)],
      isDark: true,
      billingDate: '7th',
      paymentDueDate: '14th',
    ),
    const CardModel(
      name: 'Emerald Rewards',
      last4: '9003',
      balance: 1200.00,
      limit: 10000,
      gradient: [Color(0xFF00603A), Color(0xFF00E676)],
      isDark: true,
      billingDate: '1st',
      paymentDueDate: '10th',
    ),
  ].obs;

  // ── Payment schedule ──────────────────────────────────────────────────────
  final payments = <PaymentModel>[
    const PaymentModel(
      cardName: 'Obsidian Infinite',
      last4: '4112',
      minDue: 450.00,
      dueLabel: 'Due in 7 days • Dec 14',
      isUrgent: true,
    ),
    const PaymentModel(
      cardName: 'Platinum Elite',
      last4: '8024',
      minDue: 120.00,
      dueLabel: 'Due in 15 days • Dec 27',
      isUrgent: false,
    ),
  ].obs;

  // ── Active nav index ──────────────────────────────────────────────────────
  final activeNavIndex = 1.obs;

  // ── Add Card form state ───────────────────────────────────────────────────
  final nameController = TextEditingController();
  final last4Controller = TextEditingController();
  final billingController = TextEditingController();
  final paymentController = TextEditingController();

  final previewName = 'Card Name'.obs;
  final previewLast4 = '0000'.obs;
  final previewBilling = '--'.obs;
  final previewPayment = '--'.obs;
  final selectedTheme = 0.obs;

  // ── Available card gradient themes ───────────────────────────────────────
  static const List<List<Color>> cardThemes = [
    [Color(0xFF1C1C2E), Color(0xFF2D2D44)], // Dark navy
    [Color(0xFF00603A), Color(0xFF00E676)], // Green
    [Color(0xFF7C3AED), Color(0xFFBB86FC)], // Purple
    [Color(0xFF92400E), Color(0xFFD97706)], // Amber
  ];

  // ── Form helpers ─────────────────────────────────────────────────────────
  void onNameChanged(String v) =>
      previewName.value = v.isEmpty ? 'Card Name' : v;

  void onLast4Changed(String v) =>
      previewLast4.value = v.isEmpty ? '0000' : v.padRight(4, '0');

  void onBillingChanged(String v) =>
      previewBilling.value = v.isEmpty ? '--' : '${v}th';

  void onPaymentChanged(String v) =>
      previewPayment.value = v.isEmpty ? '--' : '${v}th';

  void selectTheme(int index) => selectedTheme.value = index;

  bool get formIsValid =>
      nameController.text.trim().isNotEmpty && last4Controller.text.length == 4;

  void saveCard(BuildContext context) {
    if (!formIsValid) {
      Get.snackbar(
        'Incomplete',
        'Please enter a card name and all 4 digits.',
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
      return;
    }

    final theme = cardThemes[selectedTheme.value];
    cards.add(
      CardModel(
        name: nameController.text.trim(),
        last4: last4Controller.text,
        balance: 0,
        limit: 50000,
        gradient: theme,
        isDark: true,
        billingDate: previewBilling.value,
        paymentDueDate: previewPayment.value,
      ),
    );

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
  }

  void _resetForm() {
    nameController.clear();
    last4Controller.clear();
    billingController.clear();
    paymentController.clear();
    previewName.value = 'Card Name';
    previewLast4.value = '0000';
    previewBilling.value = '--';
    previewPayment.value = '--';
    selectedTheme.value = 0;
  }

  void onNavTap(int index) => activeNavIndex.value = index;

  @override
  void onClose() {
    nameController.dispose();
    last4Controller.dispose();
    billingController.dispose();
    paymentController.dispose();
    super.onClose();
  }
}
