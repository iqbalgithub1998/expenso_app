import 'package:expenso/controllers/home_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final c = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: FadeTransition(
          opacity: c.fadeAnim,
          child: SlideTransition(
            position: c.slideAnim,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14.h),

                  // ── App Bar ────────────────────────────────────────────────
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _GlowContainer(
                              glowColor: const Color(0xFF00E676),
                              child: Container(
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
                                ),
                                child: Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Colors.white,
                                  size: 20.sp,
                                ),
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
                                  'Good morning, ${c.userName.value} 👋',
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
                        Row(
                          children: [
                            _IconBtn(
                              icon: Icons.search_rounded,
                              onTap: c.onSearchTap,
                            ),
                            SizedBox(width: 8.w),
                            Stack(
                              children: [
                                _IconBtn(
                                  icon: Icons.notifications_outlined,
                                  onTap: c.onNotificationTap,
                                ),
                                if (c.hasNotification.value)
                                  Positioned(
                                    top: 8.h,
                                    right: 8.w,
                                    child: Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00E676),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF0D0F14),
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // ── Hero Card ──────────────────────────────────────────────
                  Obx(() => _HeroCard(totalExpense: c.totalExpense.value)),

                  SizedBox(height: 16.h),

                  // ── Quick Stats ────────────────────────────────────────────
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            icon: Icons.arrow_upward_rounded,
                            label: 'Pending Lend',
                            amount: c.pendingLend.value,
                            iconColor: const Color(0xFFBB86FC),
                            bgColor: const Color(0xFF1E1B2E),
                            accentColor: const Color(0xFFBB86FC),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _StatTile(
                            icon: Icons.arrow_downward_rounded,
                            label: 'Borrowed',
                            amount: c.totalBorrowed.value,
                            iconColor: const Color(0xFFFFB74D),
                            bgColor: const Color(0xFF1E1A12),
                            accentColor: const Color(0xFFFFB74D),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28.h),

                  // ── Trend Header ───────────────────────────────────────────
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Trend Comparison',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                        _PillButton(
                          label: c.selectedPeriod.value,
                          onTap: c.onPeriodTap,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // ── Chart ──────────────────────────────────────────────────
                  const _ChartCard(),

                  SizedBox(height: 28.h),

                  // ── Recent Header ──────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      GestureDetector(
                        onTap: c.onFilterTap,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF00C853,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                size: 13.sp,
                                color: const Color(0xFF00E676),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Filter',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF00E676),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  // ── Transactions List ──────────────────────────────────────
                  Obx(
                    () => Column(
                      children: c.transactions
                          .map(
                            (t) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _TransactionItem(
                                icon: t['icon'] as IconData,
                                iconColor: t['iconColor'] as Color,
                                bgColor: t['bgColor'] as Color,
                                title: t['title'] as String,
                                subtitle: t['subtitle'] as String,
                                amount: t['amount'] as String,
                                isDebit: t['isDebit'] as bool,
                                date: t['date'] as String,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // ── Bottom Actions ─────────────────────────────────────────
                  _BottomActions(
                    onViewMore: c.onViewMoreTap,
                    onAddExpense: c.onAddExpenseTap,
                  ),

                  SizedBox(height: 28.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero Card
// ─────────────────────────────────────────────────────────────────────────────
class _HeroCard extends StatelessWidget {
  final String totalExpense;
  const _HeroCard({required this.totalExpense});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF00603A), Color(0xFF00A854), Color(0xFF00E676)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C853).withValues(alpha: 0.35),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: 40,
            child: Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      'THIS MONTH',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 22.sp,
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text(
                totalExpense,
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1.5,
                  height: 1.0,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Total Expenses',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white.withValues(alpha: 0.65),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 20.h),
              Container(height: 1, color: Colors.white.withValues(alpha: 0.15)),
              SizedBox(height: 16.h),
              Row(
                children: [
                  _HeroChip(
                    icon: Icons.trending_up_rounded,
                    text: '+12.5% vs last month',
                  ),
                  SizedBox(width: 10.w),
                  _HeroChip(icon: Icons.access_time_rounded, text: '2m ago'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _HeroChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: Colors.white.withValues(alpha: 0.85)),
          SizedBox(width: 5.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Tile
// ─────────────────────────────────────────────────────────────────────────────
class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String amount;
  final Color iconColor;
  final Color bgColor;
  final Color accentColor;

  const _StatTile({
    required this.icon,
    required this.label,
    required this.amount,
    required this.iconColor,
    required this.bgColor,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: accentColor.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.sp, color: iconColor),
          ),
          SizedBox(height: 12.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            amount,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chart Card  (pure UI — wire Rx<List<FlSpot>> from controller if needed)
// ─────────────────────────────────────────────────────────────────────────────
class _ChartCard extends StatelessWidget {
  const _ChartCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _legendItem(color: const Color(0xFF00E676), label: 'Current'),
              _legendItem(color: const Color(0xFFBB86FC), label: 'Previous'),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 180.h,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: Colors.white.withValues(alpha: 0.04),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const labels = [
                          'JAN',
                          'FEB',
                          'MAR',
                          'APR',
                          'MAY',
                          'JUN',
                        ];
                        if (value >= 0 && value < labels.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              labels[value.toInt()],
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: const Color(0xFF4B5563),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                      interval: 1,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1.5),
                      FlSpot(1, 2.5),
                      FlSpot(2, 2.2),
                      FlSpot(3, 3.5),
                      FlSpot(4, 3.8),
                      FlSpot(5, 5.5),
                    ],
                    isCurved: true,
                    color: const Color(0xFF00E676),
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF00E676).withValues(alpha: 0.18),
                          const Color(0xFF00E676).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, _, __, index) => index == 5
                          ? FlDotCirclePainter(
                              radius: 4,
                              color: const Color(0xFF00E676),
                              strokeColor: const Color(0xFF141720),
                              strokeWidth: 2,
                            )
                          : FlDotCirclePainter(
                              radius: 0,
                              color: Colors.transparent,
                              strokeColor: Colors.transparent,
                              strokeWidth: 0,
                            ),
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1.0),
                      FlSpot(1, 1.8),
                      FlSpot(2, 1.5),
                      FlSpot(3, 2.2),
                      FlSpot(4, 2.8),
                      FlSpot(5, 4.5),
                    ],
                    isCurved: true,
                    color: const Color(0xFFBB86FC),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dashArray: [6, 4],
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFBB86FC).withValues(alpha: 0.10),
                          const Color(0xFFBB86FC).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Transaction Item
// ─────────────────────────────────────────────────────────────────────────────
class _TransactionItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String amount;
  final bool isDebit;
  final String date;

  const _TransactionItem({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isDebit,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, size: 20.sp, color: iconColor),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
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
                amount,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: isDebit
                      ? const Color(0xFFFF5252)
                      : const Color(0xFF00E676),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                date,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color(0xFF374151),
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

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Actions — two separate full-width buttons
// ─────────────────────────────────────────────────────────────────────────────
class _BottomActions extends StatelessWidget {
  final VoidCallback onViewMore;
  final VoidCallback onAddExpense;

  const _BottomActions({required this.onViewMore, required this.onAddExpense});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // View More Transactions
        GestureDetector(
          onTap: onViewMore,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF141720),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'View More Transactions',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF9CA3AF),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(width: 6.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 18.sp,
                  color: const Color(0xFF6B7280),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // Add Expense
        GestureDetector(
          onTap: onAddExpense,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00A854), Color(0xFF00E676)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00C853).withValues(alpha: 0.30),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 22.w,
                  height: 22.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_rounded,
                    size: 14.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'Add Expense',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
// Shared helper widgets
// ─────────────────────────────────────────────────────────────────────────────
class _GlowContainer extends StatelessWidget {
  final Color glowColor;
  final Widget child;
  const _GlowContainer({required this.glowColor, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D26),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Icon(icon, color: const Color(0xFF9CA3AF), size: 18.sp),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PillButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1D26),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 15.sp,
              color: const Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }
}
