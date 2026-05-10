import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ── Data Models ────────────────────────────────────────────────────────────────

enum _TxType { lent, borrowed, settled }

class _Transaction {
  final String title;
  final String date;
  final _TxType type;
  final double amount;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  const _Transaction({
    required this.title,
    required this.date,
    required this.type,
    required this.amount,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });
}

class _MonthGroup {
  final String month;
  final List<_Transaction> transactions;

  const _MonthGroup({required this.month, required this.transactions});
}

// ── Screen ─────────────────────────────────────────────────────────────────────

class FriendTransactionScreen extends StatefulWidget {
  const FriendTransactionScreen({super.key});

  @override
  State<FriendTransactionScreen> createState() =>
      _FriendTransactionScreenState();
}

class _FriendTransactionScreenState extends State<FriendTransactionScreen> {
  int _activeFilter = 0; // 0=All, 1=Lent, 2=Borrowed, 3=Settled
  final List<String> _filters = ['All', 'Lent', 'Borrowed', 'Settled'];

  final List<_MonthGroup> _groups = const [
    _MonthGroup(
      month: 'September 2023',
      transactions: [
        _Transaction(
          title: 'Dinner at Artisan',
          date: 'Sep 14, 2023 • Lent',
          type: _TxType.lent,
          amount: 125.00,
          icon: Icons.restaurant_outlined,
          iconBg: Color(0xFFD4F8D4),
          iconColor: Color(0xFF2E9E5C),
        ),
        _Transaction(
          title: 'Movie Tickets',
          date: 'Sep 08, 2023 •\nBorrowed',
          type: _TxType.borrowed,
          amount: -45.00,
          icon: Icons.movie_filter_outlined,
          iconBg: Color(0xFFFFE4C2),
          iconColor: Color(0xFFD97706),
        ),
      ],
    ),
    _MonthGroup(
      month: 'August 2023',
      transactions: [
        _Transaction(
          title: 'Monthly\nSettlement',
          date: 'Aug 31, 2023 • Settled',
          type: _TxType.settled,
          amount: 500.00,
          icon: Icons.handshake_outlined,
          iconBg: Color(0xFFEDE9FE),
          iconColor: Color(0xFF7C3AED),
        ),
        _Transaction(
          title: 'Weekend Trip\nBooking',
          date: 'Aug 12, 2023 • Lent',
          type: _TxType.lent,
          amount: 770.00,
          icon: Icons.flight_takeoff_outlined,
          iconBg: Color(0xFFD4F8D4),
          iconColor: Color(0xFF2E9E5C),
        ),
      ],
    ),
  ];

  List<_MonthGroup> get _filteredGroups {
    if (_activeFilter == 0) return _groups;
    final type = [
      null,
      _TxType.lent,
      _TxType.borrowed,
      _TxType.settled,
    ][_activeFilter];
    return _groups
        .map(
          (g) => _MonthGroup(
            month: g.month,
            transactions: g.transactions.where((t) => t.type == type).toList(),
          ),
        )
        .where((g) => g.transactions.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back + Title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.maybePop(context),
                        child: Icon(
                          Icons.arrow_back,
                          size: 22.sp,
                          color: const Color(0xFF2E9E5C),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Radiant Ledger',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E9E5C),
                        ),
                      ),
                    ],
                  ),
                  // Icons
                  Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 22.sp,
                        color: const Color(0xFF555566),
                      ),
                      SizedBox(width: 14.w),
                      // Avatar
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1B7A47), Color(0xFF38C068)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Scrollable Content ─────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    // ── Friend Avatar ──────────────────────────────────
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 110.w,
                            height: 110.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28.r),
                              gradient: const LinearGradient(
                                colors: [Color(0xFF1B7A47), Color(0xFF5ECFA0)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF2E9E5C,
                                  ).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28.r),
                              child: Icon(
                                Icons.person,
                                size: 64.sp,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                          // Online/verified badge
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              width: 28.w,
                              height: 28.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E9E5C),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF2F4F8),
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // ── Friend Name & Tag ──────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Sarah Jenkins',
                            style: TextStyle(
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1A1A1A),
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sentiment_satisfied_alt_outlined,
                                size: 15.sp,
                                color: const Color(0xFF888888),
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                'Close Friend • Since 2021',
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF888888),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── Net Balance Card ───────────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'NET BALANCE',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF999999),
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'You lent \$850.00',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF2E9E5C),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 22.h),

                    // ── Filter Tabs ────────────────────────────────────
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_filters.length, (index) {
                          final isActive = _activeFilter == index;
                          return Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _activeFilter = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18.w,
                                  vertical: 10.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFF1B7A47)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(22.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  _filters[index],
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isActive
                                        ? Colors.white
                                        : const Color(0xFF888888),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── Transaction Groups ─────────────────────────────
                    ..._filteredGroups.map(
                      (group) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Month header
                          Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              children: [
                                Text(
                                  group.month,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A1A),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    color: const Color(0xFFE0E0E0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Transactions
                          ...group.transactions.map(
                            (tx) => Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: _TransactionTile(tx: tx),
                            ),
                          ),
                          SizedBox(height: 10.h),
                        ],
                      ),
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // ── Bottom Navigation Bar ──────────────────────────────────
            _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

// ── Transaction Tile ───────────────────────────────────────────────────────────

class _TransactionTile extends StatelessWidget {
  final _Transaction tx;

  const _TransactionTile({required this.tx});

  Color get _amountColor {
    switch (tx.type) {
      case _TxType.lent:
        return const Color(0xFF2E9E5C);
      case _TxType.borrowed:
        return const Color(0xFFD97706);
      case _TxType.settled:
        return const Color(0xFF7C3AED);
    }
  }

  String get _amountText {
    final abs = tx.amount.abs();
    final formatted =
        abs == abs.truncate() ? '${abs.toInt()}.00' : abs.toStringAsFixed(2);
    if (tx.type == _TxType.lent) return '+\$$formatted';
    if (tx.type == _TxType.borrowed) return '-\$$formatted';
    return '\$$formatted';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
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
          // Icon
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: tx.iconBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(tx.icon, size: 22.sp, color: tx.iconColor),
          ),
          SizedBox(width: 14.w),

          // Title + Date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  tx.date,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF999999),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          // Amount + Arrow
          Row(
            children: [
              Text(
                _amountText,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: _amountColor,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.chevron_right,
                size: 18.sp,
                color: const Color(0xFFCCCCCC),
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
              _NavItem(
                icon: Icons.home_outlined,
                label: 'Home',
                isActive: false,
              ),
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
