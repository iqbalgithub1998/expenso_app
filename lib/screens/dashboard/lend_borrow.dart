import 'package:expenso/controllers/lend_borrow_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LendBorrowScreen extends StatelessWidget {
  LendBorrowScreen({super.key});
  final controller = Get.put<LendBorrowController>(LendBorrowController());

  @override
  Widget build(BuildContext context) {
    // final controller = Get.find<LendBorrowController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      floatingActionButton: _AddFab(controller: controller),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── App Bar ────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.h,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00C853),
                                    Color(0xFF00E676),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF00E676,
                                    ).withValues(alpha: 0.35),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Expenso',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                Text(
                                  'Lend & Borrow',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: controller.onNotificationTap,
                          child: Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1D26),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.07),
                              ),
                            ),
                            child: Icon(
                              Icons.notifications_outlined,
                              color: const Color(0xFF9CA3AF),
                              size: 18.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22.h),
                  ],
                ),
              ),
            ),

            // ── Net Position Hero ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const _NetPositionCard(),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 28.h)),

            // ── Active Ledgers Header ──────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Ledgers',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.onViewAllLedgersTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF00C853,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'View all',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00E676),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 14.h)),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    const _FeaturedLedgerCard(),
                    SizedBox(height: 14.h),
                    Row(
                      children: [
                        Expanded(
                          child: _MiniLedgerCard(
                            name: 'Mike T.',
                            amount: '-\$450.00',
                            amountColor: const Color(0xFFE53935),
                            subLabel: 'Due in 2 days',
                            subColor: const Color(0xFFE53935),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: _MiniLedgerCard(
                            name: 'Jessica R.',
                            amount: '+\$1,200.00',
                            amountColor: const Color(0xFF1A1A1A),
                            subLabel: 'Paid 60%',
                            subColor: const Color(0xFF2E9E5C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 28.h)),

            // ── Recent Movements Header ────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Movements',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.onViewAllMovementsTap,
                      child: Row(
                        children: [
                          Container(
                            width: 1,
                            height: 12.h,
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF00E676),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 14.h)),

            // ── Movement Tiles ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    ...LendBorrowController.movements.asMap().entries.map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              entry.key <
                                  LendBorrowController.movements.length - 1
                              ? 10.h
                              : 0,
                        ),
                        child: _MovementTile(data: entry.value),
                      ),
                    ),
                    SizedBox(height: 100.h),
                  ],
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
// Movement Tile
// ─────────────────────────────────────────────────────────────────────────────
class _MovementTile extends StatelessWidget {
  final MovementData data;

  const _MovementTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final iconColor = Color(data.iconColorValue);
    final isCredit = data.isCredit;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: Color(data.iconBgValue),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: iconColor.withValues(alpha: 0.15)),
            ),
            child: Icon(
              IconData(data.iconCodePoint, fontFamily: data.iconFontFamily),
              size: 20.sp,
              color: iconColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.amount,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: isCredit
                      ? const Color(0xFF00E676)
                      : const Color(0xFFFF5252),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                height: 2.5,
                width: 36.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (isCredit
                              ? const Color(0xFF00E676)
                              : const Color(0xFFFF5252))
                          .withValues(alpha: 0.0),
                      isCredit
                          ? const Color(0xFF00E676)
                          : const Color(0xFFFF5252),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2.r),
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
// FAB
// ─────────────────────────────────────────────────────────────────────────────
class _AddFab extends StatelessWidget {
  final LendBorrowController controller;

  const _AddFab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.onAddFabTap,
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
        child: Icon(Icons.handshake_outlined, color: Colors.white, size: 26.sp),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Mini Ledger Card
// ─────────────────────────────────────────────────────────────────────────────
class _MiniLedgerCard extends StatelessWidget {
  final String name;
  final String amount;
  final Color amountColor;
  final String subLabel;
  final Color subColor;

  const _MiniLedgerCard({
    super.key,
    required this.name,
    required this.amount,
    required this.amountColor,
    required this.subLabel,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: 16.sp,
                color: const Color(0xFF888888),
              ),
              SizedBox(width: 5.w),
              Text(
                name,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF555566),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: amountColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subLabel,
            style: TextStyle(
              fontSize: 11.sp,
              color: subColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Featured Ledger Card
// ─────────────────────────────────────────────────────────────────────────────
class _FeaturedLedgerCard extends StatelessWidget {
  const _FeaturedLedgerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(
              Icons.handshake_outlined,
              size: 100.sp,
              color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                        width: 2,
                      ),
                      color: const Color(0xFFD8B4FE),
                    ),
                    child: ClipOval(
                      child: Icon(
                        Icons.person,
                        size: 32.sp,
                        color: const Color(0xFF7C3AED),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFAB65F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'OVERDUE',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                'Sarah Jenkins',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF5B21B6),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Lent: \$850.00',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF7C3AED),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
