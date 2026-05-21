import 'package:expenso/controllers/expense_controller.dart';
import 'package:expenso/models/category_items.dart';
import 'package:expenso/utils/constants.dart';
import 'package:expenso/utils/popups/loaders.dart';
import 'package:expenso/utils/snackbar/appsnackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddExpenseController extends GetxController {
  // ── Numpad amount ─────────────────────────────────────────────────────────
  final _raw = ''.obs; // e.g. "1234" or "12.34"

  String get formattedAmount {
    if (_raw.value.isEmpty) return '0';
    return _raw.value;
  }

  void appendDigit(String d) {
    // max 10 chars total
    if (_raw.value.length >= 10) return;
    // only one leading zero before decimal
    if (_raw.value == '0') {
      _raw.value = d;
      return;
    }
    _raw.value = _raw.value + d;
  }

  void appendDecimal() {
    if (_raw.value.contains('.')) return;
    if (_raw.value.isEmpty) {
      _raw.value = '0.';
    } else {
      _raw.value = '${_raw.value}.';
    }
  }

  void deleteDigit() {
    if (_raw.value.isEmpty) return;
    _raw.value = _raw.value.substring(0, _raw.value.length - 1);
  }

  double get amountValue => double.tryParse(_raw.value) ?? 0.0;

  final selectedCategoryIndex = 0.obs;

  void selectCategory(int i) => selectedCategoryIndex.value = i;

  CategoryItem get selectedCategory => categories[selectedCategoryIndex.value];

  // ── Date ──────────────────────────────────────────────────────────────────
  final selectedDate = DateTime.now().obs;

  String get formattedDate {
    final d = selectedDate.value;
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today';
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
    return '${d.day} ${months[d.month - 1]}';
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFF00E676),
            onPrimary: Colors.black,
            surface: Color(0xFF1A1D26),
            onSurface: Colors.white,
          ),
          dialogBackgroundColor: const Color(0xFF141720),
        ),
        child: child!,
      ),
    );
    if (picked != null) selectedDate.value = picked;
  }

  // ── Wallet ────────────────────────────────────────────────────────────────
  final wallets = ['Cash', 'Bank Account', 'Credit Card', 'UPI'];
  final selectedWallet = 'Cash'.obs;

  void selectWallet(String w) => selectedWallet.value = w;

  // ── Note ─────────────────────────────────────────────────────────────────
  final noteController = TextEditingController();
  final note = ''.obs;

  // ── Save ─────────────────────────────────────────────────────────────────
  final isSaving = false.obs;

  Future<void> saveTransaction(BuildContext context) async {
    if (amountValue <= 0) {
      TLoaders.errorSnackBar(
        title: 'Invalid Amount',
        message: 'Please enter an amount greater than ₹0.',
      );
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    debugPrint(userId);
    if (userId == null) {
      TLoaders.errorSnackBar(title: 'Error', message: 'User not logged in.');
      return;
    }

    isSaving.value = true;

    try {
      await Supabase.instance.client.from('expense').insert({
        'user_id': userId,
        'amount': amountValue,
        'category': selectedCategory.label,
        'date': selectedDate.value.toIso8601String().split('T')[0],
        'note': note.value,
      });

      if (Get.isRegistered<ExpenseController>()) {
        Get.find<ExpenseController>().addExpenseDirect(
          category: selectedCategory.label,
          amount: amountValue,
          note: note.value,
          date: selectedDate.value,
        );
      }

      _raw.value = '';
      noteController.clear();
      selectedDate.value = DateTime.now();
      Get.back();
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        'Error',
        'Failed to save transaction. Please try again.',
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    noteController.addListener(() => note.value = noteController.text);
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
