import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddExpenseController extends GetxController {
  // ── Amount ────────────────────────────────────────────────────────────────
  final RxString amount = '0'.obs;

  void appendDigit(String digit) {
    if (amount.value == '0') {
      amount.value = digit;
    } else {
      amount.value += digit;
    }
  }

  void appendDecimal() {
    if (!amount.value.contains('.')) {
      amount.value += '.';
    }
  }

  void deleteDigit() {
    if (amount.value.length <= 1) {
      amount.value = '0';
    } else {
      amount.value = amount.value.substring(0, amount.value.length - 1);
    }
  }

  String get formattedAmount {
    if (amount.value.contains('.')) return amount.value;
    final n = double.tryParse(amount.value);
    if (n == null) return '0.00';
    return amount.value;
  }

  // ── Category ──────────────────────────────────────────────────────────────
  final RxInt selectedCategoryIndex = 0.obs;

  void selectCategory(int index) => selectedCategoryIndex.value = index;

  final List<CategoryItem> categories = const [
    CategoryItem(label: 'Food', icon: Icons.restaurant_outlined),
    CategoryItem(label: 'Shop', icon: Icons.shopping_bag_outlined),
    CategoryItem(label: 'Travel', icon: Icons.directions_car_outlined),
    CategoryItem(label: 'Fun', icon: Icons.movie_filter_outlined),
  ];

  CategoryItem get selectedCategory => categories[selectedCategoryIndex.value];

  // ── Note ──────────────────────────────────────────────────────────────────
  final TextEditingController noteController = TextEditingController();
  final RxString note = ''.obs;

  // ── Date ──────────────────────────────────────────────────────────────────
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  String get formattedDate {
    final now = DateTime.now();
    final d = selectedDate.value;
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return 'Today, ${_dayMonth(d)}';
    }
    return _dayMonth(d);
  }

  String _dayMonth(DateTime d) {
    const months = [
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
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2E9E5C),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) selectedDate.value = picked;
  }

  // ── Wallet ────────────────────────────────────────────────────────────────
  final RxString selectedWallet = 'Main Savings'.obs;

  final List<String> wallets = const [
    'Main Savings',
    'Cash',
    'Credit Card',
    'Debit Card',
  ];

  void selectWallet(String wallet) => selectedWallet.value = wallet;

  // ── Save ──────────────────────────────────────────────────────────────────
  final RxBool isSaving = false.obs;

  Future<void> saveTransaction() async {
    if (amount.value == '0' || amount.value.isEmpty) {
      Get.snackbar(
        'Invalid Amount',
        'Please enter a valid amount.',
        backgroundColor: const Color(0xFF1A1D26),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }

    isSaving.value = true;
    // Simulate async save — replace with your actual persistence logic
    await Future.delayed(const Duration(milliseconds: 600));
    isSaving.value = false;

    Get.back(); // close bottom sheet

    Get.snackbar(
      'Saved!',
      '${selectedCategory.label} · \$${formattedAmount}',
      backgroundColor: const Color(0xFF00C853),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
    );

    _reset();
  }

  void _reset() {
    amount.value = '0';
    selectedCategoryIndex.value = 0;
    selectedDate.value = DateTime.now();
    selectedWallet.value = 'Main Savings';
    noteController.clear();
    note.value = '';
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}

// ── Shared model (used by both controller and view) ───────────────────────────
class CategoryItem {
  final String label;
  final IconData icon;
  const CategoryItem({required this.label, required this.icon});
}
