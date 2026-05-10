import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'add_card_transaction.dart';

// ── Data Models ────────────────────────────────────────────────────────────────

class _Tx {
  final String title;
  final String subtitle;
  final double amount;
  final String time;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final bool isHighlighted;

  const _Tx({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.isHighlighted = false,
  });
}

class _DayGroup {
  final int day;
  final String label;
  final String month;
  final List<_Tx> txs;
  const _DayGroup(
      {required this.day,
      required this.label,
      required this.month,
      required this.txs});
}

// ── Screen ─────────────────────────────────────────────────────────────────────

class CreditCardDetailsScreen extends StatefulWidget {
  const CreditCardDetailsScreen({super.key});

  @override
  State<CreditCardDetailsScreen> createState() =>
      _CreditCardDetailsScreenState();
}

class _CreditCardDetailsScreenState extends State<CreditCardDetailsScreen> {
  bool _cardActive = true;

  static const List<_DayGroup> _groups = [
    _DayGroup(
      day: 24,
      label: 'Today',
      month: 'November 2023',
      txs: [
        _Tx(
          title: 'Luxury Boutique',
          subtitle: 'Apparel & Style',
          amount: -120.00,
          time: '14:20 PM',
          icon: Icons.shopping_bag_outlined,
          iconBg: Color(0xFFEDE9FE),
          iconColor: Color(0xFF7C3AED),
        ),
        _Tx(
          title: 'Salary Deposit',
          subtitle: 'Tech Corp Inc.',
          amount: 3120.00,
          time: '09:15 AM',
          icon: Icons.account_balance_wallet_outlined,
          iconBg: Color(0xFFD4F8D4),
          iconColor: Color(0xFF2E9E5C),
        ),
      ],
    ),
    _DayGroup(
      day: 23,
      label: 'Yesterday',
      month: 'November 2023',
      txs: [
        _Tx(
          title: 'The Green Bistro',
          subtitle: 'Dining & Drinks',
          amount: -85.50,
          time: '20:45 PM',
          icon: Icons.restaurant_outlined,
          iconBg: Color(0xFFFFE4C2),
          iconColor: Color(0xFFD97706),
        ),
        _Tx(
          title: 'Delta Air Lines',
          subtitle: 'Vacation Booking',
          amount: -1250.00,
          time: '13:00 PM',
          icon: Icons.flight_takeoff_outlined,
          iconBg: Color(0xFF7C3AED),
          iconColor: Colors.white,
          isHighlighted: true,
        ),
        _Tx(
          title: 'Utilities',
          subtitle: 'Monthly Billing',
          amount: -145.00,
          time: '08:00 AM',
          icon: Icons.bolt_outlined,
          iconBg: Color(0xFFFFE4C2),
          iconColor: Color(0xFFE53935),
        ),
      ],
    ),
    _DayGroup(
      day: 21,
      label: 'Earlier',
      month: 'November 2023',
      txs: [
        _Tx(
          title: 'Shell Station',
          subtitle: 'Transport',
          amount: -65.00,
          time: '17:10 PM',
          icon: Icons.local_gas_station_outlined,
          iconBg: Color(0xFFE8E8EE),
          iconColor: Color(0xFF555566),
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      floatingActionButton: _fab(context),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──────────────────────────────────────────────
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
                        child: Icon(Icons.account_balance_wallet_outlined,
                            color: Colors.white, size: 20.sp),
                      ),
                      SizedBox(width: 12.w),
                      Text('Expenso',
                          style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A1A))),
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
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Icon(Icons.notifications_outlined,
                        color: const Color(0xFF1A1A1A), size: 20.sp),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Section Title ──────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Your Assets',
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF1A1A1A))),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(Icons.add_circle_outline,
                                  size: 16.sp,
                                  color: const Color(0xFF2E9E5C)),
                              SizedBox(width: 4.w),
                              Text('New Card',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF2E9E5C))),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // ── Card Widget ────────────────────────────────
                    _buildCard(),
                    SizedBox(height: 8.h),

                    // ── Card Bank Name ─────────────────────────────
                    Text('Flowing Energy',
                        style: TextStyle(
                            fontSize: 12.sp, color: const Color(0xFF999999))),
                    SizedBox(height: 4.h),
                    Text('Recent Activity',
                        style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1A1A1A))),
                    SizedBox(height: 16.h),

                    // ── Transaction Groups ─────────────────────────
                    ..._groups.map((g) => _buildGroup(g)),
                    SizedBox(height: 90.h),
                  ],
                ),
              ),
            ),

            _BottomNavBar(),
          ],
        ),
      ),
    );
  }

  // ── Credit Card Widget ───────────────────────────────────────────────────────

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      height: 190.h,
      padding: EdgeInsets.all(22.w),
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
              offset: const Offset(0, 8))
        ],
      ),
      child: Stack(
        children: [
          // Watermark circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 110.w,
              height: 110.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            right: 50,
            bottom: -30,
            child: Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          // Bar chart icon top-right
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.bar_chart_rounded,
                  size: 18.sp, color: Colors.white),
            ),
          ),
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('TOTAL BALANCE',
                  style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 1)),
              SizedBox(height: 4.h),
              Text('\$12,450.80',
                  style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5)),
              SizedBox(height: 10.h),
              Text('• • • •   • • • •   • • • •',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 0.6),
                      letterSpacing: 3)),
              SizedBox(height: 6.h),
              Text('8 8 4 2',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 4)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('EXPIRES 08/28',
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white.withValues(alpha: 0.65),
                          letterSpacing: 0.8)),
                  GestureDetector(
                    onTap: () => setState(() => _cardActive = !_cardActive),
                    child: Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: _cardActive,
                        onChanged: (v) => setState(() => _cardActive = v),
                        activeThumbColor: Colors.white,
                        activeTrackColor:
                            Colors.white.withValues(alpha: 0.35),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor:
                            Colors.white.withValues(alpha: 0.2),
                      ),
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

  // ── Day Group ────────────────────────────────────────────────────────────────

  Widget _buildGroup(_DayGroup g) {
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
                color: const Color(0xFFE0E0E0),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('${g.day}',
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF555566))),
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(g.label,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A))),
                Text(g.month,
                    style: TextStyle(
                        fontSize: 11.sp, color: const Color(0xFF999999))),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ...g.txs.map((tx) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: _TxTile(tx: tx),
            )),
        SizedBox(height: 10.h),
      ],
    );
  }

  // ── FAB ──────────────────────────────────────────────────────────────────────

  Widget _fab(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => const AddCardTransactionScreen()),
      ),
      child: Container(
        width: 60.w,
        height: 60.w,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B7A47), Color(0xFF38C068)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF2E9E5C).withValues(alpha: 0.5),
                blurRadius: 14,
                offset: const Offset(0, 5))
          ],
        ),
        child: Icon(Icons.add, color: Colors.white, size: 28.sp),
      ),
    );
  }
}

