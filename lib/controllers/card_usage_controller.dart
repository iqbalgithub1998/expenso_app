import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry type
// ─────────────────────────────────────────────────────────────────────────────
enum CardEntryType { used, paid }

// ─────────────────────────────────────────────────────────────────────────────
// Simple person model (reuses Friends shape, kept standalone here)
// ─────────────────────────────────────────────────────────────────────────────
class CardUser {
  final String name;
  final String number;

  CardUser({required this.name, required this.number});

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────────────────────
class CardUsageController extends GetxController {
  // ── Entry type ───────────────────────────────────────────────────────────
  final selectedType = CardEntryType.used.obs;
  bool get isUsed => selectedType.value == CardEntryType.used;

  // ── Amount ───────────────────────────────────────────────────────────────
  final amountController = TextEditingController();
  final amount = ''.obs;

  // ── Who used (only for "Used") ────────────────────────────────────────────
  final selectedUser = Rxn<CardUser>();

  final users = <CardUser>[
    CardUser(name: 'Arjun Mehta', number: '+91 98765 43210'),
    CardUser(name: 'Priya Shah', number: '+91 91234 56789'),
    CardUser(name: 'Rohit Verma', number: '+91 87654 32109'),
    CardUser(name: 'Sneha Kapoor', number: '+91 76543 21098'),
    CardUser(name: 'Karan Patel', number: '+91 65432 10987'),
  ].obs;

  // add-person form
  final addNameController = TextEditingController();
  final addPhoneController = TextEditingController();
  final isAddingUser = false.obs;

  // search inside picker
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  List<CardUser> get filteredUsers {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return users;
    return users
        .where((u) => u.name.toLowerCase().contains(q) || u.number.contains(q))
        .toList();
  }

  void onSearchChanged(String v) => searchQuery.value = v;

  void selectUser(CardUser u) {
    selectedUser.value = u;
    searchController.clear();
    searchQuery.value = '';
    Get.back();
  }

  void clearUser() => selectedUser.value = null;

  // ── Date (only for "Used") ────────────────────────────────────────────────
  final usageDate = Rxn<DateTime>();

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: usageDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
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
      ),
    );
    if (picked != null) usageDate.value = picked;
  }

  String formatDate(DateTime? d) {
    if (d == null) return 'mm/dd/yyyy';
    return '${d.month.toString().padLeft(2, '0')}/'
        '${d.day.toString().padLeft(2, '0')}/'
        '${d.year}';
  }

  // ── Note (only for "Used") ────────────────────────────────────────────────
  final noteController = TextEditingController();
  final note = ''.obs;

  // ── Per-type accent ──────────────────────────────────────────────────────
  Color get accentColor => isUsed
      ? const Color(0xFFFF5252) // red  — spending
      : const Color(0xFF00E676); // green — payment

  List<Color> get accentGradient => isUsed
      ? [const Color(0xFFB71C1C), const Color(0xFFFF5252)]
      : [const Color(0xFF00603A), const Color(0xFF00E676)];

  // ── Validation ────────────────────────────────────────────────────────────
  bool get isValid {
    final hasAmount =
        amount.value.isNotEmpty &&
        double.tryParse(amount.value) != null &&
        double.parse(amount.value) > 0;
    if (!hasAmount) return false;
    if (isUsed) return usageDate.value != null;
    return true; // paid only needs amount
  }

  // ── Actions ──────────────────────────────────────────────────────────────
  void selectType(CardEntryType t) {
    selectedType.value = t;
    // reset fields that only belong to one mode
    selectedUser.value = null;
    usageDate.value = null;
  }

  void addUser() {
    final name = addNameController.text.trim();
    final phone = addPhoneController.text.trim();
    if (name.isEmpty) {
      Get.snackbar(
        'Missing name',
        'Please enter a name.',
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
      return;
    }
    isAddingUser.value = true;
    Future.delayed(const Duration(milliseconds: 350), () {
      users.add(CardUser(name: name, number: phone.isEmpty ? '—' : phone));
      addNameController.clear();
      addPhoneController.clear();
      isAddingUser.value = false;
      Get.back();
      Get.snackbar(
        'Added ✓',
        '$name added.',
        backgroundColor: const Color(0xFF0D1F15),
        colorText: const Color(0xFF00E676),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
    });
  }

  void onConfirm() {
    if (!isValid) {
      String msg = amount.value.isEmpty || double.tryParse(amount.value) == null
          ? 'Please enter a valid amount.'
          : isUsed
          ? 'Please select the usage date.'
          : 'Something went wrong.';
      Get.snackbar(
        'Incomplete',
        msg,
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final typeLabel = isUsed ? 'Usage' : 'Payment';
    final who = selectedUser.value != null
        ? ' by ${selectedUser.value!.name}'
        : '';
    final dateStr = usageDate.value != null
        ? ' on ${formatDate(usageDate.value)}'
        : '';

    Get.snackbar(
      'Recorded ✓',
      '$typeLabel of ₹${amount.value}$who$dateStr',
      backgroundColor: const Color(0xFF0D1F15),
      colorText: accentColor,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onInit() {
    super.onInit();
    // amountController.addListener(() => amount.value = amountController.text);
    // noteController.addListener(() => note.value = noteController.text);
  }

  @override
  void onClose() {
    amountController.dispose();
    noteController.dispose();
    addNameController.dispose();
    addPhoneController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
