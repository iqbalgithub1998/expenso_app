import 'package:expenso/controllers/credit_card_controller.dart';
import 'package:expenso/models/credit_card_model.dart';
import 'package:expenso/screens/dashboard/credit_card_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreditCardsScreen extends StatelessWidget {
  CreditCardsScreen({super.key});
  final c = Get.put<CreditCardsController>(CreditCardsController());

  @override
  Widget build(BuildContext context) {
    // final c = Get.find<CreditCardsController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      // floatingActionButton: _AddCardFab(controller: c),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Pinned App Bar ──────────────────────────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyAppBar(controller: c),
            ),

            // ── Hero heading + active count ─────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 0),
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Manage \nyour credit cards',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.8,
                              height: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 7.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF00C853,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: const Color(
                              0xFF00E676,
                            ).withValues(alpha: 0.25),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6.w,
                              height: 6.h,
                              decoration: const BoxDecoration(
                                color: Color(0xFF00E676),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              '${c.cards.length} ACTIVE',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00E676),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Card list (or empty state) ──────────────────────────────────
            Obx(() {
              if (c.cards.isEmpty) {
                return SliverToBoxAdapter(
                  child: _EmptyCardsState(controller: c),
                );
              }
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final card = c.cards[index];
                  return Padding(
                    padding: EdgeInsets.fromLTRB(
                      20.w,
                      index == 0 ? 18.h : 12.h,
                      20.w,
                      0,
                    ),
                    child: _CreditCardTile(card: card),
                  );
                }, childCount: c.cards.length),
              );
            }),

            // ── Payment schedule (only cards inside their payment window) ────
            SliverToBoxAdapter(
              child: Obx(() {
                final due = c.duePayments;
                if (due.isEmpty) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section header
                      Row(
                        children: [
                          Container(
                            width: 4.w,
                            height: 18.h,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF00C853), Color(0xFF00E676)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Payment Schedule',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 14.h),
                      ...due.map(
                        (card) => Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: _PaymentTile(card: card, controller: c),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            // ── Bottom padding ──────────────────────────────────────────────
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          ],
        ),
      ),

      // // ── Bottom Nav ────────────────────────────────────────────────────────
      // bottomNavigationBar: Obx(
      //   () => _BottomNavBar(
      //     activeIndex: c.activeNavIndex.value,
      //     onTap: c.onNavTap,
      //   ),
      // ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Pinned App Bar
// ─────────────────────────────────────────────────────────────────────────────
class _StickyAppBar extends SliverPersistentHeaderDelegate {
  final CreditCardsController controller;
  const _StickyAppBar({required this.controller});

  static const double _h = 68.0;

  @override
  double get minExtent => _h;
  @override
  double get maxExtent => _h;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final bool pinned = shrinkOffset > 0 || overlapsContent;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
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
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
                  borderRadius: BorderRadius.circular(13.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E676).withValues(alpha: 0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.credit_card_outlined,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'My Cards',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => _AddCardSheet(controller: controller),
            ),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.30),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(Icons.add_rounded, color: Colors.white, size: 22.sp),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_StickyAppBar old) => false;
}

// ─────────────────────────────────────────────────────────────────────────────
// Credit Card Tile
// ─────────────────────────────────────────────────────────────────────────────
class _CreditCardTile extends StatelessWidget {
  final CreditCardModel card;
  const _CreditCardTile({required this.card});

  @override
  Widget build(BuildContext context) {
    final labelColor = Colors.white.withValues(alpha: 0.55);
    final gradient =
        CreditCardsController.cardThemes[(int.tryParse(card.color.toString()) ??
                0)
            .clamp(0, CreditCardsController.cardThemes.length - 1)];

    return Stack(
      children: [
        InkWell(
          onTap: () => Get.to(
            () => CreditCardDetailsScreen(card: card),
            arguments: {"card": card, 'paymentDueDate': card.paymentDueDate},
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(22.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withValues(alpha: 0.40),
                  blurRadius: 22,
                  spreadRadius: -4,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + card icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.name,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '•••• ${card.last4}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: labelColor,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(9.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.credit_card_rounded,
                        size: 18.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 18.h),

                // Balance label
                Text(
                  'Current Balance',
                  style: TextStyle(fontSize: 10.sp, color: labelColor),
                ),
                SizedBox(height: 3.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.6,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      card.formattedBalance,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.8,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: LinearProgressIndicator(
                    value: card.usedPercent,
                    minHeight: 5.h,
                    backgroundColor: Colors.white.withValues(alpha: 0.14),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),

                // Limit + used
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      card.limitLabel,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      card.usedLabel,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: labelColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 4,
          top: -18,
          child: Container(
            width: 90.w,
            height: 90.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
        ),
        Positioned(
          left: 15,
          bottom: -28,
          child: Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State (no cards yet)
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyCardsState extends StatelessWidget {
  final CreditCardsController controller;
  const _EmptyCardsState({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 0),
      child: Column(
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            decoration: BoxDecoration(
              color: const Color(0xFF141720),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
            ),
            child: Icon(
              Icons.credit_card_off_outlined,
              size: 42.sp,
              color: const Color(0xFF4B5563),
            ),
          ),
          SizedBox(height: 22.h),
          Text(
            'No cards yet',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add a credit card to track its balance,\nlimit and payment schedule.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => _AddCardSheet(controller: controller),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 13.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C853), Color(0xFF00E676)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E676).withValues(alpha: 0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Add your first card',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Payment Tile
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentTile extends StatelessWidget {
  final CreditCardModel card;
  final CreditCardsController controller;
  const _PaymentTile({required this.card, required this.controller});

  @override
  Widget build(BuildContext context) {
    final urgentRed = const Color(0xFFFF5252);
    final neutralCol = const Color(0xFF9CA3AF);

    final today = DateTime.now().day;
    final dueDay = controller.dayOf(card.paymentDueDate) ?? today;
    final daysLeft = (dueDay - today).clamp(0, 31);
    final isUrgent = daysLeft <= 3;
    final accentColor = isUrgent ? urgentRed : neutralCol;

    final dueLabel = daysLeft == 0
        ? 'Due today • ${card.paymentDueDate}'
        : 'Due in $daysLeft day${daysLeft == 1 ? '' : 's'} • ${card.paymentDueDate}';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: isUrgent
              ? urgentRed.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          // Left accent line
          Container(
            width: 3.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(width: 12.w),

          // Icon
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: isUrgent
                  ? urgentRed.withValues(alpha: 0.12)
                  : const Color(0xFF1A1D26),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Icon(
              isUrgent
                  ? Icons.warning_amber_rounded
                  : Icons.receipt_long_outlined,
              size: 20.sp,
              color: accentColor,
            ),
          ),
          SizedBox(width: 12.w),

          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${card.name} •••• ${card.last4}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  dueLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Balance + badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${card.formattedBalance}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: isUrgent ? urgentRed : Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(
                    color: accentColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  'BALANCE',
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                    letterSpacing: 0.6,
                  ),
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
// Add Card Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _AddCardSheet extends StatelessWidget {
  final CreditCardsController controller;
  const _AddCardSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F14),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            Text(
              'Add New Card',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.6,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Edit the card, pick a colour, then add limit & balance',
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF6B7280)),
            ),

            SizedBox(height: 22.h),

            // ── Inline editable card ───────────────────────────────────────
            Obx(() {
              final theme =
                  CreditCardsController.cardThemes[c.selectedTheme.value];
              return Container(
                width: double.infinity,
                height: 178.h,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: theme,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: theme.first.withValues(alpha: 0.45),
                      blurRadius: 22,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Decorative circle
                    Positioned(
                      right: -16,
                      top: -16,
                      child: Container(
                        width: 85.w,
                        height: 85.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Row 1: Name field + card icon ──────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _CardTextField(
                                controller: c.nameController,
                                hint: 'Tap to add name',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.45),
                                ),
                                onChanged: c.onNameChanged,
                              ),
                            ),
                            Icon(
                              Icons.credit_card_rounded,
                              size: 20.sp,
                              color: Colors.white.withValues(alpha: 0.75),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Chip visual
                        Container(
                          width: 30.w,
                          height: 22.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),

                        // ── Row 2: Card number (last 4 inline) ─────────────
                        Row(
                          children: [
                            Text(
                              '•••• •••• •••• ',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.75),
                                letterSpacing: 2,
                              ),
                            ),
                            SizedBox(
                              width: 52.w,
                              child: _CardTextField(
                                controller: c.last4Controller,
                                hint: '____',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.45),
                                  letterSpacing: 2,
                                ),
                                onChanged: c.onLast4Changed,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),

                        // ── Row 3: Billing + Due date inline ──────────────
                        Row(
                          children: [
                            // Billing day
                            Text(
                              'BILLING',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.6),
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            SizedBox(
                              width: 30.w,
                              child: _CardTextField(
                                controller: c.billingController,
                                hint: '--',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.45),
                                ),
                                onChanged: c.onBillingChanged,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            // Due day
                            Text(
                              'DUE',
                              style: TextStyle(
                                fontSize: 8.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.6),
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            SizedBox(
                              width: 30.w,
                              child: _CardTextField(
                                controller: c.paymentController,
                                hint: '--',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(2),
                                ],
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.45),
                                ),
                                onChanged: c.onPaymentChanged,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            SizedBox(height: 16.h),

            // ── Theme picker ───────────────────────────────────────────────
            SizedBox(
              height: 36.w,
              child: Obx(() {
                // Read the observable synchronously so Obx tracks it.
                final selected = c.selectedTheme.value;
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: CreditCardsController.cardThemes.length,
                  itemBuilder: (context, i) {
                    final isSelected = selected == i;
                    return GestureDetector(
                      onTap: () => c.selectTheme(i),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(right: 10.w),
                          width: isSelected ? 32.w : 26.w,
                          height: isSelected ? 32.w : 26.w,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: CreditCardsController.cardThemes[i],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    width: 2.5,
                                  )
                                : Border.all(
                                    color: Colors.transparent,
                                    width: 0,
                                  ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: CreditCardsController
                                          .cardThemes[i]
                                          .first
                                          .withValues(alpha: 0.45),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : [],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            SizedBox(height: 24.h),

            // ── Credit limit + current balance ─────────────────────────────
            _DarkFormField(
              label: 'Credit Limit',
              hint: 'e.g. 15000',
              icon: Icons.account_balance_wallet_outlined,
              iconColor: const Color(0xFF00E676),
              controller: c.limitController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: c.onLimitChanged,
            ),
            SizedBox(height: 12.h),
            _DarkFormField(
              label: 'Current Balance',
              hint: 'e.g. 4120.45 (0 if new)',
              icon: Icons.payments_outlined,
              iconColor: const Color(0xFFFF5252),
              controller: c.balanceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              onChanged: c.onBalanceChanged,
            ),

            SizedBox(height: 28.h),

            // ── Save button ────────────────────────────────────────────────
            Obx(() {
              final theme =
                  CreditCardsController.cardThemes[c.selectedTheme.value];
              return GestureDetector(
                onTap: () => c.saveCard(context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: theme,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: theme.first.withValues(alpha: 0.40),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Save Card',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// A transparent [TextField] that sits directly on the card surface.
/// Shows a subtle dashed underline only while focused.
class _CardTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextStyle style;
  final TextStyle hintStyle;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;

  const _CardTextField({
    required this.controller,
    required this.hint,
    required this.style,
    required this.hintStyle,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
  });

  @override
  State<_CardTextField> createState() => _CardTextFieldState();
}

class _CardTextFieldState extends State<_CardTextField> {
  final FocusNode _focus = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focus,
      style: widget.style,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      cursorColor: Colors.white,
      cursorWidth: 1.5,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: widget.hintStyle,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.45),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card Editor Sheet (inline editing on card)
// ─────────────────────────────────────────────────────────────────────────────
class _CardEditorSheet extends StatelessWidget {
  final CreditCardsController controller;
  const _CardEditorSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F14),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Text(
              'Edit Card Details',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.6,
              ),
            ),
            SizedBox(height: 22.h),
            _DarkFormField(
              label: 'Card Name',
              hint: 'e.g. Platinum Elite',
              icon: Icons.credit_card_outlined,
              iconColor: const Color(0xFF00E676),
              controller: c.nameController,
              onChanged: c.onNameChanged,
            ),
            SizedBox(height: 12.h),
            _DarkFormField(
              label: 'Last 4 Digits',
              hint: '0000',
              icon: Icons.pin_outlined,
              iconColor: const Color(0xFFBB86FC),
              controller: c.last4Controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: c.onLast4Changed,
            ),
            SizedBox(height: 12.h),
            _DarkFormField(
              label: 'Payment Due Date',
              hint: 'Day of month (1–31)',
              icon: Icons.event_outlined,
              iconColor: const Color(0xFFFF5252),
              controller: c.paymentController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(2),
              ],
              onChanged: c.onPaymentChanged,
            ),
            SizedBox(height: 28.h),
            Obx(() {
              final theme =
                  CreditCardsController.cardThemes[c.selectedTheme.value];
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  c.saveCard(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: theme,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: theme.first.withValues(alpha: 0.40),
                        blurRadius: 22,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          size: 14.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Save Card',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dark Form Field
// ─────────────────────────────────────────────────────────────────────────────
class _DarkFormField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String> onChanged;

  const _DarkFormField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.controller,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
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
            color: const Color(0xFF141720),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
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
// Bottom Nav Bar
// ─────────────────────────────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.activeIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home_outlined, Icons.home_rounded, 'Home'),
      (
        Icons.account_balance_wallet_outlined,
        Icons.account_balance_wallet_rounded,
        'Expenses',
      ),
      (Icons.handshake_outlined, Icons.handshake_rounded, 'Lend/Borrow'),
      (Icons.person_outline_rounded, Icons.person_rounded, 'Profile'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0D0F14),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.07),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final isActive = activeIndex == i;
              final item = items[i];
              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: EdgeInsets.symmetric(
                    horizontal: isActive ? 16.w : 12.w,
                    vertical: 10.h,
                  ),
                  decoration: isActive
                      ? BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00A854), Color(0xFF00E676)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(22.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF00C853,
                              ).withValues(alpha: 0.30),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        )
                      : null,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isActive ? item.$2 : item.$1,
                        size: 20.sp,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF4B5563),
                      ),
                      if (isActive) ...[
                        SizedBox(width: 6.w),
                        Text(
                          item.$3,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
