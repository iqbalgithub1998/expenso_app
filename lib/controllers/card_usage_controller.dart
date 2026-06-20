import 'package:expenso/controllers/friends_store_controller.dart';
import 'package:expenso/models/friend.dart';
import 'package:expenso/repositories/friends_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // ── Who used (only for "Used") — backed by the global friends cache ─────
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

  // ── Phone contact picker ──────────────────────────────────────────────────
  final RxList<Contact> phoneContacts = <Contact>[].obs;
  final RxString contactSearchQuery = ''.obs;
  final RxBool isFetchingPhoneContacts = false.obs;

  Future<void> onSyncFromContacts() async {
    final status = await FlutterContacts.permissions.request(
      PermissionType.readWrite,
    );
    if (status != PermissionStatus.granted) return;

    isFetchingPhoneContacts.value = true;
    phoneContacts.value = await FlutterContacts.getAll(
      properties: {ContactProperty.phone},
    );
    isFetchingPhoneContacts.value = false;

    Get.bottomSheet(
      _ContactPickerSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  List<Contact> get filteredPhoneContacts {
    if (contactSearchQuery.isEmpty) return phoneContacts;
    final query = contactSearchQuery.value.toLowerCase();
    return phoneContacts
        .where((c) => c.displayName?.toLowerCase().contains(query) ?? false)
        .toList();
  }

  void onContactSearchChanged(String value) => contactSearchQuery.value = value;

  void selectPhoneContact(Contact contact) {
    addNameController.text = contact.displayName ?? "";
    if (contact.phones.isNotEmpty) {
      addPhoneController.text = contact.phones.first.number.replaceAll(" ", "");
    } else {
      addPhoneController.clear();
    }
    Get.back();
  }

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

  // ── Date (only for "Used") ───────────────────────────────────────────────
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

  // ── Note (only for "Used") ───────────────────────────────────────────────
  final noteController = TextEditingController();
  final note = ''.obs;

  // ── Per-type accent ──────────────────────────────────────────────────────
  Color get accentColor => isUsed
      ? const Color(0xFFFF5252) // red  — spending
      : const Color(0xFF00E676); // green — payment

  List<Color> get accentGradient => isUsed
      ? [const Color(0xFFB71C1C), const Color(0xFFFF5252)]
      : [const Color(0xFF00603A), const Color(0xFF00E676)];

  // ── Validation ───────────────────────────────────────────────────────────
  bool get isValid {
    final parsed = double.tryParse(amount.value);
    final hasAmount = parsed != null && parsed > 0;
    if (!hasAmount) return false;
    if (isUsed) return usageDate.value != null;
    return true; // paid only needs amount
  }

  // ── Actions ───────────────────────────────────────────────────────────────
  void selectType(CardEntryType t) {
    selectedType.value = t;
    // reset fields that only belong to one mode
    selectedUser.value = null;
    usageDate.value = null;
  }

  Future<void> _saveTransaction() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not authenticated');

    final parsedAmount = double.tryParse(amount.value);
    if (parsedAmount == null || parsedAmount <= 0) {
      throw Exception('Invalid amount');
    }

    // Passed from the card screen.
    final cardId = Get.arguments?['cardId']?.toString();
    if (cardId == null || cardId.isEmpty) {
      throw Exception('Missing credit card id (cardId)');
    }

    if (isUsed && selectedUser.value == null) {
      throw Exception('Please select who used the card');
    }

    final typeString = isUsed ? 'used' : 'paid';
    final usedOn = (isUsed ? usageDate.value : null) ?? DateTime.now();

    final payload = <String, dynamic>{
      'card_id': cardId,
      'user_id': userId,
      'type': typeString,
      'amount': parsedAmount,
      'used_by': isUsed ? selectedUser.value!.id : null,
      'used_on': usedOn.toIso8601String().split('T').first,
      if (noteController.text.trim().isNotEmpty)
        'note': noteController.text.trim(),
    };

    // print(payload);

    final insertedRecord = await Supabase.instance.client
        .from('credit_card_transaction')
        .insert(payload)
        .select()
        .single();

    Get.back(result: insertedRecord);
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

  Future<void> onConfirm() async {
    if (!isValid) {
      final msg = amount.value.isEmpty || double.tryParse(amount.value) == null
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

    try {
      await _saveTransaction();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to record transaction: $e',
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        duration: const Duration(seconds: 3),
      );
      return;
    }

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

    // Reset form state after save
    amountController.clear();
    noteController.clear();
    selectedUser.value = null;
    usageDate.value = null;
    selectedType.value = CardEntryType.used;
  }

  @override
  void onInit() {
    super.onInit();
    _friendsStore.ensureLoaded();
    amountController.addListener(() => amount.value = amountController.text);
    noteController.addListener(() => note.value = noteController.text);
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

// ─────────────────────────────────────────────────────────────────────────────
// Contact Picker Bottom Sheet (sync from phone contacts)
// ─────────────────────────────────────────────────────────────────────────────
class _ContactPickerSheet extends StatelessWidget {
  final CardUsageController controller;

  const _ContactPickerSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final accent = controller.accentColor;
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: controller.accentGradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.contacts_rounded,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Contact',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.4,
                      ),
                    ),
                    Text(
                      'Choose from your phone contacts',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Search
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFF0D0F14),
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: TextField(
                onChanged: controller.onContactSearchChanged,
                style: TextStyle(fontSize: 13.sp, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  hintStyle: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF4B5563),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20.sp,
                    color: const Color(0xFF4B5563),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13.h),
                ),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Contact list
          Expanded(
            child: Obx(() {
              if (controller.isFetchingPhoneContacts.value) {
                return Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(accent),
                  ),
                );
              }
              final contacts = controller.filteredPhoneContacts;
              if (contacts.isEmpty) {
                return Center(
                  child: Text(
                    'No contacts found',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF4B5563),
                    ),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                ).copyWith(bottom: 28.h),
                itemCount: contacts.length,
                separatorBuilder: (_, _) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final contact = contacts[index];
                  final phone = contact.phones.isNotEmpty
                      ? contact.phones.first.number
                      : '';
                  return InkWell(
                    onTap: () => controller.selectPhoneContact(contact),
                    borderRadius: BorderRadius.circular(16.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D26),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 44.w,
                            height: 44.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0D0F14),
                            ),
                            child: Center(
                              child: Text(
                                _initials(contact.displayName ?? ""),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Name + Phone
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact.displayName ?? "",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                if (phone.isNotEmpty) ...[
                                  SizedBox(height: 3.h),
                                  Text(
                                    phone,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Icon(
                            Icons.check_circle_outline_rounded,
                            size: 20.sp,
                            color: const Color(0xFF374151),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }
}
