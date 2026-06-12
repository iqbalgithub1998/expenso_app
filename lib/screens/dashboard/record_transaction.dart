import 'package:expenso/controllers/record_transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecordTransactionScreen extends StatelessWidget {
  RecordTransactionScreen({super.key, required this.friendId});

  final String friendId;
  final c = Get.put<RecordTransactionController>(RecordTransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080A10),
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
                padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 0),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status pill with animated glow dot
                      _GlowPill(
                        label: c.selectedType.value == TransactionType.lend
                            ? 'LENDING MONEY'
                            : c.selectedType.value == TransactionType.borrow
                            ? 'BORROWING MONEY'
                            : 'SETTLEMENT',
                        accentColor: c.accentColor,
                      ),
                      SizedBox(height: 14.h),
                      // Headline
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Record\n',
                              style: TextStyle(
                                fontSize: 38.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -1.5,
                                height: 1.05,
                              ),
                            ),
                            WidgetSpan(
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  colors: c.accentGradient,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ).createShader(bounds),
                                child: Text(
                                  'Transaction',
                                  style: TextStyle(
                                    fontSize: 38.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -1.5,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Track your social finances with ease.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF4B5563),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
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
                padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 0),
                child: Obx(
                  () => _TypeSelector(
                    selected: c.selectedType.value,
                    onSelect: c.selectType,
                  ),
                ),
              ),
            ),

            // ── Amount ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(22.w, 20.h, 22.w, 0),
                child: Obx(
                  () => _AmountField(
                    controller: c.amountController,
                    accentColor: c.accentColor,
                    gradient: c.accentGradient,
                  ),
                ),
              ),
            ),

            // ── Conditional fields ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Obx(
                () => AnimatedCrossFade(
                  duration: const Duration(milliseconds: 320),
                  sizeCurve: Curves.easeOutCubic,
                  crossFadeState: c.isSettlement
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Column(
                    children: [
                      // Dates row
                      Padding(
                        padding: EdgeInsets.fromLTRB(22.w, 14.h, 22.w, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _DateTile(
                                label: 'WHEN',
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
                                label: 'RETURN',
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
                      // Note
                      Padding(
                        padding: EdgeInsets.fromLTRB(22.w, 14.h, 22.w, 0),
                        child: _NoteField(controller: c.noteController),
                      ),
                      // Reminder
                      Padding(
                        padding: EdgeInsets.fromLTRB(22.w, 14.h, 22.w, 0),
                        child: Obx(
                          () => _ReminderTile(
                            enabled: c.reminderEnabled.value,
                            onToggle: (v) => c.reminderEnabled.value = v,
                            accentColor: c.accentColor,
                          ),
                        ),
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
                padding: EdgeInsets.fromLTRB(22.w, 28.h, 22.w, 48.h),
                child: Obx(
                  () => _ConfirmButton(
                    gradient: c.accentGradient,
                    accentColor: c.accentColor,
                    isSettlement: c.isSettlement,
                    isLoading: c.isLoading.value,
                    onTap: c.isLoading.value
                        ? () {}
                        : () => c.onConfirm(friendId),
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
class _StickyTopBar extends SliverPersistentHeaderDelegate {
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
    final pinned = shrinkOffset > 0 || overlapsContent;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: height,
      decoration: BoxDecoration(
        color: pinned
            ? const Color(0xFF080A10).withValues(alpha: 0.96)
            : Colors.transparent,
        border: pinned
            ? Border(
                bottom: BorderSide(
                  color: Colors.white.withValues(alpha: 0.05),
                  width: 1,
                ),
              )
            : null,
      ),
      padding: EdgeInsets.symmetric(horizontal: 22.w),
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
                color: const Color(0xFF13161F),
                borderRadius: BorderRadius.circular(13.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: const Color(0xFF9CA3AF),
                size: 15.sp,
              ),
            ),
          ),
          SizedBox(width: 40.w),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyTopBar old) => old.height != height;
}

// ─────────────────────────────────────────────────────────────────────────────
// Glow pill
// ─────────────────────────────────────────────────────────────────────────────
class _GlowPill extends StatelessWidget {
  final String label;
  final Color accentColor;
  const _GlowPill({required this.label, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.12),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pulsing dot
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.6),
                  blurRadius: 6,
                  spreadRadius: 0,
                ),
              ],
            ),
          ),
          SizedBox(width: 7.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
              color: accentColor,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Type Selector — floating card design
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
          icon: Icons.north_east_rounded,
          label: 'Lend',
          sub: 'They owe you',
          gradient: [const Color(0xFF6D28D9), const Color(0xFFA78BFA)],
          glow: const Color(0xFFA78BFA),
          onTap: () => onSelect(TransactionType.lend),
        ),
        SizedBox(width: 9.w),
        _TypeCard(
          type: TransactionType.borrow,
          selected: selected == TransactionType.borrow,
          icon: Icons.south_west_rounded,
          label: 'Borrow',
          sub: 'You owe them',
          gradient: [const Color(0xFF065F46), const Color(0xFF34D399)],
          glow: const Color(0xFF34D399),
          onTap: () => onSelect(TransactionType.borrow),
        ),
        SizedBox(width: 9.w),
        _TypeCard(
          type: TransactionType.settlement,
          selected: selected == TransactionType.settlement,
          icon: Icons.balance_rounded,
          label: 'Settle',
          sub: 'Clear the debt',
          gradient: [const Color(0xFF0E7490), const Color(0xFF22D3EE)],
          glow: const Color(0xFF22D3EE),
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
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.fromLTRB(0, 18.h, 0, 16.h),
          decoration: BoxDecoration(
            gradient: selected
                ? LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: selected ? null : const Color(0xFF111318),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: selected
                  ? gradient.last.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.05),
              width: selected ? 1.5 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: glow.withValues(alpha: 0.28),
                      blurRadius: 24,
                      spreadRadius: -4,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: glow.withValues(alpha: 0.10),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon badge
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                width: 46.w,
                height: 46.h,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.18)
                      : glow.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.25)
                        : glow.withValues(alpha: 0.14),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 19.sp,
                  color: selected ? Colors.white : glow,
                ),
              ),
              SizedBox(height: 11.h),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : const Color(0xFF9CA3AF),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                sub,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: selected
                      ? Colors.white.withValues(alpha: 0.55)
                      : const Color(0xFF374151),
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
// Amount Field — glass card with glowing border
// ─────────────────────────────────────────────────────────────────────────────
class _AmountField extends StatelessWidget {
  final TextEditingController controller;
  final Color accentColor;
  final List<Color> gradient;
  const _AmountField({
    required this.controller,
    required this.accentColor,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionLabel('AMOUNT'),
        SizedBox(height: 10.h),
        // Outer glow container
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.r),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.15),
                blurRadius: 20,
                spreadRadius: -4,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFF111318),
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.22),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Currency symbol with gradient
                ShaderMask(
                  shaderCallback: (bounds) =>
                      LinearGradient(colors: gradient).createShader(bounds),
                  child: Text(
                    '₹',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                // Vertical divider
                Container(
                  width: 1,
                  height: 40.h,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
                SizedBox(width: 14.w),
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
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -1.0,
                    ),
                    decoration: InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                  ),
                ),
                // Decorative tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'INR',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                      letterSpacing: 0.8,
                    ),
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
          color: const Color(0xFF111318),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isEmpty
                ? Colors.white.withValues(alpha: 0.05)
                : iconColor.withValues(alpha: 0.20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF4B5563),
                letterSpacing: 1.0,
              ),
            ),
            SizedBox(height: 9.h),
            Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(9.r),
                    border: Border.all(
                      color: iconColor.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Icon(icon, size: 14.sp, color: iconColor),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w700,
                      color: isEmpty ? const Color(0xFF374151) : Colors.white,
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
        _SectionLabel('NOTE'),
        SizedBox(height: 10.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF111318),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: TextField(
            controller: controller,
            maxLines: 3,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white,
              height: 1.65,
            ),
            decoration: InputDecoration(
              hintText: 'What was this for?',
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF374151),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 12.w, top: 16.h),
                child: Icon(
                  Icons.edit_rounded,
                  size: 17.sp,
                  color: const Color(0xFF374151),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 0,
                minHeight: 0,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(0, 16.h, 16.w, 16.h),
            ),
          ),
        ),
      ],
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
      duration: const Duration(milliseconds: 240),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: enabled
            ? accentColor.withValues(alpha: 0.07)
            : const Color(0xFF111318),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: enabled
              ? accentColor.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.05),
        ),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: accentColor.withValues(alpha: 0.08),
                  blurRadius: 16,
                  spreadRadius: -2,
                ),
              ]
            : [],
      ),
      child: Row(
        children: [
          // Bell icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: enabled
                  ? accentColor.withValues(alpha: 0.15)
                  : const Color(0xFF1A1D26),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                color: enabled
                    ? accentColor.withValues(alpha: 0.30)
                    : Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Icon(
              Icons.notifications_rounded,
              size: 19.sp,
              color: enabled ? accentColor : const Color(0xFF4B5563),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Repayment Reminder',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Get notified when it\'s time to settle',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
          // Custom toggle
          GestureDetector(
            onTap: () => onToggle(!enabled),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              width: 48.w,
              height: 26.h,
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: enabled ? accentColor : const Color(0xFF1A1D26),
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(
                  color: enabled
                      ? accentColor.withValues(alpha: 0.5)
                      : Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeOutCubic,
                alignment: enabled
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
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
// Confirm Button
// ─────────────────────────────────────────────────────────────────────────────
class _ConfirmButton extends StatelessWidget {
  final List<Color> gradient;
  final Color accentColor;
  final bool isSettlement;
  final bool isLoading;
  final VoidCallback onTap;

  const _ConfirmButton({
    required this.gradient,
    required this.accentColor,
    required this.isSettlement,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              HapticFeedback.mediumImpact();
              onTap();
            },
      child: Stack(
        children: [
          // Outer glow
          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 240),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: isLoading
                    ? []
                    : [
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.40),
                          blurRadius: 32,
                          spreadRadius: -6,
                          offset: const Offset(0, 12),
                        ),
                      ],
              ),
            ),
          ),
          // Button body
          AnimatedContainer(
            duration: const Duration(milliseconds: 240),
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 19.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLoading
                    ? [
                        gradient.first.withValues(alpha: 0.45),
                        gradient.last.withValues(alpha: 0.45),
                      ]
                    : gradient,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: isLoading
                    ? Colors.transparent
                    : gradient.last.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: isLoading
                ? Center(
                    child: SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 28.w,
                        height: 28.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Icon(
                          isSettlement
                              ? Icons.balance_rounded
                              : Icons.check_rounded,
                          size: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        isSettlement
                            ? 'Confirm Settlement'
                            : 'Confirm Transaction',
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
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section label
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF4B5563),
        letterSpacing: 1.2,
      ),
    );
  }
}
