import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen>
    with SingleTickerProviderStateMixin {
  int _selectedCategoryIndex = 0;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _amountController =
      TextEditingController(text: '120.00');
  late AnimationController _cursorAnimController;
  late Animation<double> _cursorOpacity;

  final List<_CategoryItem> _categories = [
    _CategoryItem(label: 'Food', icon: Icons.restaurant_outlined),
    _CategoryItem(label: 'Shop', icon: Icons.shopping_bag_outlined),
    _CategoryItem(label: 'Travel', icon: Icons.directions_car_outlined),
    _CategoryItem(label: 'Fun', icon: Icons.movie_filter_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _cursorAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _cursorOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _cursorAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _cursorAnimController.dispose();
    _noteController.dispose();
    _amountController.dispose();
    super.dispose();
  }

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
                children: [
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
                      Icons.account_balance_wallet_outlined,
                      color: const Color(0xFF1A1A1A),
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
            ),

            // ── Scrollable Body ──────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // ── Amount Section ─────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'How much did you spend?',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF888888),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '\$',
                                style: TextStyle(
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2E9E5C),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                _amountController.text,
                                style: TextStyle(
                                  fontSize: 52.sp,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A1A1A),
                                  letterSpacing: -1,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              // Blinking cursor
                              AnimatedBuilder(
                                animation: _cursorOpacity,
                                builder: (context, _) => Opacity(
                                  opacity: _cursorOpacity.value,
                                  child: Container(
                                    width: 3.w,
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E9E5C),
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // ── Category Section ───────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Category',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'VIEW ALL',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF7C3AED),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Category chips row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(_categories.length, (index) {
                        final isSelected = _selectedCategoryIndex == index;
                        return Padding(
                          padding: EdgeInsets.only(right: 14.w),
                          child: GestureDetector(
                            onTap: () =>
                                setState(() => _selectedCategoryIndex = index),
                            child: _CategoryChip(
                              item: _categories[index],
                              isSelected: isSelected,
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 28.h),

                    // ── Date & Wallet Row ──────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: _InfoCard(
                            iconColor: const Color(0xFF2E9E5C),
                            icon: Icons.calendar_today_outlined,
                            label: 'DATE',
                            value: 'Today, 24 Oct',
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: _InfoCard(
                            iconColor: const Color(0xFFCC8833),
                            icon: Icons.account_balance_outlined,
                            label: 'WALLET',
                            value: 'Main Savings',
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // ── Note Field ─────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _noteController,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1A1A1A),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add a quick note...',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFAAAAAA),
                          ),
                          prefixIcon: Icon(
                            Icons.edit_note_outlined,
                            size: 22.sp,
                            color: const Color(0xFFAAAAAA),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 18.h,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),

            // ── Save Button (pinned at bottom) ───────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 58.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1B7A47), Color(0xFF38C068)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2E9E5C).withValues(alpha: 0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Save Transaction',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
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

// ── Category Data Model ────────────────────────────────────────────────────────

class _CategoryItem {
  final String label;
  final IconData icon;

  const _CategoryItem({required this.label, required this.icon});
}

// ── Category Chip Widget ───────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final _CategoryItem item;
  final bool isSelected;

  const _CategoryChip({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: 72.w,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFF7C3AED), Color(0xFFAB65F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isSelected ? null : const Color(0xFFE8E8EE),
        shape: BoxShape.circle,
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFFAB65F5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : const Color(0xFFE8E8EE),
              shape: BoxShape.circle,
            ),
            child: Icon(
              item.icon,
              size: 26.sp,
              color: isSelected ? Colors.white : const Color(0xFF555566),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? const Color(0xFF7C3AED) : const Color(0xFF555566),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Card (Date / Wallet) ──────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
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
                Icon(icon, size: 16.sp, color: iconColor),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: iconColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
