import 'package:expenso/controllers/lend_borrow_controller.dart';
import 'package:expenso/models/friend.dart';
import 'package:expenso/screens/dashboard/lend_borrow_transaction.dart';
import 'package:expenso/utils/validator/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LendBorrowScreen extends StatelessWidget {
  LendBorrowScreen({super.key});
  final controller = Get.put<LendBorrowController>(LendBorrowController());

  // ── Design tokens ──────────────────────────────────────────────────────────
  static const _bg = Color(0xFF0D0F14);
  static const _surface = Color(0xFF141720);
  static const _surfaceAlt = Color(0xFF1A1D26);
  static const _border = Color(0x12FFFFFF);
  static const _textMuted = Color(0xFF4B5563);
  static const _textSec = Color(0xFF9CA3AF);
  static const _accent = Color(0xFF00E676);
  static const _accentMid = Color(0xFF00C853);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.loadFriends();
      // controller.initContactsPage();
    });

    final scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 140) {
        controller.loadMoreContacts();
      }
    });

    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: _AddFab(controller: controller),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── App Bar ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ).copyWith(top: 14.h, bottom: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo + title
                  Row(
                    children: [
                      Container(
                        width: 44.w,
                        height: 44.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C853), Color(0xFF00E676)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: _accent.withValues(alpha: 0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Lend & Borrow',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // ── Net Position Hero ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const _NetPositionCard(),
            ),

            SizedBox(height: 14.h),

            // ── Search ─────────────────────────────────────────────────────
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
                  onChanged: controller.onSearchChanged,
                  style: TextStyle(fontSize: 13.sp, color: Colors.white),
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

            SizedBox(height: 12.h),

            // ── Filter Chips ───────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ContactFilter.values.map((f) {
                      final isActive = controller.activeFilter.value == f;
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: _FilterChip(
                          label: _filterLabel(f),
                          isActive: isActive,
                          onTap: () => controller.setFilter(f),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            SizedBox(height: 14.h),

            // ── Section label ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(
                () => Text(
                  controller.showingFavourites.value
                      ? 'FAVOURITES'
                      : 'RECENT INTERACTIONS',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: _textMuted,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            SizedBox(height: 14.h),

            // ── Contact List ───────────────────────────────────────────────
            Expanded(
              child: Obx(() {
                print(controller.isFetchingFriends.value);

                print(controller.displayedFriends.isEmpty);

                print(controller.displayedFriends.length);
                if (controller.isFetchingFriends.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Color(0xFF00E676)),
                    ),
                  );
                }
                if (controller.displayedFriends.isEmpty) {
                  return _EmptyState(
                    isFavourites: controller.showingFavourites.value,
                  );
                } else {
                  return ListView.separated(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ).copyWith(bottom: 110.h),
                    itemCount:
                        controller.displayedFriends.length +
                        (controller.isLoadingMore.value ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      if (index == controller.displayedFriends.length) {
                        return _LoadingTile();
                      }
                      final contact = controller.displayedFriends[index];
                      return _ContactTile(
                        contact: contact,
                        onTap: () => controller.friendTransaction(contact),
                        onFavouriteTap: () => {},
                      );
                    },
                  );
                }
              }),
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
// Net Position Hero Card
// ─────────────────────────────────────────────────────────────────────────────
class _NetPositionCard extends StatelessWidget {
  const _NetPositionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00603A), Color(0xFF00A854), Color(0xFF00E676)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.55, 1.0],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withValues(alpha: 0.30),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -12,
            top: -12,
            child: Icon(
              Icons.handshake_outlined,
              size: 110.sp,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.trending_up_rounded,
                    size: 14.sp,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Net Position',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                '+\$1,240.50',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.2,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'You are owed more than you owe',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white.withValues(alpha: 0.60),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: _NetPill(
                      label: 'LENT',
                      value: '\$2,800.00',
                      icon: Icons.arrow_upward_rounded,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _NetPill(
                      label: 'BORROWED',
                      value: '\$1,559.50',
                      icon: Icons.arrow_downward_rounded,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NetPill extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _NetPill({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 26.w,
            height: 26.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 13.sp, color: Colors.white),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.white.withValues(alpha: 0.70),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
// Contact Tile
// ─────────────────────────────────────────────────────────────────────────────
class _ContactTile extends StatelessWidget {
  final Friends contact;
  final VoidCallback? onTap;
  final VoidCallback? onFavouriteTap;

  const _ContactTile({required this.contact, this.onTap, this.onFavouriteTap});

  @override
  Widget build(BuildContext context) {
    final badgeColor = Color(contact.badgeColorValue);
    final badgeBg = Color(contact.badgeBgValue);
    final amountColor = Color(contact.amountColorValue);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
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

            // Name + status badge
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

            // Favourite star
            // GestureDetector(
            //   onTap: onFavouriteTap,
            //   behavior: HitTestBehavior.opaque,
            //   child: Padding(
            //     padding: EdgeInsets.only(left: 6.w),
            //     child: Icon(
            //       contact.isFavourite
            //           ? Icons.star_rounded
            //           : Icons.star_outline_rounded,
            //       size: 20.sp,
            //       color: contact.isFavourite
            //           ? const Color(0xFF00E676)
            //           : const Color(0xFF374151),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final bool isFavourites;

  const _EmptyState({this.isFavourites = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFavourites
                ? Icons.star_outline_rounded
                : Icons.people_outline_rounded,
            size: 52.sp,
            color: const Color(0xFF2A2D38),
          ),
          SizedBox(height: 14.h),
          Text(
            isFavourites ? 'No favourites yet' : 'No contacts found',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF374151),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            isFavourites
                ? 'Star a contact to pin them here'
                : 'Add a contact using the + button below',
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF2A2D38)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading Tile (pagination spinner)
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
// FAB
// ─────────────────────────────────────────────────────────────────────────────
class _AddFab extends StatelessWidget {
  final LendBorrowController controller;

  const _AddFab({required this.controller});

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
// Add Contact Bottom Sheet
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
  ).then((_) {
    controller.nameController.clear();
    controller.phoneController.clear();
  });
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

          // OR divider
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
          Form(
            key: controller.formKey,
            child: Column(
              children: [
                _DarkTextField(
                  controller: controller.nameController,
                  label: 'Full Name',
                  hint: 'e.g. Sarah Jenkins',
                  icon: Icons.person_outline_rounded,
                  validator: Validators.name,
                ),

                SizedBox(height: 14.h),

                _DarkTextField(
                  controller: controller.phoneController,
                  label: 'Phone Number',
                  hint: 'e.g. 9876543210',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
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
                            color: const Color(
                              0xFF00C853,
                            ).withValues(alpha: 0.35),
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
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
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
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dark Text Field
// ─────────────────────────────────────────────────────────────────────────────
class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _DarkTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
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
        FormField<String>(
          initialValue: controller.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (_) => validator?.call(controller.text),
          builder: (field) {
            final hasError = field.hasError;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D0F14),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: hasError
                          ? const Color(0xFFEF4444)
                          : Colors.white.withValues(alpha: 0.08),
                      width: hasError ? 1.5 : 1.0,
                    ),
                  ),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: keyboardType,
                    onChanged: (_) => field.didChange(controller.text),
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
                        color: hasError
                            ? const Color(0xFFEF4444).withValues(alpha: 0.7)
                            : const Color(0xFF6B7280),
                      ),
                      // Suppress Flutter's built-in error display
                      errorStyle: const TextStyle(height: 0, fontSize: 0),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                  ),
                ),
                // Custom error message
                if (hasError) ...[
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 13,
                        color: Color(0xFFEF4444),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        field.errorText!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFFEF4444),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
