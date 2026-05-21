import 'package:expenso/screens/dashboard/lend_borrow.dart';
import 'package:expenso/screens/dashboard/lend_borrow_transaction.dart';
import 'package:expenso/screens/dashboard/manage_contact_screen.dart';
import 'package:expenso/screens/dashboard/record_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────────────────
enum ContactFilter { all, lent, borrowed, settled }

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────
class LedgerData {
  final String name;
  final String initials;
  final String amount;
  final bool isLent;
  final String badge;
  final int badgeColorValue;
  final int badgeBgValue;
  final double progress;
  final String dueLabel;
  final int accentColorValue;
  final int avatarColorValue;
  final int avatarTextColorValue;

  const LedgerData({
    required this.name,
    required this.initials,
    required this.amount,
    required this.isLent,
    required this.badge,
    required this.badgeColorValue,
    required this.badgeBgValue,
    required this.progress,
    required this.dueLabel,
    required this.accentColorValue,
    required this.avatarColorValue,
    required this.avatarTextColorValue,
  });
}

class MovementData {
  final int iconCodePoint;
  final String iconFontFamily;
  final int iconBgValue;
  final int iconColorValue;
  final String title;
  final String subtitle;
  final String amount;
  final bool isCredit;

  const MovementData({
    required this.iconCodePoint,
    required this.iconFontFamily,
    required this.iconBgValue,
    required this.iconColorValue,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isCredit,
  });
}

class ContactData {
  final String name;
  final String initials;
  final String? phone;
  final String? avatarUrl;
  final double amount; // positive = owes you, negative = you owe
  final ContactFilter status;

  const ContactData({
    required this.name,
    required this.initials,
    this.phone,
    this.avatarUrl,
    required this.amount,
    required this.status,
  });

  String get badge {
    switch (status) {
      case ContactFilter.lent:
        return 'LENT';
      case ContactFilter.borrowed:
        return 'BORROWED';
      case ContactFilter.settled:
        return 'SETTLED';
      default:
        return '';
    }
  }

  String get amountLabel {
    if (amount == 0) return '\$0.00';
    final abs = amount.abs().toStringAsFixed(2);
    return amount > 0 ? '\$$abs' : '-\$$abs';
  }

  String get balanceLabel {
    if (amount == 0) return 'NO BALANCE';
    return amount > 0 ? 'OWES YOU' : 'YOU OWE';
  }

  int get badgeColorValue {
    switch (status) {
      case ContactFilter.lent:
        return 0xFF00A651;
      case ContactFilter.borrowed:
        return 0xFFE07B00;
      case ContactFilter.settled:
        return 0xFF6B7280;
      default:
        return 0xFF6B7280;
    }
  }

  int get badgeBgValue {
    switch (status) {
      case ContactFilter.lent:
        return 0xFFE6F4EC;
      case ContactFilter.borrowed:
        return 0xFFFFF0DC;
      case ContactFilter.settled:
        return 0xFFF1F2F4;
      default:
        return 0xFFF1F2F4;
    }
  }