// ── Transaction Tile ───────────────────────────────────────────────────────────

class _TxTile extends StatelessWidget {
  final _Tx tx;
  const _TxTile({required this.tx});

  String get _amountText {
    final abs = tx.amount.abs().toStringAsFixed(2);
    return tx.amount >= 0 ? '+\$$abs' : '-\$$abs';
  }

  Color get _amountColor =>
      tx.amount >= 0 ? const Color(0xFF2E9E5C) : const Color(0xFFE53935);

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
                color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                blurRadius: 14,
                offset: const Offset(0, 5))
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(tx.icon, size: 22.sp, color: Colors.white),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tx.title,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  SizedBox(height: 3.h),
                  Text(tx.subtitle,
                      style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white.withValues(alpha: 0.75))),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(_amountText,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
                SizedBox(height: 3.h),
                Text(tx.time,
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white.withValues(alpha: 0.7))),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: BoxDecoration(
              color: tx.iconBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(tx.icon, size: 22.sp, color: tx.iconColor),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A))),
                SizedBox(height: 3.h),
                Text(tx.subtitle,
                    style: TextStyle(
                        fontSize: 11.sp, color: const Color(0xFF999999))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_amountText,
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w800,
                      color: _amountColor)),
              SizedBox(height: 3.h),
              Text(tx.time,
                  style: TextStyle(
                      fontSize: 10.sp, color: const Color(0xFF999999))),
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
              offset: const Offset(0, -2))
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
                  isActive: true),
              _NavItem(
                  icon: Icons.handshake_outlined,
                  label: 'Lend/Borrow',
                  isActive: false),
              _NavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  isActive: false),
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
  const _NavItem(
      {required this.icon, required this.label, required this.isActive});

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
            child: Icon(icon,
                size: 22.sp,
                color: isActive ? Colors.white : const Color(0xFF999999)),
          ),
          if (!isActive) ...[
            SizedBox(height: 2.h),
            Text(label,
                style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF999999),
                    fontWeight: FontWeight.w500)),
          ],
        ],
      ),
    );
  }
}
