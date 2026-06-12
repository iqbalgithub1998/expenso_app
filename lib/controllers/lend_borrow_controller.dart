import 'package:expenso/models/friend.dart';
import 'package:expenso/models/lend_borrow_transaction_model.dart' as model;
import 'package:expenso/repositories/friends_repository.dart';
import 'package:expenso/screens/dashboard/lend_borrow_transaction.dart';
import 'package:expenso/screens/dashboard/manage_contact_screen.dart';
import 'package:expenso/screens/dashboard/record_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────────────────
enum ContactFilter { all, lent, borrowed, settled }

// ─────────────────────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────────────────────
class LendBorrowController extends GetxController {
  // ── Lend/Borrow Screen ────────────────────────────────────────────────────
  final RxBool showAllLedgers = false.obs;
  final RxBool isLoadingTransactions = false.obs;
  final RxList<TxDay> friendTxDays = <TxDay>[].obs;

  void toggleShowAllLedgers() => showAllLedgers.toggle();

  void onNotificationTap() {}

  void onViewAllLedgersTap() => Get.to(() => const ManageContactsScreen());

  void onViewAllMovementsTap() {}

  void onAddFabTap(String friendId) {
    Get.to(() => RecordTransactionScreen(friendId: friendId));
  }

  // ── Repository ───────────────────────────────────────────────────────────
  final _friendsRepo = Get.put(FriendsRepository());

  // Pagination
  static const int pageSize = 6;
  final RxList<Friends> displayedFriends = <Friends>[].obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  final RxBool showingFavourites = false.obs;
  final RxBool isFetchingFriends = false.obs;
  int _currentPage = 0;

  // Filter & search
  final Rx<ContactFilter> activeFilter = ContactFilter.all.obs;
  final RxString searchQuery = ''.obs;

  // Add contact form
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final RxBool isAddingContact = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ── Phone contact picker ──────────────────────────────────────────────────
  final RxList<Contact> phoneContacts = <Contact>[].obs;
  final RxString contactSearchQuery = ''.obs;
  final RxBool isFetchingPhoneContacts = false.obs;

  void onViewLedgerTap([Friends? friend]) {
    final f =
        friend ??
        Friends(
          id: 'demo',
          ownerId: 'demo',
          name: 'Sarah Jenkins',
          number: '+1 555 001 0001',
          closingBalance: 850.00,
        );
    Get.to(() => LendBorrowTransaction(contact: f));
  }

  void onFavouritesTap() {
    showingFavourites.value = !showingFavourites.value;
  }

