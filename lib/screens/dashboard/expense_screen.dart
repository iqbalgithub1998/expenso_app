import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              // App Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CD964),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet,
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
                      color: const Color(0xFFE8E8E8),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.notifications_outlined,
                      color: const Color(0xFF1A1A1A),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              // Total Expenses
              Text(
                'Total Expenses',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF999999),
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$2,840',
                    style: TextStyle(
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 6.h),
                    child: Text(
                      '.50',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Top Category Card + Stats Row
              Row(
                children: [
                  // Top Category Card
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E9E5C), Color(0xFF4CD964)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'TOP CATEGORY',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white.withValues(alpha: 0.8),
                              letterSpacing: 1,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Dining',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Stats pills column
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        // Daily Avg pill
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0E6FA),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF9B59B6),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.bolt,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Daily Avg',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF9B59B6),
                                    ),
                                  ),
                                  Text(
                                    '\$94',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF9B59B6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // Saved pill
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3E0),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF9800),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Icon(
                                  Icons.savings_outlined,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Saved',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: const Color(0xFFFF9800),
                                    ),
                                  ),
                                  Text(
                                    '\$420',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFFFF9800),
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
                ],
              ),
              SizedBox(height: 28.h),
              // Recent Activity Header
              Text(
                'Flowing Energy',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF999999),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 24.h),
              // Timeline List
              _buildDayGroup(
                dayNumber: '24',
                dayLabel: 'Today',
                monthLabel: 'November 2023',
                items: [
                  _TimelineItemData(
                    icon: Icons.shopping_bag_outlined,
                    iconBgColor: const Color(0xFFF0E6FA),
                    iconColor: const Color(0xFF9B59B6),
                    title: 'Luxury Boutique',
                    subtitle: 'Apparel & Style',
                    amount: '-\$120.00',
                    amountColor: const Color(0xFF1A1A1A),
                    time: '14:20 PM',
                  ),
                  _TimelineItemData(
                    icon: Icons.account_balance_wallet_outlined,
                    iconBgColor: const Color(0xFFD4F8D4),
                    iconColor: const Color(0xFF2E9E5C),
                    title: 'Salary Deposit',
                    subtitle: 'Tech Corp Inc.',
                    amount: '+\$3,120.00',
                    amountColor: const Color(0xFF2E9E5C),
                    time: '09:15 AM',
                  ),
                ],
              ),
              _buildDayGroup(
                dayNumber: '23',
                dayLabel: 'Yesterday',
                monthLabel: 'November 2023',
                items: [
                  _TimelineItemData(
                    icon: Icons.restaurant_outlined,
                    iconBgColor: const Color(0xFFFFF3E0),
                    iconColor: const Color(0xFFFF9800),
                    title: 'The Green Bistro',
                    subtitle: 'Dining & Drinks',
                    amount: '-\$85.50',
                    amountColor: const Color(0xFF1A1A1A),
                    time: '20:45 PM',
                  ),
                  _TimelineItemData(
                    icon: Icons.bolt,
                    iconBgColor: const Color(0xFFFFF0F0),
                    iconColor: const Color(0xFFE53935),
                    title: 'Utilities',
                    subtitle: 'Monthly Billing',
                    amount: '-\$145.00',
                    amountColor: const Color(0xFF1A1A1A),
                    time: '08:00 AM',
                  ),
                ],
              ),
              _buildDayGroup(
                dayNumber: '22',
                dayLabel: 'Earlier',
                monthLabel: 'November 2023',
                items: [
                  _TimelineItemData(
                    icon: Icons.local_gas_station_outlined,
                    iconBgColor: const Color(0xFFF5F5F5),
                    iconColor: const Color(0xFF9E9E9E),
                    title: 'Shell Station',
                    subtitle: 'Transport',
                    amount: '-\$65.00',
                    amountColor: const Color(0xFF1A1A1A),
                    time: '17:10 PM',
                  ),
                ],
                isLast: true,
              ),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 60.w,
        height: 60.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E9E5C), Color(0xFF4CD964)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E9E5C).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(Icons.add, color: Colors.white, size: 28.sp),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E9E5C),
        unselectedItemColor: const Color(0xFF999999),
        selectedFontSize: 10.sp,
        unselectedFontSize: 10.sp,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake_outlined),
            label: 'Lend/Borrow',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDayGroup({
    required String dayNumber,
    required String dayLabel,
    required String monthLabel,
    required List<_TimelineItemData> items,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          Column(
            children: [
              // Day circle
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    dayNumber,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF666666),
                    ),
                  ),
                ),
              ),
              // Connector line
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: const Color(0xFFE8E8E8),
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          // Content column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dayLabel,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      monthLabel,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Items
                ...items.map((item) => _buildTimelineItemCard(item)),
                if (!isLast) SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItemCard(_TimelineItemData item) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: item.iconBgColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(item.icon, size: 20.sp, color: item.iconColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  item.subtitle,
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
                item.amount,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: item.amountColor,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                item.time,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color(0xFF999999),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineItemData {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final String time;

  _TimelineItemData({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
    required this.time,
  });
}
