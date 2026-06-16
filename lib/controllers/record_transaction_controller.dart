import 'package:expenso/repositories/friends_repository.dart';
import 'package:expenso/controllers/lend_borrow_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ── Enums ─────────────────────────────────────────────────────────────────────

enum TransactionType { lend, borrow, settlement }

// ── Controller ────────────────────────────────────────────────────────────────

class RecordTransactionController extends GetxController {
  final _friendsRepo = Get.put(FriendsRepository());
  // ── Transaction type ──────────────────────────────────────────────────────
  final selectedType = TransactionType.lend.obs;
  bool get isSettlement => selectedType.value == TransactionType.settlement;

  // ── Amount ────────────────────────────────────────────────────────────────
  final amountController = TextEditingController();
  final amount = ''.obs;

  // ── Dates ─────────────────────────────────────────────────────────────────
  final transactionDate = Rxn<DateTime>();
  final returnDate = Rxn<DateTime>();

  // ── Loading state ─────────────────────────────────────────────────────────
  final isLoading = false.obs;

  // ── Note ─────────────────────────────────────────────────────────────────
  final noteController = TextEditingController();
  final note = ''.obs;

  // ── Reminder ─────────────────────────────────────────────────────────────
  final reminderEnabled = false.obs;

  // ── Per-type accent ───────────────────────────────────────────────────────
  Color get accentColor {
    switch (selectedType.value) {
      case TransactionType.lend:
        return const Color(0xFFBB86FC);
      case TransactionType.borrow:
        return const Color(0xFF00E676);
      case TransactionType.settlement:
        return const Color(0xFF00BFA5);
    }
  }

  List<Color> get accentGradient {
    switch (selectedType.value) {
      case TransactionType.lend:
        return [const Color(0xFF7C3AED), const Color(0xFFBB86FC)];
      case TransactionType.borrow:
        return [const Color(0xFF00603A), const Color(0xFF00E676)];
      case TransactionType.settlement:
        return [const Color(0xFF005B4F), const Color(0xFF00BFA5)];
    }
  }

  // ── Validation ────────────────────────────────────────────────────────────
  bool get isValid {
    final parsedAmount = double.tryParse(amount.value);
    if (isSettlement) {
      return transactionDate.value != null;
    }
    return amount.value.isNotEmpty &&
        parsedAmount != null &&
        parsedAmount > 0 &&
        transactionDate.value != null;
  }

  String? get validationError {
    if (isSettlement) {
      if (transactionDate.value == null) {
        return 'Please select a settlement date.';
      }
      return null;
    }
    if (amount.value.isEmpty) return 'Please enter an amount.';
    final parsedAmount = double.tryParse(amount.value);
    if (parsedAmount == null || parsedAmount <= 0) {
      return 'Please enter a valid amount greater than 0.';
    }
    if (transactionDate.value == null) {
      return 'Please select a transaction date.';
    }
    return null;
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  void selectType(TransactionType type) => selectedType.value = type;

  Future<void> pickTransactionDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: transactionDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => _darkDatePicker(ctx, child),
    );
    if (picked != null) transactionDate.value = picked;
  }

  Future<void> pickReturnDate(BuildContext context) async {
    final base = transactionDate.value ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: returnDate.value ?? base.add(const Duration(days: 7)),
      firstDate: base,
      lastDate: DateTime(2030),
      builder: (ctx, child) => _darkDatePicker(ctx, child),
    );
    if (picked != null) returnDate.value = picked;
  }

  Widget _darkDatePicker(BuildContext context, Widget? child) => Theme(
    data: ThemeData.dark().copyWith(
      colorScheme: ColorScheme.dark(
        primary: accentColor,
        onPrimary: Colors.black,
        surface: const Color(0xFF1A1D26),
        onSurface: Colors.white,
      ),
      dialogBackgroundColor: const Color(0xFF141720),
    ),
    child: child!,
  );

  String formatDate(DateTime? date) {
    if (date == null) return 'mm/dd/yyyy';
    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Future<void> onConfirm(String friendId) async {
    final error = validationError;
    if (error != null) {
      Get.snackbar(
        'Incomplete',
        error,
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    isLoading.value = true;

    try {
      final currentUserId = Supabase.instance.client.auth.currentUser!.id;

      // Map enum to DB string
      final typeString = switch (selectedType.value) {
        TransactionType.lend => 'lend',
        TransactionType.borrow => 'borrow',
        TransactionType.settlement => 'settlement',
      };

      final payload = <String, dynamic>{
        'user_id': currentUserId,
        'amount': double.parse(amount.value),
        'type': typeString,
        'when_date': transactionDate.value!.toIso8601String().split('T').first,
        if (note.value.trim().isNotEmpty) 'note': note.value.trim(),
        if (returnDate.value != null)
          'return_date': returnDate.value!.toIso8601String().split('T').first,
        "friend_id": friendId,
      };

      await Supabase.instance.client
          .from('lend_borrow_transaction')
          .insert(payload);

      // update friend closing balance
      await _friendsRepo.updateClosingBalance(
        friendId,
        double.parse(amount.value),
        typeString,
      );

      // refresh in-app controllers/UI
      if (Get.isRegistered<LendBorrowController>()) {
        final lendBorrowController = Get.find<LendBorrowController>();
        await lendBorrowController.refreshFriends();
        lendBorrowController.loadBalance();
        await lendBorrowController.refreshCurrentFriendTransactions(friendId);
      }

      final typeLabel = selectedType.value.name.capitalizeFirst!;
      final msg = isSettlement
          ? 'Settlement recorded on ${formatDate(transactionDate.value)}'
          : '$typeLabel of ₹${amount.value} recorded successfully.';

      // Get.snackbar(
      //   'Recorded ✓',
      //   msg,
      //   backgroundColor: const Color(0xFF0D1F15),
      //   colorText: accentColor,
      //   snackPosition: SnackPosition.BOTTOM,
      //   margin: const EdgeInsets.all(16),
      //   borderRadius: 14,
      //   duration: const Duration(seconds: 3),
      // );

      // Reset form
      amountController.clear();
      noteController.clear();
      transactionDate.value = null;
      returnDate.value = null;
      selectedType.value = TransactionType.lend;
      reminderEnabled.value = false;

      Get.back();
    } catch (e) {
      debugPrint('RecordTransaction error: $e');
      Get.snackbar(
        'Error',
        'Failed to save transaction. Please try again.',
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    transactionDate.value = DateTime.now();
    amountController.addListener(() => amount.value = amountController.text);
    noteController.addListener(() => note.value = noteController.text);
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