  // ── Load friends from Supabase ────────────────────────────────────────────
  Future<void> loadFriends() async {
    isFetchingFriends.value = true;
    try {
      final friends = await _friendsRepo.fetchFriends();
      displayedFriends.value = friends;
      print(displayedFriends);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load contacts: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1A1D26),
        colorText: const Color(0xFFEF4444),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isFetchingFriends.value = false;
    }
  }

  void initContactsPage() {
    _currentPage = 0;
    displayedFriends.clear();
    hasMore.value = true;
    _loadNextPage();
  }

  // ── Build filtered + searched list from _allFriends ───────────────────────
  List<Friends> get _filteredContacts {
    return displayedFriends;
    // return displayedFriends
    //     .where((f) {
    //       // search
    //       if (searchQuery.isNotEmpty) {
    //         final q = searchQuery.value.toLowerCase();
    //         if (!f.name.toLowerCase().contains(q) &&
    //             !f.number.toLowerCase().contains(q)) {
    //           return false;
    //         }
    //       }
    //       // filter
    //       switch (activeFilter.value) {
    //         case ContactFilter.lent:
    //           return f.closingBalance > 0;
    //         case ContactFilter.borrowed:
    //           return f.closingBalance < 0;
    //         case ContactFilter.settled:
    //           return f.closingBalance == 0;
    //         case ContactFilter.all:
    //           return true;
    //       }
    //     })
    //     .map(_toContactData)
    //     .toList();
  }

  void _loadNextPage() {
    final filtered = _filteredContacts;
    final start = _currentPage * pageSize;
    if (start >= filtered.length) {
      hasMore.value = false;
      return;
    }
    final end = (start + pageSize).clamp(0, filtered.length);
    displayedFriends.addAll(filtered.sublist(start, end));
    _currentPage++;
    hasMore.value = end < filtered.length;
  }

  Future<void> friendTransaction(Friends friend) async {
    isLoadingTransactions.value = true;
    friendTxDays.clear(); // Clear previous transactions before loading new ones
    Get.to(() => LendBorrowTransaction(contact: friend));
    await refreshCurrentFriendTransactions(friend.id);
  }

  Future<void> refreshCurrentFriendTransactions(String friendId) async {
    try {
      isLoadingTransactions.value = true;
      final rawTransactions = await _friendsRepo.fetchTransactionsByFriendId(
        friendId: friendId,
        limit: 50,
        offset: 0,
      );

      final List<model.LendBorrowTransaction> txList = rawTransactions
          .map((tx) => model.LendBorrowTransaction.fromJson(tx))
          .toList();

      final Map<String, List<TxMessage>> grouped = {};

      for (final tx in txList) {
        final dateLabel = _getDateLabel(tx.whenDate);
        final msg = TxMessage(
          amount: _formatAmount(tx.amount),
          note: tx.note ?? "",
          time: _getTimeLabel(tx.createdAt),
          type: _mapType(tx.type),
          whenDate: tx.whenDate,
          returnDate: tx.returnDate,
        );
        if (!grouped.containsKey(dateLabel)) {
          grouped[dateLabel] = [];
        }
        grouped[dateLabel]!.add(msg);
      }

      final List<TxDay> days = grouped.entries.map((entry) {
        return TxDay(
          dateLabel: entry.key,
          messages: entry.value.reversed.toList(),
        );
      }).toList();

      friendTxDays.value = days;
    } catch (e) {
      debugPrint('Error loading transactions: $e');
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final compareDate = DateTime(date.year, date.month, date.day);

    if (compareDate == today) {
      return 'TODAY';
    } else if (compareDate == yesterday) {
      return 'YESTERDAY';
    } else {
      if (date.year == now.year) {
        return DateFormat('EEEE, MMM d').format(date).toUpperCase();
      } else {
        return DateFormat('EEEE, MMM d, yyyy').format(date).toUpperCase();
      }
    }
  }

  String _getTimeLabel(DateTime dateTime) {
    return DateFormat('h:mm a').format(dateTime);
  }

  TxType _mapType(String dbType) {
    switch (dbType) {
      case 'lend':
        return TxType.lent;
      case 'borrow':
        return TxType.borrowed;
      case 'settlement':
      default:
        return TxType.settled;
    }
  }

  String _formatAmount(String amountStr) {
    final parsed = double.tryParse(amountStr) ?? 0.0;
    return '₹${parsed.toStringAsFixed(2)}';
  }

  Future<void> loadMoreContacts() async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    _loadNextPage();
    isLoadingMore.value = false;
  }

  void setFilter(ContactFilter filter) {
    activeFilter.value = filter;
    initContactsPage();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
    initContactsPage();
  }

  Future<void> addContact() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    isAddingContact.value = true;

    try {
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();

      // 1. Check if a friend with this phone already exists
      final exists = await _friendsRepo.friendExistsByPhone(phone);
      if (exists) {
        Get.snackbar(
          'Already Added',
          'A contact with this phone number already exists.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1A1D26),
          colorText: const Color(0xFFFFB74D),
          duration: const Duration(seconds: 3),
        );
        return;
      }

      // 2. Check if the phone belongs to a registered user (link accounts)
      final linkedUserId = await _friendsRepo.findLinkedUserId(phone);

      // 3. Insert the new friend into Supabase
      await _friendsRepo.addFriend(
        name: name,
        phone: phone,
        linkedUserId: linkedUserId,
      );

      // 4. Reload friends list from Supabase and refresh UI
      await loadFriends();
      initContactsPage();

      nameController.clear();
      phoneController.clear();
      Get.back();

      Get.snackbar(
        'Contact Added',
        '$name has been added to your friend list.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1A1D26),
        colorText: const Color(0xFF00E676),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add contact: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1A1D26),
        colorText: const Color(0xFFEF4444),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isAddingContact.value = false;
    }
  }

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
    nameController.text = contact.displayName ?? "";
    if (contact.phones.isNotEmpty) {
      phoneController.text = contact.phones.first.number.replaceAll(" ", "");
    } else {
      phoneController.clear();
    }
    Get.back();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Contact Picker Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _ContactPickerSheet extends StatelessWidget {
  final LendBorrowController controller;

  const _ContactPickerSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C853), Color(0xFF00E676)],
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
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF00E676)),
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
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
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
