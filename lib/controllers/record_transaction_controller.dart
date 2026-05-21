import 'dart:convert';

import 'package:expenso/core/utils/helper.dart';
import 'package:expenso/utils/popups/loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ── Friends model ─────────────────────────────────────────────────────────────

List<Friends> friendsFromJson(String str) =>
    List<Friends>.from(json.decode(str).map((x) => Friends.fromJson(x)));

String friendsToJson(List<Friends> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Friends {
  final String name;
  final String number;

  Friends({required this.name, required this.number});

  factory Friends.fromJson(Map<String, dynamic> json) =>
      Friends(name: json['name'], number: json['number']);

  Map<String, dynamic> toJson() => {'name': name, 'number': number};

  /// Initials for avatar
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

// ── Enums ─────────────────────────────────────────────────────────────────────

enum TransactionType { lend, borrow, settlement }

// ── Controller ────────────────────────────────────────────────────────────────

class RecordTransactionController extends GetxController {
  // ── Transaction type ──────────────────────────────────────────────────────
  final selectedType = TransactionType.lend.obs;
  bool get isSettlement => selectedType.value == TransactionType.settlement;

  // ── Amount ────────────────────────────────────────────────────────────────
  final amountController = TextEditingController();
  final amount = ''.obs;

  // ── Friends list + selected friend ───────────────────────────────────────
  final friends = <Friends>[
    Friends(name: 'Arjun Mehta', number: '+91 98765 43210'),
    Friends(name: 'Priya Shah', number: '+91 91234 56789'),
    Friends(name: 'Rohit Verma', number: '+91 87654 32109'),
    Friends(name: 'Sneha Kapoor', number: '+91 76543 21098'),
    Friends(name: 'Karan Patel', number: '+91 65432 10987'),
  ].obs;

  final selectedFriend = Rxn<Friends>(); // null = none selected

  // contact string for validation (derived from selectedFriend)
  String get contact => selectedFriend.value?.name ?? '';

  // ── Add-contact form (used inside _AddContactSheet) ───────────────────────
  final addNameController = TextEditingController();
  final addPhoneController = TextEditingController();
  final isAddingContact = false.obs;

  // ── Friend selector search ────────────────────────────────────────────────
  final searchController = TextEditingController();
  final searchQuery = ''.obs;

  List<Friends> get filteredFriends {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return friends;
    return friends
        .where((f) => f.name.toLowerCase().contains(q) || f.number.contains(q))
        .toList();
  }

  void onSearchChanged(String v) => searchQuery.value = v;

  void selectFriend(Friends f) {
    selectedFriend.value = f;
    searchController.clear();
    searchQuery.value = '';
    Get.back(); // close the picker sheet
  }

  void clearSelectedFriend() => selectedFriend.value = null;

  // ── Add new friend ────────────────────────────────────────────────────────
  void addContact() {
    final name = addNameController.text.trim();
    final phone = addPhoneController.text.trim();

    if (name.isEmpty) {
      Get.snackbar(
        'Missing name',
        'Please enter a contact name.',
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
      return;
    }

    isAddingContact.value = true;
    Future.delayed(const Duration(milliseconds: 400), () {
      friends.add(Friends(name: name, number: phone.isEmpty ? '—' : phone));
      addNameController.clear();
      addPhoneController.clear();
      isAddingContact.value = false;
      Get.back(); // close add-contact sheet
      Get.snackbar(
        'Contact Added ✓',
        '$name added to your list.',
        backgroundColor: const Color(0xFF0D1F15),
        colorText: const Color(0xFF00E676),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
      );
    });
  }

  void onSyncFromContacts() async {
    try {
      final status = await FlutterContacts.permissions.request(
        PermissionType.readWrite,
      );
      if (status == PermissionStatus.granted) {
        // Get all contacts with properties and photo
        List<Contact> contacts = await FlutterContacts.getAll(
          properties: {ContactProperty.phone},
        );

        final searchQuery = ''.obs;
        final filteredContacts = contacts.obs;

        void updateSearch(String q) {
          searchQuery.value = q;
          if (q.isEmpty) {
            filteredContacts.value = contacts;
          } else {
            filteredContacts.value = contacts.where((c) {
              final nameMatch = c.displayName?.toLowerCase().contains(
                q.toLowerCase(),
              );
              final phoneMatch = c.phones.any((p) => p.number.contains(q));
              return nameMatch == true || phoneMatch == true;
            }).toList();
          }
        }

        Get.bottomSheet(
          Container(
            height: Get.height * 0.8,
            padding: EdgeInsets.only(
              top: 20.h,
              left: 20.w,
              right: 20.w,
              bottom: 20.h,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF141720),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                // Title
                Text(
                  'Select Contact',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                // Search Field
                TextField(
                  onChanged: updateSearch,
                  style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  decoration: InputDecoration(
                    hintText: 'Search by name or number...',
                    hintStyle: TextStyle(
                      color: const Color(0xFF4B5563),
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: const Color(0xFF4B5563),
                      size: 20.sp,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF0D0F14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                ),
                SizedBox(height: 16.h),
                // Contacts List
                Expanded(
                  child: Obx(() {
                    if (filteredContacts.isEmpty) {
                      return Center(
                        child: Text(
                          'No contacts found',
                          style: TextStyle(
                            color: const Color(0xFF4B5563),
                            fontSize: 14.sp,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: filteredContacts.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];
                        print(contact);
                        final phone = contact.phones.isNotEmpty
                            ? contact.phones.first.number
                            : 'No phone number';

                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 4.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                            side: BorderSide(
                              color: Colors.white.withValues(alpha: 0.05),
                            ),
                          ),
                          tileColor: const Color(0xFF0D0F14),
                          leading: CircleAvatar(
                            radius: 20.r,
                            backgroundColor: const Color(0xFF2A2D3A),

                            child: contact.photo == null
                                ? Text(
                                    (contact.displayName?.isNotEmpty ?? false)
                                        ? contact.displayName![0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            contact.displayName ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            phone,
                            style: TextStyle(
                              color: const Color(0xFF6B7280),
                              fontSize: 12.sp,
                            ),
                          ),
                          onTap: () {
                            addNameController.text = contact.displayName ?? "";
                            addPhoneController.text = phone == 'No phone number'
                                ? ''
                                : formatPhoneNumber(phone);
                            Get.back(); // Close bottom sheet
                          },
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          isScrollControlled: true,
        );
      }
    } catch (e) {
      print(e);
      TLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to load contacts.',
      );
    }
  }

  // ── Dates ─────────────────────────────────────────────────────────────────
  final transactionDate = Rxn<DateTime>();
  final returnDate = Rxn<DateTime>();

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
    if (isSettlement) return transactionDate.value != null;
    return amount.value.isNotEmpty &&
        double.tryParse(amount.value) != null &&
        double.parse(amount.value) > 0 &&
        contact.trim().isNotEmpty &&
        transactionDate.value != null;
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

  void onConfirm() {
    if (!isValid) {
      Get.snackbar(
        'Incomplete',
        isSettlement
            ? 'Please select a settlement date.'
            : contact.isEmpty
            ? 'Please select a contact.'
            : 'Fill in amount, contact, and date.',
        backgroundColor: const Color(0xFF1F1212),
        colorText: const Color(0xFFFF5252),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final typeLabel = selectedType.value.name.capitalizeFirst!;
    final msg = isSettlement
        ? 'Settlement recorded on ${formatDate(transactionDate.value)}'
        : '$typeLabel of ₹${amount.value} with $contact';

    Get.snackbar(
      'Recorded ✓',
      msg,
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
    amountController.addListener(() => amount.value = amountController.text);
    noteController.addListener(() => note.value = noteController.text);
  }

  @override
  void onClose() {
    amountController.dispose();
    addNameController.dispose();
    addPhoneController.dispose();
    searchController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
