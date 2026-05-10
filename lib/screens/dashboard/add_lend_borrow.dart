import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddLendBorrowScreen extends StatefulWidget {
  const AddLendBorrowScreen({super.key});

  @override
  State<AddLendBorrowScreen> createState() => _AddLendBorrowScreenState();
}

class _AddLendBorrowScreenState extends State<AddLendBorrowScreen> {
  bool _isLend = true; // true = Lend Money, false = Borrow Money
  bool _reminderEnabled = true;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final List<_ChipData> _categories = [
    _ChipData(label: 'Dining', icon: Icons.restaurant_outlined),
    _ChipData(label: 'Shopping', icon: Icons.shopping_bag_outlined),
    _ChipData(label: 'Travel', icon: Icons.directions_car_outlined),
  ];

  String _selectedDate = '';

  @override
  void dispose() {
    _amountController.dispose();
    _contactController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF2E9E5C),
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Color(0xFF1A1A1A),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _selectedDate =
            '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
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
                    SizedBox(height: 4.h),

                    // ── Page Title ────────────────────────────────────
                    Text(
                      'Record\nTransaction',
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1A1A1A),
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Track your social finances with ease.',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF999999),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // ── Type Selector ─────────────────────────────────
                    Row(
                      children: [
                        // Lend Money
                        GestureDetector(
                          onTap: () => setState(() => _isLend = true),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeInOut,
                            width: 130.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 18.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: _isLend
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF7C3AED),
                                        Color(0xFFAB65F5),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: _isLend ? null : Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: _isLend
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF7C3AED,
                                        ).withValues(alpha: 0.35),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.04,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 42.w,
                                  height: 42.w,
                                  decoration: BoxDecoration(
                                    color: _isLend
                                        ? Colors.white.withValues(alpha: 0.25)
                                        : const Color(0xFFEDE9FE),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.upload_rounded,
                                    color: _isLend
                                        ? Colors.white
                                        : const Color(0xFF7C3AED),
                                    size: 22.sp,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Lend Money',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: _isLend
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Someone owes you',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: _isLend
                                        ? Colors.white.withValues(alpha: 0.75)
                                        : const Color(0xFF999999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(width: 16.w),

                        // Borrow Money
                        GestureDetector(
                          onTap: () => setState(() => _isLend = false),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 18.h,
                            ),
                            decoration: BoxDecoration(
                              gradient: !_isLend
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF1B7A47),
                                        Color(0xFF38C068),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: !_isLend ? null : Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: !_isLend
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF2E9E5C,
                                        ).withValues(alpha: 0.35),
                                        blurRadius: 14,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.04,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 42.w,
                                  height: 42.w,
                                  decoration: BoxDecoration(
                                    color: !_isLend
                                        ? Colors.white.withValues(alpha: 0.25)
                                        : const Color(0xFFD4F8D4),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    Icons.download_rounded,
                                    color: !_isLend
                                        ? Colors.white
                                        : const Color(0xFF2E9E5C),
                                    size: 22.sp,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Borrow\nMoney',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: !_isLend
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                    height: 1.2,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'You owe someone',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: !_isLend
                                        ? Colors.white.withValues(alpha: 0.75)
                                        : const Color(0xFF999999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 28.h),

                    // ── How Much ─────────────────────────────────────
                    _SectionLabel(label: 'How much?'),
                    SizedBox(height: 10.h),
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
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                              left: 16.w,
                              right: 4.w,
                              top: 2.h,
                            ),
                            child: Text(
                              '\$',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2E9E5C),
                              ),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(),
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            fontSize: 20.sp,
                            color: const Color(0xFFCCCCCC),
                            fontWeight: FontWeight.w600,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 18.h,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── With Whom ─────────────────────────────────────
                    _SectionLabel(label: 'With whom?'),
                    SizedBox(height: 10.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEF4),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: TextField(
                        controller: _contactController,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1A1A1A),
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            margin: EdgeInsets.all(10.w),
                            width: 34.w,
                            height: 34.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDD8F8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_outline,
                              size: 18.sp,
                              color: const Color(0xFF7C3AED),
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 56.w,
                          ),
                          hintText: 'Contact name',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFAAAAAA),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 18.h,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── When ──────────────────────────────────────────
                    _SectionLabel(label: 'When?'),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEF4),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 16.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36.w,
                              height: 36.w,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFB45309),
                                    Color(0xFFD97706),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.calendar_today_outlined,
                                size: 17.sp,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              _selectedDate.isEmpty
                                  ? 'mm/dd/yyyy'
                                  : _selectedDate,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: _selectedDate.isEmpty
                                    ? const Color(0xFFAAAAAA)
                                    : const Color(0xFF1A1A1A),
                                fontWeight: _selectedDate.isEmpty
                                    ? FontWeight.w400
                                    : FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── Category & Purpose ────────────────────────────
                    _SectionLabel(label: 'Category & Purpose'),
                    SizedBox(height: 12.h),
                    Wrap(
                      spacing: 10.w,
                      runSpacing: 10.h,
                      children: [
                        ..._categories.map(
                          (chip) => _CategoryChipWidget(chip: chip),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 36.w,
                            height: 36.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEEEF4),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 20.sp,
                              color: const Color(0xFF888888),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // ── Add a Note ────────────────────────────────────
                    _SectionLabel(label: 'Add a note'),
                    SizedBox(height: 10.h),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEEEF4),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: TextField(
                        controller: _noteController,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: const Color(0xFF1A1A1A),
                        ),
                        decoration: InputDecoration(
                          hintText: 'What was this for?',
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFFAAAAAA),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(16.w),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── Repayment Reminder ────────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EAFF),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDD8F8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.alarm_outlined,
                              size: 20.sp,
                              color: const Color(0xFF7C3AED),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Set Repayment Reminder',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF5B21B6),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Notify me when it's time to settle",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF7C3AED).withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _reminderEnabled,
                            onChanged: (val) =>
                                setState(() => _reminderEnabled = val),
                            activeThumbColor: Colors.white,
                            activeTrackColor: const Color(0xFF7C3AED),
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFCCCCCC),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // ── Confirm Button ────────────────────────────────
                    GestureDetector(
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
                              color: const Color(
                                0xFF2E9E5C,
                              ).withValues(alpha: 0.4),
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
                              'Confirm Transaction',
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

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),

            // ── Bottom Navigation Bar ─────────────────────────────────────
            _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

// ── Section Label ──────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF666666),
      ),
    );
  }
}

// ── Category Chip Data ─────────────────────────────────────────────────────────

class _ChipData {
  final String label;
  final IconData icon;

  const _ChipData({required this.label, required this.icon});
}

// ── Category Chip Widget ───────────────────────────────────────────────────────

class _CategoryChipWidget extends StatelessWidget {
  final _ChipData chip;

  const _CategoryChipWidget({required this.chip});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(chip.icon, size: 14.sp, color: const Color(0xFF555566)),
          SizedBox(width: 6.w),
          Text(
            chip.label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333344),
            ),
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
