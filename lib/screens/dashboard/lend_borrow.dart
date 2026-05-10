import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LendBorrowScreen extends StatelessWidget {
  const LendBorrowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E9E5C),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Expenso',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: const Color(0xFF1A1A1A),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Body ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Net Position Card ─────────────────────────────
                    _NetPositionCard(),
                    SizedBox(height: 20.h),

                    // ── Action Buttons Row ────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.upload_outlined,
                            iconGradient: const LinearGradient(
                              colors: [Color(0xFF7C3AED), Color(0xFFAB65F5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            label: 'New Loan',
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.download_outlined,
                            iconGradient: const LinearGradient(
                              colors: [Color(0xFFB45309), Color(0xFFD97706)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            label: 'Borrow',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 28.h),

                    // ── Active Ledgers ────────────────────────────────
                    Text(
                      'Active Ledgers',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Featured ledger card
                    _FeaturedLedgerCard(),
                    SizedBox(height: 14.h),

                    // Mini ledger cards
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
                    SizedBox(height: 28.h),

                    // ── Recent Movements ──────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Movements',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF2E9E5C),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    _MovementTile(
                      icon: Icons.account_balance_wallet_outlined,
                      iconBg: const Color(0xFFD4F8D4),
                      iconColor: const Color(0xFF2E9E5C),
                      title: 'Repayment from David',
                      subtitle: 'Private Loan • 2h ago',
                      amount: '+\$200.00',
                      amountColor: const Color(0xFF2E9E5C),
                    ),
                    SizedBox(height: 10.h),
                    _MovementTile(
                      icon: Icons.shopping_cart_outlined,
                      iconBg: const Color(0xFFFFE4C2),
                      iconColor: const Color(0xFFFF9800),
                      title: 'Borrowed for Grocery',
                      subtitle: 'Lent by Anna • Yesterday',
                      amount: '-\$45.20',
                      amountColor: const Color(0xFFE53935),
                    ),
                    SizedBox(height: 10.h),
                    _MovementTile(
                      icon: Icons.home_outlined,
                      iconBg: const Color(0xFFE8E8EE),
                      iconColor: const Color(0xFF555566),
                      title: 'Rent Contribution',
                      subtitle: 'Lent to Roommate • 3 days ago',
                      amount: '+\$750.00',
                      amountColor: const Color(0xFF2E9E5C),
                    ),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // ── Bottom Navigation Bar ────────────────────────────────────
            _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

// ── Net Position Card ──────────────────────────────────────────────────────────

class _NetPositionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B7A47), Color(0xFF38C068), Color(0xFF6EE7A0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2E9E5C).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Net Position',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            '+\$1,240.50',
            style: TextStyle(
              fontSize: 38.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LENT',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white.withValues(alpha: 0.75),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '\$2,800.00',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BORROWED',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white.withValues(alpha: 0.75),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '\$1,559.50',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
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

// ── Action Button ──────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final LinearGradient iconGradient;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.iconGradient,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: BoxDecoration(
                gradient: iconGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: iconGradient.colors.first.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 24.sp),
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Featured Ledger Card ───────────────────────────────────────────────────────

class _FeaturedLedgerCard extends StatelessWidget {
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
          // Background handshake watermark
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
                  // Avatar
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

                  // Overdue badge
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

// ── Mini Ledger Card ───────────────────────────────────────────────────────────

class _MiniLedgerCard extends StatelessWidget {
  final String name;
  final String amount;
  final Color amountColor;
  final String subLabel;
  final Color subColor;

  const _MiniLedgerCard({
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

// ── Movement Tile ──────────────────────────────────────────────────────────────

class _MovementTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;

  const _MovementTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(icon, size: 22.sp, color: iconColor),
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
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF999999),
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
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                height: 2.5,
                width: 40.w,
                decoration: BoxDecoration(
                  color: amountColor.withValues(alpha: 0.35),
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

// ── Bottom Navigation Bar ──────────────────────────────────────────────────────

class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
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
            children: [
              _NavItem(icon: Icons.home_outlined, label: 'Home', isActive: false),
              _NavItem(
                icon: Icons.account_balance_wallet_outlined,
                label: 'Expenses',
                isActive: false,
              ),
              _NavItem(
                icon: Icons.handshake_outlined,
                label: 'Lend/Borrow',
                isActive: true,
              ),
              _NavItem(icon: Icons.person_outline, label: 'Profile', isActive: false),
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
                      colors: [Color(0xFF1B7A47), Color(0xFF38C068)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                  )
                : null,
            child: Icon(
              icon,
              size: 22.sp,
              color: isActive ? Colors.white : const Color(0xFF999999),
            ),
          ),
          if (!isActive) ...[
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: const Color(0xFF999999),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
