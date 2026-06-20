import 'package:expenso/controllers/credit_card_detail_controller.dart';
import 'package:expenso/models/credit_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'card_usage_screen.dart';

// ── Palette constants ──────────────────────────────────────────────────────────

const _bg = Color(0xFF0D0F14);
const _surface = Color(0xFF151820);
const _surface2 = Color(0xFF1C1F28);
const _border = Color(0xFF252830);
const _textPrimary = Color(0xFFEEEFF4);
const _textSecondary = Color(0xFF6B7280);
const _green = Color(0xFF2E9E5C);
const _greenDim = Color(0xFF1B7A47);

// ── Screen ─────────────────────────────────────────────────────────────────────

class CreditCardDetailsScreen extends StatelessWidget {
  const CreditCardDetailsScreen({super.key, required this.card});

  final CreditCardModel card;

  @override
  Widget build(BuildContext context) {
    final c = Get.put(CreditCardDetailsController());

    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: _Fab(cardId: card.id, controller: c),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AppBar(),
            Expanded(
              child: SingleChildScrollView(
                controller: c.scrollController,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card
                    _CreditCard(controller: c),
                    SizedBox(height: 8.h),

                    SizedBox(height: 4.h),
                    Text(
                      'Recent Activity',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                        color: _textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Obx(() {
                      if (c.isLoading.value) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 60.h),
                          child: const Center(
                            child: CircularProgressIndicator(color: _green),
                          ),
                        );
                      }

                      if (c.groups.isEmpty) {
                        return const _EmptyActivity();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...c.groups.map(
                            (g) => _DayGroupWidget(group: g, controller: c),
                          ),
                          if (c.isLoadingMore.value)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: _green,
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                    SizedBox(height: 90.h),
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

// ── App Bar ────────────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedArrowLeft01,
              size: 28.0,
              color: Colors.white,
              strokeWidth: 1.5,
            ),
          ),
          SizedBox(
            width: 250,
            child: Text(
              "SBI Card",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20.sp, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Credit Card ────────────────────────────────────────────────────────────────

class _CreditCard extends StatelessWidget {
  final CreditCardDetailsController controller;
  const _CreditCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: [
          BoxShadow(
            color: _green.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _green,
                      const Color(0xFF258D50),
                      const Color(0xFF165D35),
                    ],
                    stops: const [0.1, 0.5, 0.9],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -40.h,
              right: -20.w,
              child: _CircularOverlay(size: 160.w, color: Colors.white12),
            ),
            Positioned(
              bottom: -50.h,
              left: -20.w,
              child: _CircularOverlay(size: 140.w, color: Colors.black12),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(28.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // CORRECTED CHIP UI
                      Container(
                        width: 40.w,
                        height: 30.h,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: 12.w,
                              child: Container(
                                width: 1.w,
                                height: 30.h,
                                color: Colors.black12,
                              ),
                            ),
                            Positioned(
                              right: 12.w,
                              child: Container(
                                width: 1.w,
                                height: 30.h,
                                color: Colors.black12,
                              ),
                            ),
                            Center(
                              child: Container(
                                width: 40.w,
                                height: 1.h,
                                color: Colors.black12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.contactless_rounded,
                          size: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'CURRENT BALANCE',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: 0.6),
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '₹12,450.80',
                    style: TextStyle(
                      fontSize: 34.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• • • •  1234',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.9),
                              letterSpacing: 2,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Next Payment: ',

                                  style: TextStyle(
                                    fontSize: 11.sp,

                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),

                                TextSpan(
                                  text: controller.nextPaymentDate,

                                  style: TextStyle(
                                    fontSize: 11.sp,

                                    fontWeight: FontWeight.w700,

                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 40.w,
                        child: Stack(
                          children: [
                            Container(
                              width: 24.w,
                              height: 24.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            ),
                            Positioned(
                              left: 15.w,
                              child: Container(
                                width: 24.w,
                                height: 24.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularOverlay extends StatelessWidget {
  final double size;
  final Color color;
  const _CircularOverlay({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ── Empty State ──────────────────────────────────────────────────────────────

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50.h),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: _surface2,
                shape: BoxShape.circle,
                border: Border.all(color: _border),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                size: 32.sp,
                color: _textSecondary,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: _textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Your recent activity will show up here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.sp, color: _textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Day Group ──────────────────────────────────────────────────────────────────

class _DayGroupWidget extends StatelessWidget {
  final DayGroup group;
  final CreditCardDetailsController controller;
  const _DayGroupWidget({required this.group, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: _surface2,
                shape: BoxShape.circle,
                border: Border.all(color: _border),
              ),
              child: Center(
                child: Text(
                  '${group.day}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: _textSecondary,
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: _textPrimary,
                  ),
                ),
                Text(
                  group.month,
                  style: TextStyle(fontSize: 11.sp, color: _textSecondary),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...group.txs.map(
          (tx) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: _TxTile(tx: tx, controller: controller),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

// ── Transaction Tile ───────────────────────────────────────────────────────────

class _TxTile extends StatelessWidget {
  final TxModel tx;
  final CreditCardDetailsController controller;
  const _TxTile({required this.tx, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (tx.isHighlighted) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFFAB65F5)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.30),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _TxRow(
          tx: tx,
          titleColor: Colors.white,
          subtitleColor: Colors.white.withValues(alpha: 0.75),
          amountColor: Colors.white,
          timeColor: Colors.white.withValues(alpha: 0.7),
          iconBg: Colors.white.withValues(alpha: 0.2),
          iconColor: Colors.white,
          controller: controller,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: _border),
      ),
      child: _TxRow(
        tx: tx,
        titleColor: _textPrimary,
        subtitleColor: _textSecondary,
        amountColor: controller.amountColor(tx),
        timeColor: _textSecondary,
        iconBg: tx.iconBg,
        iconColor: tx.iconColor,
        controller: controller,
      ),
    );
  }
}

// ── Shared tile row ────────────────────────────────────────────────────────────

class _TxRow extends StatelessWidget {
  final TxModel tx;
  final Color titleColor;
  final Color subtitleColor;
  final Color amountColor;
  final Color timeColor;
  final Color iconBg;
  final Color iconColor;
  final CreditCardDetailsController controller;

  const _TxRow({
    required this.tx,
    required this.titleColor,
    required this.subtitleColor,
    required this.amountColor,
    required this.timeColor,
    required this.iconBg,
    required this.iconColor,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Icon(tx.icon, size: 22.sp, color: iconColor),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx.title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                tx.subtitle,
                style: TextStyle(fontSize: 11.sp, color: subtitleColor),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              controller.amountText(tx),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                color: amountColor,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              tx.time,
              style: TextStyle(fontSize: 10.sp, color: timeColor),
            ),
          ],
        ),
      ],
    );
  }
}

// ── FAB ────────────────────────────────────────────────────────────────────────

class _Fab extends StatelessWidget {
  final String cardId;
  final CreditCardDetailsController controller;

  const _Fab({required this.cardId, required this.controller});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Get.to(
          () => CardUsageScreen(),
          arguments: {"cardId": cardId},
        );
        if (result != null) {
          controller.addTransaction(result);
        }
      },
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_greenDim, Color(0xFF38C068)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _green.withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(Icons.add, color: Colors.white, size: 28.sp),
      ),
    );
  }
}

// ── Bottom Nav Bar ─────────────────────────────────────────────────────────────

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isActive: false,
              ),
              _NavItem(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Expenses',
                isActive: true,
              ),
              _NavItem(
                icon: Icons.handshake_outlined,
                label: 'Lend/Borrow',
                isActive: false,
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isActive: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: isActive
                ? BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_greenDim, Color(0xFF38C068)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  )
                : null,
            child: Icon(
              icon,
              size: 22.sp,
              color: isActive ? Colors.white : _textSecondary,
            ),
          ),
          if (!isActive) ...[
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: _textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
