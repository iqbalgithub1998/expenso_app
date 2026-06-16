import 'package:expenso/controllers/friends_store_controller.dart';
import 'package:expenso/models/friend.dart';
import 'package:expenso/repositories/friends_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry type
// ─────────────────────────────────────────────────────────────────────────────
enum CardEntryType { used, paid }

// ─────────────────────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────────────────────
class CardUsageController extends GetxController {
  // ── Global friends cache (shared, fetched once app-wide) ───────────────────
  final FriendsStore _friendsStore = FriendsStore.instance;
  final FriendsRepository _friendsRepo = Get.put(FriendsRepository());
  // ── Entry type ───────────────────────────────────────────────────────────
  final selectedType = CardEntryType.used.obs;
  bool get isUsed => selectedType.value == CardEntryType.used;

  // ── Amount ───────────────────────────────────────────────────────────────
  final amountController = TextEditingController();
  final amount = ''.obs;

  // ── Who used (only for "Used") — backed by the global friends cache ────────
  final selectedUser = Rxn<Friends>();

  /// Live view of the shared friends list (no per-screen fetch).
  RxList<Friends> get users => _friendsStore.friends;

  // add-person form
  final addNameController = TextEditingController();
  final addPhoneController = TextEditingController();
  final isAddingUser = false.obs;

  // search inside picker
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  List<Friends> get filteredUsers {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return users;
    return users
        .where((u) => u.name.toLowerCase().contains(q) || u.number.contains(q))
        .toList();
  }

  void onSearchChanged(String v) => searchQuery.value = v;

  void selectUser(Friends u) {
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

  Future<void> addUser() async {
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
    try {
      // Avoid duplicates when a phone is provided.
      if (phone.isNotEmpty && await _friendsRepo.friendExistsByPhone(phone)) {
        Get.snackbar(
          'Already Added',
          'A contact with this phone number already exists.',
          backgroundColor: const Color(0xFF1F1212),
          colorText: const Color(0xFFFFB74D),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
          borderRadius: 14,
        );
        return;
      }

      final linkedUserId = phone.isNotEmpty
          ? await _friendsRepo.findLinkedUserId(phone)
          : null;

      final newFriend = await _friendsRepo.addFriend(
        name: name,
        phone: phone,
        linkedUserId: linkedUserId,
      );

      // Push into the shared cache — visible instantly everywhere.
      _friendsStore.cacheFriend(newFriend);
      selectedUser.value = newFriend;

      addNameController.clear();
      addPhoneController.clear();
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add person: $e',
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
    } finally {
      isAddingUser.value = false;
    }
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
    // Load the shared friends list once (no-op if already cached elsewhere).
    _friendsStore.ensureLoaded();
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
