import 'package:expenso/controllers/card_usage_controller.dart';
import 'package:expenso/models/friend.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CardUsageScreen extends StatelessWidget {
  CardUsageScreen({super.key});
  final c = Get.put(CardUsageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Pinned top bar ─────────────────────────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _CardUsageTopBar(height: 40.h + 28.h),
            ),

            // ── Hero heading ───────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Accent pill
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: c.accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: c.accentColor.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                color: c.accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              c.isUsed ? 'CARD USAGE' : 'CARD PAYMENT',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: c.accentColor,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Record',
                        style: TextStyle(
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1.2,
                          height: 1.0,
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: c.accentGradient,
                        ).createShader(bounds),
                        child: Text(
                          c.isUsed ? 'Card Usage' : 'Card Payment',
                          style: TextStyle(
                            fontSize: 34.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1.2,
                            height: 1.1,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        c.isUsed
                            ? 'Log a credit card spend.'
                            : 'Record a payment made to your card.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Type selector ──────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 26.h, 20.w, 0),
                child: Obx(
                  () => _TypeSelector(
                    selected: c.selectedType.value,
                    onSelect: c.selectType,
                  ),
                ),
              ),
            ),

            // ── Amount — always visible ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                child: Obx(
                  () => _AmountField(
                    controller: c.amountController,
                    accentColor: c.accentColor,
                  ),
                ),
              ),
            ),

            // ── Used-only fields (Who used, Date, Note) ────────────────────
            SliverToBoxAdapter(
              child: Obx(
                () => AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  sizeCurve: Curves.easeOutCubic,
                  crossFadeState: c.isUsed
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                  firstChild: Column(
                    children: [
                      // Who used
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                        child: Obx(
                          () => _WhoUsedField(
                            selectedUser: c.selectedUser.value,
                            accentColor: c.accentColor,
                            onTap: () => _showUserPickerSheet(context, c),
                          ),
                        ),
                      ),
                      // Date
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                        child: Obx(
                          () => _DateTile(
                            label: 'Date of Use',
                            value: c.formatDate(c.usageDate.value),
                            isEmpty: c.usageDate.value == null,
                            icon: Icons.calendar_today_rounded,
                            iconColor: const Color(0xFFFFB74D),
                            iconBg: const Color(0xFF1E1A12),
                            onTap: () => c.pickDate(context),
                          ),
                        ),
                      ),
                      // Note
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                        child: _NoteField(controller: c.noteController),
                      ),
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ),
            ),

            // ── Confirm button ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 40.h),
                child: Obx(
                  () => _ConfirmButton(
                    gradient: c.accentGradient,
                    accentColor: c.accentColor,
                    isUsed: c.isUsed,
                    onTap: c.onConfirm,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pinned top bar
// ─────────────────────────────────────────────────────────────────────────────
class _CardUsageTopBar extends SliverPersistentHeaderDelegate {
  final double height;
  const _CardUsageTopBar({required this.height});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final bool pinned = shrinkOffset > 0 || overlapsContent;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      height: height,
      decoration: BoxDecoration(
        color: pinned
            ? const Color(0xFF0D0F14).withValues(alpha: 0.97)
            : Colors.transparent,
        border: pinned
            ? Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 1,
                ),
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D26),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: const Color(0xFF9CA3AF),
                size: 16.sp,
              ),
            ),
          ),

          SizedBox(width: 40.w), // balance
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_CardUsageTopBar old) => old.height != height;
}