  int get amountColorValue {
    if (amount == 0) return 0xFF374151;
    return amount > 0 ? 0xFF00A651 : 0xFFDC2626;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────────────────────
class LendBorrowController extends GetxController {
  // ── Lend/Borrow Screen ────────────────────────────────────────────────────
  final RxBool showAllLedgers = false.obs;

  static const List<LedgerData> allLedgers = [
    LedgerData(
      name: 'Sarah Jenkins',
      initials: 'SJ',
      amount: '+\$850.00',
      isLent: true,
      badge: 'OVERDUE',
      badgeColorValue: 0xFFFF5252,
      badgeBgValue: 0xFF2A1515,
      progress: 0.0,
      dueLabel: 'Overdue · 5 days',
      accentColorValue: 0xFFFF5252,
      avatarColorValue: 0xFF2A1A1A,
      avatarTextColorValue: 0xFFFF7070,
    ),
    LedgerData(
      name: 'Mike T.',
      initials: 'MT',
      amount: '-\$450.00',
      isLent: false,
      badge: 'DUE SOON',
      badgeColorValue: 0xFFFFB74D,
      badgeBgValue: 0xFF221A08,
      progress: 0.3,
      dueLabel: 'Due in 2 days',
      accentColorValue: 0xFFFFB74D,
      avatarColorValue: 0xFF1E1A08,
      avatarTextColorValue: 0xFFFFB74D,
    ),
    LedgerData(
      name: 'Jessica R.',
      initials: 'JR',
      amount: '+\$1,200.00',
      isLent: true,
      badge: 'ACTIVE',
      badgeColorValue: 0xFF00E676,
      badgeBgValue: 0xFF0D1E14,
      progress: 0.6,
      dueLabel: 'Paid 60%',
      accentColorValue: 0xFF00E676,
      avatarColorValue: 0xFF0D2016,
      avatarTextColorValue: 0xFF00E676,
    ),
    LedgerData(
      name: 'David K.',
      initials: 'DK',
      amount: '+\$320.00',
      isLent: true,
      badge: 'ACTIVE',
      badgeColorValue: 0xFF00E676,
      badgeBgValue: 0xFF0D1E14,
      progress: 0.85,
      dueLabel: 'Almost settled',
      accentColorValue: 0xFF00E676,
      avatarColorValue: 0xFF0D2016,
      avatarTextColorValue: 0xFF00E676,
    ),
    LedgerData(
      name: 'Priya S.',
      initials: 'PS',
      amount: '-\$900.00',
      isLent: false,
      badge: 'PENDING',
      badgeColorValue: 0xFFBB86FC,
      badgeBgValue: 0xFF18102A,
      progress: 0.1,
      dueLabel: 'Due in 2 weeks',
      accentColorValue: 0xFFBB86FC,
      avatarColorValue: 0xFF18102A,
      avatarTextColorValue: 0xFFBB86FC,
    ),
  ];

  static const List<MovementData> movements = [
    MovementData(
      iconCodePoint: 0xe84f,
      iconFontFamily: 'MaterialIcons',
      iconBgValue: 0xFF0D1E14,
      iconColorValue: 0xFF00E676,
      title: 'Repayment from David',
      subtitle: 'Private Loan • 2h ago',
      amount: '+\$200.00',
      isCredit: true,
    ),
    MovementData(
      iconCodePoint: 0xe8cb,
      iconFontFamily: 'MaterialIcons',
      iconBgValue: 0xFF1E1A08,
      iconColorValue: 0xFFFFB74D,
      title: 'Borrowed for Grocery',
      subtitle: 'Lent by Anna • Yesterday',
      amount: '-\$45.20',
      isCredit: false,
    ),
    MovementData(
      iconCodePoint: 0xe88a,
      iconFontFamily: 'MaterialIcons',
      iconBgValue: 0xFF141720,
      iconColorValue: 0xFF9CA3AF,
      title: 'Rent Contribution',
      subtitle: 'Lent to Roommate • 3 days ago',
      amount: '+\$750.00',
      isCredit: true,
    ),
  ];

  List<LedgerData> get visibleLedgers =>
      showAllLedgers.value ? allLedgers : allLedgers.take(3).toList();

  int get hiddenLedgersCount => allLedgers.length - 3;

  void toggleShowAllLedgers() => showAllLedgers.toggle();

  void onNotificationTap() {}

  void onViewAllLedgersTap() => Get.to(() => const ManageContactsScreen());

  void onViewAllMovementsTap() {}

  void onAddFabTap() {
    Get.to(() => RecordTransactionScreen());
  }

  // ── Manage Contacts ────────────────────────────────────────────────────────

  static const _masterContacts = <ContactData>[
    ContactData(
      name: 'Sarah Jenkins',
      initials: 'SJ',
      phone: '+1 555 001 0001',
      amount: 850.00,
      status: ContactFilter.lent,
    ),
    ContactData(
      name: 'Michael Theron',
      initials: 'MT',
      phone: '+1 555 001 0002',
      amount: -450.00,
      status: ContactFilter.borrowed,
    ),
    ContactData(
      name: 'Jessica R.',
      initials: 'JR',
      phone: '+1 555 001 0003',
      amount: 0.00,
      status: ContactFilter.settled,
    ),
    ContactData(
      name: 'David K.',
      initials: 'DK',
      phone: '+1 555 001 0004',
      amount: 320.00,
      status: ContactFilter.lent,
    ),
    ContactData(
      name: 'Priya S.',
      initials: 'PS',
      phone: '+1 555 001 0005',
      amount: -900.00,
      status: ContactFilter.borrowed,
    ),
    ContactData(
      name: 'Anna Williams',
      initials: 'AW',
      phone: '+1 555 001 0006',
      amount: 1200.00,
      status: ContactFilter.lent,
    ),
    ContactData(
      name: 'Raj Patel',
      initials: 'RP',
      phone: '+1 555 001 0007',
      amount: 0.00,
      status: ContactFilter.settled,
    ),
    ContactData(
      name: 'Lena Müller',
      initials: 'LM',
      phone: '+49 555 001 0008',
      amount: -230.00,
      status: ContactFilter.borrowed,
    ),
    ContactData(
      name: 'Tom Chen',
      initials: 'TC',
      phone: '+1 555 001 0009',
      amount: 75.00,
      status: ContactFilter.lent,
    ),
    ContactData(
      name: 'Nina Okafor',
      initials: 'NO',
      phone: '+234 555 001 0010',
      amount: 0.00,
      status: ContactFilter.settled,
    ),
    ContactData(
      name: 'Carlos Ruiz',
      initials: 'CR',
      phone: '+52 555 001 0011',
      amount: -160.00,
      status: ContactFilter.borrowed,
    ),
    ContactData(
      name: 'Fatima Al-Zahra',
      initials: 'FA',
      phone: '+971 555 001 0012',
      amount: 490.00,
      status: ContactFilter.lent,
    ),
  ];

  // Pagination
  static const int pageSize = 6;
  final RxList<ContactData> displayedContacts = <ContactData>[].obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int _currentPage = 0;

  // Filter & search
  final Rx<ContactFilter> activeFilter = ContactFilter.all.obs;
  final RxString searchQuery = ''.obs;

  // Add contact form
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final RxBool isAddingContact = false.obs;

  List<ContactData> get _filteredContacts {
    var list = _masterContacts.toList();
    if (activeFilter.value != ContactFilter.all) {
      list = list.where((c) => c.status == activeFilter.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list
          .where(
            (c) =>
                c.name.toLowerCase().contains(q) || (c.phone ?? '').contains(q),
          )
          .toList();
    }
    return list;
  }

  void onViewLedgerTap() {
    Get.to(
      () => LendBorrowTransaction(
        contact: ContactData(
          name: 'Sarah Jenkins',
          initials: 'SJ',
          phone: '+1 555 001 0001',
          amount: 850.00,
          status: ContactFilter.lent,
        ),
      ),
    );
  }

  void initContactsPage() {
    _currentPage = 0;
    displayedContacts.clear();
    hasMore.value = true;
    _loadNextPage();
  }

  void _loadNextPage() {
    final filtered = _filteredContacts;
    final start = _currentPage * pageSize;
    if (start >= filtered.length) {
      hasMore.value = false;
      return;
    }
    final end = (start + pageSize).clamp(0, filtered.length);
    displayedContacts.addAll(filtered.sublist(start, end));
    _currentPage++;
    hasMore.value = end < filtered.length;
  }

  Future<void> loadMoreContacts() async {
    if (isLoadingMore.value || !hasMore.value) return;
    isLoadingMore.value = true;
    await Future.delayed(const Duration(milliseconds: 700));
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
    if (nameController.text.trim().isEmpty) return;
    isAddingContact.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    // TODO: Push to API, then call initContactsPage()
    nameController.clear();
    phoneController.clear();
    isAddingContact.value = false;
    Get.back();
  }

  void onSyncFromContacts() async {
    final status = await FlutterContacts.permissions.request(
      PermissionType.readWrite,
    );
    if (status == PermissionStatus.granted) {
      // Get all contacts (fast - defaults to IDs and display names only)
      List<Contact> contacts = await FlutterContacts.getAll();

      // Get a specific contact with all properties

      // show bottom sheet with all contact , contact will be displayed in list form with name , phone number and avatar and on tap of any contact it will be selected and bottom sheet will be closed and contact name and phone number will be filled in the text fields above.
      // search to serch in contant on click on any contact bottom sheet will be closed and contact name and phone number will be filled in the text fields above.
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
