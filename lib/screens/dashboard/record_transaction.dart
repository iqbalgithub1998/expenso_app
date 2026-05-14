import 'package:expenso/controllers/record_transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecordTransactionScreen extends StatelessWidget {
  RecordTransactionScreen({super.key});
  final c = Get.put<RecordTransactionController>(RecordTransactionController());

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
              delegate: _StickyTopBar(height: 40.h + 28.h),
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
                              c.selectedType.value == TransactionType.lend
                                  ? 'LEND MONEY'
                                  : c.selectedType.value ==
                                        TransactionType.borrow
                                  ? 'BORROW MONEY'
                                  : 'SETTLEMENT',
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
                          'Transaction',
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
                        'Track your social finances with ease.',
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

            // ── Contact — always visible ───────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                child: Obx(
                  () => _ContactField(
                    selectedFriend: c.selectedFriend.value,
                    accentColor: c.accentColor,
                    onTap: () => _showFriendPickerSheet(context, c),
                  ),
                ),
              ),
            ),

            // ── Fields below hidden for settlement ─────────────────────────
            SliverToBoxAdapter(
              child: Obx(
                () => AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  sizeCurve: Curves.easeOutCubic,
                  crossFadeState: c.isSettlement
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Column(
                    children: [
                      // Date fields row
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _DateTile(
                                label: 'When?',
                                value: c.formatDate(c.transactionDate.value),
                                isEmpty: c.transactionDate.value == null,
                                icon: Icons.calendar_today_rounded,
                                iconColor: const Color(0xFFFFB74D),
                                iconBg: const Color(0xFF1E1A12),
                                onTap: () => c.pickTransactionDate(context),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: _DateTile(
                                label: 'Return',
                                value: c.formatDate(c.returnDate.value),
                                isEmpty: c.returnDate.value == null,
                                icon: Icons.event_available_rounded,
                                iconColor: const Color(0xFF00E676),
                                iconBg: const Color(0xFF0D1F15),
                                onTap: () => c.pickReturnDate(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Category card
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                        child: _CategoryCard(
                          selected: c.selectedCategories,
                          onToggle: c.toggleCategory,
                          accentColor: c.accentColor,
                        ),
                      ),
                      // Note field
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                        child: _NoteField(controller: c.noteController),
                      ),
                      // Reminder
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                        child: _ReminderTile(
                          enabled: c.reminderEnabled.value,
                          onToggle: (v) => c.reminderEnabled.value = v,
                          accentColor: c.accentColor,
                        ),
                      ),
                    ],
                  ),
                  secondChild: const SizedBox.shrink(),
                ),
              ),
            ),

            // ── Confirm ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 40.h),
                child: Obx(
                  () => _ConfirmButton(
                    gradient: c.accentGradient,
                    accentColor: c.accentColor,
                    isSettlement: c.isSettlement,
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
// Pinned top bar delegate
// ─────────────────────────────────────────────────────────────────────────────
class _StickyTopBar extends SliverPersistentHeaderDelegate {
  // Height is passed in from the widget tree where ScreenUtil is available,
  // so min/maxExtent always matches what the content actually paints.
  final double height;
  const _StickyTopBar({required this.height});

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
          // Back button
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
          // Logo + name

          // Mirror of back button width for centering
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyTopBar old) => old.height != height;
}

// ─────────────────────────────────────────────────────────────────────────────
// Type Selector — horizontal cards
// ─────────────────────────────────────────────────────────────────────────────
class _TypeSelector extends StatelessWidget {
  final TransactionType selected;
  final void Function(TransactionType) onSelect;
  const _TypeSelector({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TypeCard(
          type: TransactionType.lend,
          selected: selected == TransactionType.lend,
          icon: Icons.upload_rounded,
          emoji: '↑',
          label: 'Lend\nMoney',
          sub: 'Someone\nowes you',
          gradient: const [Color(0xFF7C3AED), Color(0xFFBB86FC)],
          glow: const Color(0xFFBB86FC),
          onTap: () => onSelect(TransactionType.lend),
        ),
        SizedBox(width: 8.w),
        _TypeCard(
          type: TransactionType.borrow,
          selected: selected == TransactionType.borrow,
          icon: Icons.download_rounded,
          emoji: '↓',
          label: 'Borrow\nMoney',
          sub: 'You owe\nsomeone',
          gradient: const [Color(0xFF00603A), Color(0xFF00E676)],
          glow: const Color(0xFF00E676),
          onTap: () => onSelect(TransactionType.borrow),
        ),
        SizedBox(width: 8.w),
        _TypeCard(
          type: TransactionType.settlement,
          selected: selected == TransactionType.settlement,
          icon: Icons.handshake_outlined,
          emoji: '✓',
          label: 'Settle\nment',
          sub: 'Clear the\ndebt',
          gradient: const [Color(0xFF005B4F), Color(0xFF00BFA5)],
          glow: const Color(0xFF00BFA5),
          onTap: () => onSelect(TransactionType.settlement),
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final TransactionType type;
  final bool selected;
  final IconData icon;
  final String emoji;
  final String label;
  final String sub;
  final List<Color> gradient;
  final Color glow;
  final VoidCallback onTap;

  const _TypeCard({
    required this.type,
    required this.selected,
    required this.icon,
    required this.emoji,
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
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
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
                      blurRadius: 20,
                      spreadRadius: -2,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              // Icon container
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 44.w,
                height: 44.h,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.20)
                      : glow.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20.sp,
                  color: selected ? Colors.white : glow,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : const Color(0xFF9CA3AF),
                  height: 1.3,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                sub,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.5.sp,
                  color: selected
                      ? Colors.white.withValues(alpha: 0.65)
                      : const Color(0xFF4B5563),
                  height: 1.4,
                ),
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
        _SectionLabel('How much?'),
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
// Contact Field
// ─────────────────────────────────────────────────────────────────────────────
// ── Helper — opens the friend picker sheet ────────────────────────────────────
void _showFriendPickerSheet(
  BuildContext context,
  RecordTransactionController c,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _FriendPickerSheet(controller: c),
  );
}

// ── Helper — opens add-contact sheet on top of picker ────────────────────────
void _showAddContactSheet(BuildContext context, RecordTransactionController c) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddContactSheet(controller: c),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Contact Field — tappable selector (no text input)
// ─────────────────────────────────────────────────────────────────────────────
class _ContactField extends StatelessWidget {
  final Friends? selectedFriend;
  final Color accentColor;
  final VoidCallback onTap;

  const _ContactField({
    required this.selectedFriend,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasSelected = selectedFriend != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('With whom?'),
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
                color: hasSelected
                    ? accentColor.withValues(alpha: 0.35)
                    : Colors.white.withValues(alpha: 0.07),
              ),
            ),
            child: Row(
              children: [
                // Avatar or icon
                hasSelected
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
                            selectedFriend!.initials,
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
                // Name + number or placeholder
                Expanded(
                  child: hasSelected
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedFriend!.name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              selectedFriend!.number,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF4B5563),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Select contact',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF4B5563),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
                // Trailing icon
                hasSelected
                    ? GestureDetector(
                        onTap:
                            (context
                                        .findAncestorWidgetOfExactType<
                                          _ContactField
                                        >()
                                    as dynamic)
                                ?.controller
                                ?.clear,
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 18.sp,
                          color: accentColor,
                        ),
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
// Friend Picker Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _FriendPickerSheet extends StatelessWidget {
  final RecordTransactionController controller;
  const _FriendPickerSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 0,
        bottom: 24.h + bottomInset,
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
          // Handle
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
                'Select Contact',
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
                  _showAddContactSheet(context, c);
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
                      hintText: 'Search name or number...',
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

          // Friends list
          Flexible(
            child: Obx(() {
              final list = c.filteredFriends;
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
                  final f = list[i];
                  final isSelected =
                      c.selectedFriend.value?.name == f.name &&
                      c.selectedFriend.value?.number == f.number;
                  return GestureDetector(
                    onTap: () => c.selectFriend(f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? c.accentColor.withValues(alpha: 0.10)
                            : const Color(0xFF141720),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSelected
                              ? c.accentColor.withValues(alpha: 0.35)
                              : Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 42.w,
                            height: 42.h,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isSelected
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
                                f.initials,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: isSelected
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
                                  f.name,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  f.number,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
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
// Add Contact Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _AddContactSheet extends StatelessWidget {
  final RecordTransactionController controller;
  const _AddContactSheet({required this.controller});

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

          // Sync from contacts button
          GestureDetector(
            onTap: c.onSyncFromContacts,
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

          _DarkTextField(
            controller: c.addNameController,
            label: 'Full Name',
            hint: 'e.g. Arjun Mehta',
            icon: Icons.person_outline_rounded,
            iconColor: const Color(0xFF00E676),
          ),

          SizedBox(height: 14.h),

          _DarkTextField(
            controller: c.addPhoneController,
            label: 'Phone Number',
            hint: 'e.g. +91 98765 43210',
            icon: Icons.phone_outlined,
            iconColor: const Color(0xFFBB86FC),
            keyboardType: TextInputType.phone,
          ),

          SizedBox(height: 28.h),

          // Submit
          Obx(
            () => GestureDetector(
              onTap: c.isAddingContact.value ? null : c.addContact,
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
                  child: c.isAddingContact.value
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
// Dark text field used inside _AddContactSheet
// ─────────────────────────────────────────────────────────────────────────────
class _DarkTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final TextInputType keyboardType;

  const _DarkTextField({
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: const Color(0xFF141720),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
                letterSpacing: 0.3,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(9.r),
                  ),
                  child: Icon(icon, size: 15.sp, color: iconColor),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isEmpty ? const Color(0xFF4B5563) : Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Card
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryCard extends StatelessWidget {
  final RxSet<TransactionCategory> selected;
  final void Function(TransactionCategory) onToggle;
  final Color accentColor;

  const _CategoryCard({
    required this.selected,
    required this.onToggle,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final cats = [
      (TransactionCategory.dining, Icons.restaurant_outlined, 'Dining'),
      (TransactionCategory.shopping, Icons.shopping_bag_outlined, 'Shopping'),
      (TransactionCategory.travel, Icons.flight_outlined, 'Travel'),
      (TransactionCategory.entertainment, Icons.tv_outlined, 'Entertain'),
      (TransactionCategory.health, Icons.favorite_outline_rounded, 'Health'),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4.w,
                height: 14.h,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Category & Purpose',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF9CA3AF),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              ...cats.map(
                (t) => _CategoryPill(
                  icon: t.$2,
                  label: t.$3,
                  selected: selected.contains(t.$1),
                  accentColor: accentColor,
                  onTap: () => onToggle(t.$1),
                ),
              ),
              _PlusPill(),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color accentColor;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.icon,
    required this.label,
    required this.selected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? accentColor.withValues(alpha: 0.14)
              : const Color(0xFF1A1D26),
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: selected
                ? accentColor.withValues(alpha: 0.50)
                : Colors.white.withValues(alpha: 0.07),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 12.sp,
              color: selected ? accentColor : const Color(0xFF6B7280),
            ),
            SizedBox(width: 5.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: selected ? accentColor : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlusPill extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 34.w,
        height: 34.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D26),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Icon(
          Icons.add_rounded,
          size: 15.sp,
          color: const Color(0xFF6B7280),
        ),
      ),
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
    return Container(
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
          hintText: 'Add a note — what was this for?',
          hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF4B5563)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 10.w, top: 14.h),
            child: Icon(
              Icons.edit_note_rounded,
              size: 20.sp,
              color: const Color(0xFF374151),
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          border: InputBorder.none,
          contentPadding: EdgeInsets.fromLTRB(0, 14.h, 16.w, 14.h),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reminder Tile
// ─────────────────────────────────────────────────────────────────────────────
class _ReminderTile extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final Color accentColor;

  const _ReminderTile({
    required this.enabled,
    required this.onToggle,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: enabled
            ? accentColor.withValues(alpha: 0.10)
            : const Color(0xFF141720),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: enabled
              ? accentColor.withValues(alpha: 0.30)
              : Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(Icons.alarm_rounded, size: 20.sp, color: accentColor),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set Repayment Reminder',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  "Notify me when it's time to settle",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: enabled,
            onChanged: onToggle,
            activeColor: Colors.white,
            activeTrackColor: accentColor,
            inactiveThumbColor: const Color(0xFF4B5563),
            inactiveTrackColor: const Color(0xFF1A1D26),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Confirm Button
// ─────────────────────────────────────────────────────────────────────────────
class _ConfirmButton extends StatelessWidget {
  final List<Color> gradient;
  final Color accentColor;
  final bool isSettlement;
  final VoidCallback onTap;

  const _ConfirmButton({
    required this.gradient,
    required this.accentColor,
    required this.isSettlement,
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
                isSettlement ? Icons.handshake_outlined : Icons.check_rounded,
                size: 14.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              isSettlement ? 'Confirm Settlement' : 'Confirm Transaction',
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
// Shared section label
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

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