// ─────────────────────────────────────────────────────────────────────────────
// Type Selector — Used / Paid
// ─────────────────────────────────────────────────────────────────────────────
class _TypeSelector extends StatelessWidget {
  final CardEntryType selected;
  final void Function(CardEntryType) onSelect;
  const _TypeSelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TypeCard(
          type: CardEntryType.used,
          selected: selected == CardEntryType.used,
          icon: Icons.shopping_cart_checkout_rounded,
          label: 'Card\nUsed',
          sub: 'Spent on\ncard',
          gradient: const [Color(0xFFB71C1C), Color(0xFFFF5252)],
          glow: const Color(0xFFFF5252),
          onTap: () => onSelect(CardEntryType.used),
        ),
        SizedBox(width: 12.w),
        _TypeCard(
          type: CardEntryType.paid,
          selected: selected == CardEntryType.paid,
          icon: Icons.payments_rounded,
          label: 'Card\nPaid',
          sub: 'Payment\nmade',
          gradient: const [Color(0xFF00603A), Color(0xFF00E676)],
          glow: const Color(0xFF00E676),
          onTap: () => onSelect(CardEntryType.paid),
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final CardEntryType type;
  final bool selected;
  final IconData icon;
  final String label;
  final String sub;
  final List<Color> gradient;
  final Color glow;
  final VoidCallback onTap;

  const _TypeCard({
    required this.type,
    required this.selected,
    required this.icon,
    required this.label,
    required this.sub,
    required this.gradient,
    required this.glow,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: selected ? null : const Color(0xFF141720),
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: selected
                  ? Colors.transparent
                  : Colors.white.withValues(alpha: 0.06),
              width: 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: glow.withValues(alpha: 0.35),
                      blurRadius: 22,
                      spreadRadius: -2,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.18)
                      : glow.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  icon,
                  size: 22.sp,
                  color: selected ? Colors.white : glow,
                ),
              ),
              SizedBox(width: 14.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: selected ? Colors.white : const Color(0xFF9CA3AF),
                      height: 1.25,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    sub,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: selected
                          ? Colors.white.withValues(alpha: 0.60)
                          : const Color(0xFF4B5563),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Amount Field
// ─────────────────────────────────────────────────────────────────────────────
class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final Color accentColor;
  const _AmountField({required this.controller, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label('How much?'),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: const Color(0xFF141720),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '₹',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w800,
                  color: accentColor,
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                  ],
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Who Used — tappable selector (same as _ContactField pattern)
// ─────────────────────────────────────────────────────────────────────────────
void _showUserPickerSheet(BuildContext context, CardUsageController c) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _UserPickerSheet(controller: c),
  );
}

void _showAddUserSheet(BuildContext context, CardUsageController c) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddUserSheet(controller: c),
  );
}

class _WhoUsedField extends StatelessWidget {
  final Friends? selectedUser;
  final Color accentColor;
  final VoidCallback onTap;

