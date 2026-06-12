import 'package:expenso/controllers/lend_borrow_controller.dart';
import 'package:expenso/models/friend.dart';
import 'package:expenso/screens/dashboard/lend_borrow_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Manage Contacts Screen
// ─────────────────────────────────────────────────────────────────────────────
class ManageContactsScreen extends StatelessWidget {
  const ManageContactsScreen({super.key});

  // ── Design tokens (mirrors LendBorrowScreen) ──────────────────────────────
  static const _bg = Color(0xFF0D0F14);
  static const _surface = Color(0xFF141720);
  static const _surfaceAlt = Color(0xFF1A1D26);
  static const _border = Color(0x12FFFFFF); // white 7%
  static const _textPrimary = Colors.white;
  static const _textSecondary = Color(0xFF9CA3AF);
  static const _textMuted = Color(0xFF4B5563);

  @override
  Widget build(BuildContext context) {
    final c = Get.find<LendBorrowController>();

    WidgetsBinding.instance.addPostFrameCallback((_) => c.initContactsPage());

    final scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 140) {
        c.loadMoreContacts();
      }
    });

    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: _ContactFab(controller: c),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ).copyWith(top: 14.h, bottom: 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: _surfaceAlt,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: _border),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 16.sp,
                        color: _textSecondary,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Manage Contacts',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: _textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Lend & Borrow',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: _textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 22.h),

            // ── Search ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(30.r),
                  border: Border.all(color: _border),
                ),
                child: TextField(
                  onChanged: c.onSearchChanged,
                  style: TextStyle(fontSize: 13.sp, color: _textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Search contacts by name...',
                    hintStyle: TextStyle(fontSize: 13.sp, color: _textMuted),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20.sp,
                      color: _textMuted,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 13.h),
                  ),
                ),
              ),
            ),

            SizedBox(height: 18.h),

            // ── Filter Chips ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ContactFilter.values.map((f) {
                      final isActive = c.activeFilter.value == f;
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: _FilterChip(
                          label: _filterLabel(f),
                          isActive: isActive,
                          onTap: () => c.setFilter(f),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // ── Section label ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'RECENT INTERACTIONS',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: _textMuted,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            SizedBox(height: 14.h),

            // ── Paginated List ────────────────────────────────────────────
            Expanded(
              child: Obx(
                () => ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                  ).copyWith(bottom: 110.h),
                  itemCount:
                      c.displayedFriends.length +
                      (c.isLoadingMore.value ? 1 : 0),
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    if (index == c.displayedFriends.length) {
                      return _LoadingTile();
                    }
                    return _ContactTile(
                      contact: c.displayedFriends[index],
                      onTap: () => Get.to(
                        () => LendBorrowTransaction(
                          contact: c.displayedFriends[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _filterLabel(ContactFilter f) {
    switch (f) {
      case ContactFilter.all:
        return 'All';
      case ContactFilter.lent:
        return 'Lent';
      case ContactFilter.borrowed:
        return 'Borrowed';
      case ContactFilter.settled:
        return 'Settled';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter Chip
// ─────────────────────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF00C853).withValues(alpha: 0.15)
              : const Color(0xFF141720),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isActive
                ? const Color(0xFF00E676).withValues(alpha: 0.45)
                : Colors.white.withValues(alpha: 0.07),
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF00C853).withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF00E676) : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Contact Tile  — dark card matching _LedgerCard / _MovementTile style
// ─────────────────────────────────────────────────────────────────────────────
class _ContactTile extends StatelessWidget {
  final Friends contact;
  final VoidCallback? onTap;

  const _ContactTile({required this.contact, this.onTap});

  @override
  Widget build(BuildContext context) {
    final badgeColor = Color(contact.badgeColorValue);
    final badgeBg = Color(contact.badgeBgValue);
    final amountColor = Color(contact.amountColorValue);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF141720),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: badgeColor.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: badgeColor.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badgeBg,
                border: Border.all(
                  color: badgeColor.withValues(alpha: 0.30),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  contact.initials,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: badgeColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            SizedBox(width: 13.w),

            // Name + badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: badgeColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      contact.name,
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w800,
                        color: badgeColor,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Amount + balance label
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  contact.amountLabel,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: amountColor,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  contact.amountLabel,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF4B5563),
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),

            SizedBox(width: 6.w),
            Icon(
              Icons.chevron_right_rounded,
              size: 20.sp,
              color: const Color(0xFF374151),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading Tile
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 18.h),
      child: Center(
        child: SizedBox(
          width: 22.w,
          height: 22.w,
          child: const CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation(Color(0xFF00E676)),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FAB — mirrors _AddFab from LendBorrowScreen
// ─────────────────────────────────────────────────────────────────────────────
class _ContactFab extends StatelessWidget {
  final LendBorrowController controller;

  const _ContactFab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showAddContactSheet(context, controller),
      child: Container(
        width: 58.w,
        height: 58.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00A854), Color(0xFF00E676)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C853).withValues(alpha: 0.40),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          Icons.person_add_alt_1_rounded,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add Contact Bottom Sheet  — dark theme
// ─────────────────────────────────────────────────────────────────────────────
void _showAddContactSheet(
  BuildContext context,
  LendBorrowController controller,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddContactSheet(controller: controller),
  );
}

class _AddContactSheet extends StatelessWidget {
  final LendBorrowController controller;

  const _AddContactSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 20.h,
        bottom: 28.h + bottomInset,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.40),
            blurRadius: 40,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          SizedBox(height: 22.h),

          // Title row
          Row(
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
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E676).withValues(alpha: 0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 18.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Contact',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    'Add manually or sync from your phone',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Sync from contacts
          GestureDetector(
            onTap: controller.onSyncFromContacts,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFF00C853).withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: const Color(0xFF00E676).withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.contacts_rounded,
                    size: 18.sp,
                    color: const Color(0xFF00E676),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Sync from Phone Contacts',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00E676),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 20.h),

          // Divider
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.06),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  'OR ADD MANUALLY',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4B5563),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.06),
                  thickness: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          _DarkTextField(
            controller: controller.nameController,
            label: 'Full Name',
            hint: 'e.g. Sarah Jenkins',
            icon: Icons.person_outline_rounded,
          ),

          SizedBox(height: 14.h),

          _DarkTextField(
            controller: controller.phoneController,
            label: 'Phone Number',
            hint: 'e.g. +1 555 000 0000',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),

          SizedBox(height: 28.h),

          // Submit button
          Obx(
            () => GestureDetector(
              onTap: controller.isAddingContact.value
                  ? null
                  : controller.addContact,
              child: Container(
                width: double.infinity,
                height: 54.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00A854), Color(0xFF00E676)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C853).withValues(alpha: 0.35),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: controller.isAddingContact.value
                      ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Add Contact',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dark text field for the bottom sheet
// ─────────────────────────────────────────────────────────────────────────────
class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  const _DarkTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D0F14),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 13.sp, color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF4B5563),
              ),
              prefixIcon: Icon(
                icon,
                size: 18.sp,
                color: const Color(0xFF6B7280),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14.h),
            ),
          ),
        ),
      ],
    );
  }
}