  const _WhoUsedField({
    required this.selectedUser,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool has = selectedUser != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label('Who used?'),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFF141720),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: has
                    ? accentColor.withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.07),
              ),
            ),
            child: Row(
              children: [
                has
                    ? Container(
                        width: 38.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withValues(alpha: 0.70),
                              accentColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        child: Center(
                          child: Text(
                            selectedUser!.initials,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Container(
                        width: 38.w,
                        height: 38.h,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(11.r),
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          size: 18.sp,
                          color: accentColor,
                        ),
                      ),
                SizedBox(width: 12.w),
                Expanded(
                  child: has
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedUser!.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              selectedUser!.number,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF4B5563),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Select person (optional)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF4B5563),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
                has
                    ? Icon(
                        Icons.check_circle_rounded,
                        size: 18.sp,
                        color: accentColor,
                      )
                    : Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20.sp,
                        color: const Color(0xFF4B5563),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// User Picker Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _UserPickerSheet extends StatelessWidget {
  final CardUsageController controller;
  const _UserPickerSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 0,
        bottom: 24.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F14),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Who used the card?',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.4,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                  _showAddUserSheet(context, c);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: c.accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: c.accentColor.withValues(alpha: 0.30),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add_rounded,
                        size: 13.sp,
                        color: c.accentColor,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Add New',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: c.accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Search
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFF141720),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  size: 18.sp,
                  color: const Color(0xFF4B5563),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: TextField(
                    controller: c.searchController,
                    onChanged: c.onSearchChanged,
                    style: TextStyle(fontSize: 13.sp, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search name...',
                      hintStyle: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF4B5563),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // List
          Flexible(
            child: Obx(() {
              final list = c.filteredUsers;
              if (list.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.h),
                  child: Column(
                    children: [
                      Icon(
                        Icons.person_search_rounded,
                        size: 36.sp,
                        color: const Color(0xFF374151),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'No contacts found',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF4B5563),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: list.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (_, i) {
                  final u = list[i];
                  final isSel = c.selectedUser.value?.id == u.id;
                  return GestureDetector(
                    onTap: () => c.selectUser(u),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSel
                            ? c.accentColor.withValues(alpha: 0.10)
                            : const Color(0xFF141720),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSel
                              ? c.accentColor.withValues(alpha: 0.35)
                              : Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42.w,
                            height: 42.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isSel
                                    ? [
                                        c.accentColor.withValues(alpha: 0.70),
                                        c.accentColor,
                                      ]
                                    : [
                                        const Color(0xFF1E1B2E),
                                        const Color(0xFF2A2D3A),
                                      ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(13.r),
                            ),
                            child: Center(
                              child: Text(
                                u.initials,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isSel
                                      ? Colors.white
                                      : const Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  u.name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  u.number,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSel)
                            Icon(
                              Icons.check_circle_rounded,
                              size: 18.sp,
                              color: c.accentColor,
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
}

// ─────────────────────────────────────────────────────────────────────────────
// Add User Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _AddUserSheet extends StatelessWidget {
  final CardUsageController controller;
  const _AddUserSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
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
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB71C1C), Color(0xFFFF5252)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF5252).withValues(alpha: 0.30),
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
                    'Add Person',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    'Add someone who used this card',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 28.h),
          _SheetTextField(
            controller: c.addNameController,
            label: 'Full Name',
            hint: 'e.g. Priya Shah',
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFFFF5252),
          ),
          SizedBox(height: 14.h),
          _SheetTextField(
            controller: c.addPhoneController,
            label: 'Phone Number (optional)',
            hint: 'e.g. +91 98765 43210',
            icon: Icons.phone_outlined,
            iconColor: const Color(0xFFBB86FC),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: 28.h),
          Obx(
            () => GestureDetector(
              onTap: c.isAddingUser.value ? null : c.addUser,
              child: Container(
                width: double.infinity,
                height: 54.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB71C1C), Color(0xFFFF5252)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF5252).withValues(alpha: 0.30),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: c.isAddingUser.value
                      ? SizedBox(
                          width: 22.w,
                          height: 22.w,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          'Add Person',
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
// Date Tile
// ─────────────────────────────────────────────────────────────────────────────
class _DateTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isEmpty;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.value,
    required this.isEmpty,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(label),
        SizedBox(height: 10.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: const Color(0xFF141720),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(icon, size: 16.sp, color: iconColor),
                ),
                SizedBox(width: 12.w),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isEmpty ? const Color(0xFF4B5563) : Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Note Field
// ─────────────────────────────────────────────────────────────────────────────
class _NoteField extends StatelessWidget {
  final TextEditingController controller;
  const _NoteField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label('Note'),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF141720),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
          ),
          child: TextField(
            controller: controller,
            maxLines: 3,
            style: TextStyle(fontSize: 13.sp, color: Colors.white, height: 1.6),
            decoration: InputDecoration(
              hintText: 'What was this for?',
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF4B5563),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 10.w, top: 14.h),
                child: Icon(
                  Icons.edit_note_rounded,
                  size: 20.sp,
                  color: const Color(0xFF374151),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(0, 14.h, 16.w, 14.h),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Confirm Button
// ─────────────────────────────────────────────────────────────────────────────
class _ConfirmButton extends StatelessWidget {
  final List<Color> gradient;
  final Color accentColor;
  final bool isUsed;
  final VoidCallback onTap;

  const _ConfirmButton({
    required this.gradient,
    required this.accentColor,
    required this.isUsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(22.r),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.35),
              blurRadius: 28,
              spreadRadius: -4,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 26.w,
              height: 26.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.20),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isUsed
                    ? Icons.shopping_cart_checkout_rounded
                    : Icons.check_rounded,
                size: 14.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              isUsed ? 'Record Usage' : 'Record Payment',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared text field for sheets
// ─────────────────────────────────────────────────────────────────────────────
class _SheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final TextInputType keyboardType;

  const _SheetTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.iconColor,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6B7280),
            letterSpacing: 0.2,
          ),
        ),
        SizedBox(height: 7.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D0F14),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: EdgeInsets.all(10.w),
                width: 30.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, size: 15.sp, color: iconColor),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 50.w),
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF374151),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 15.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared section label
// ─────────────────────────────────────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF6B7280),
        letterSpacing: 0.3,
      ),
    );
  }
}
