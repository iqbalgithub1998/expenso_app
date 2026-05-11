import 'package:expenso/controllers/add_expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Stateless Add-Expense sheet.
/// All mutable state lives in [AddExpenseController].
class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lazily put so the controller is scoped to this sheet's lifetime.
    final c = Get.put(AddExpenseController());

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ────────────────────────────────────────────────────
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
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 18.sp,
                        color: const Color(0xFF555566),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Body ────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // ── Amount Display ─────────────────────────────────────
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
                          Obx(
                            () => Row(
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
                                  c.formattedAmount,
                                  style: TextStyle(
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1A1A1A),
                                    letterSpacing: -1,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                _BlinkingCursor(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── Numpad ─────────────────────────────────────────────
                    _Numpad(controller: c),

                    SizedBox(height: 28.h),

                    // ── Category ───────────────────────────────────────────
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

                    Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(c.categories.length, (index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 14.w),
                            child: GestureDetector(
                              onTap: () => c.selectCategory(index),
                              child: _CategoryChip(
                                item: c.categories[index],
                                isSelected:
                                    c.selectedCategoryIndex.value == index,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // ── Date & Wallet ──────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => _InfoCard(
                              iconColor: const Color(0xFF2E9E5C),
                              icon: Icons.calendar_today_outlined,
                              label: 'DATE',
                              value: c.formattedDate,
                              onTap: () => c.pickDate(context),
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Obx(
                            () => _InfoCard(
                              iconColor: const Color(0xFFCC8833),
                              icon: Icons.account_balance_outlined,
                              label: 'WALLET',
                              value: c.selectedWallet.value,
                              onTap: () => _showWalletPicker(context, c),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // ── Note ──────────────────────────────────────────────
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
                        controller: c.noteController,
                        onChanged: (v) => c.note.value = v,
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

            // ── Save Button ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: Obx(
                () => GestureDetector(
                  onTap: c.isSaving.value ? null : c.saveTransaction,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 58.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: c.isSaving.value
                            ? [
                                const Color(0xFF1B7A47).withValues(alpha: 0.6),
                                const Color(0xFF38C068).withValues(alpha: 0.6),
                              ]
                            : [
                                const Color(0xFF1B7A47),
                                const Color(0xFF38C068),
                              ],
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
                        if (c.isSaving.value)
                          SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        else
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 22.sp,
                          ),
                        SizedBox(width: 10.w),
                        Text(
                          c.isSaving.value ? 'Saving...' : 'Save Transaction',
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
            ),
          ],
        ),
      ),
    );
  }

  void _showWalletPicker(BuildContext context, AddExpenseController c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Wallet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 16.h),
            ...c.wallets.map(
              (w) => Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    w,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  trailing: c.selectedWallet.value == w
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: const Color(0xFF2E9E5C),
                          size: 20.sp,
                        )
                      : null,
                  onTap: () {
                    c.selectWallet(w);
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Blinking Cursor (replaces AnimationController in StatefulWidget)
// ─────────────────────────────────────────────────────────────────────────────
class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    _opacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (_, __) => Opacity(
        opacity: _opacity.value,
        child: Container(
          width: 3.w,
          height: 48.h,
          decoration: BoxDecoration(
            color: const Color(0xFF2E9E5C),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Numpad
// ─────────────────────────────────────────────────────────────────────────────
class _Numpad extends StatelessWidget {
  final AddExpenseController controller;
  const _Numpad({required this.controller});

  static const _keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['.', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: _keys.map((row) {
          return Row(
            children: row.map((key) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (key == '⌫') {
                      controller.deleteDigit();
                    } else if (key == '.') {
                      controller.appendDecimal();
                    } else {
                      controller.appendDigit(key);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(4.w),
                    height: 52.h,
                    decoration: BoxDecoration(
                      color: key == '⌫'
                          ? const Color(0xFFFFEEEE)
                          : const Color(0xFFF5F6FA),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: key == '⌫'
                          ? Icon(
                              Icons.backspace_outlined,
                              size: 18.sp,
                              color: const Color(0xFFFF5252),
                            )
                          : Text(
                              key,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Chip
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final CategoryItem item;
  final bool isSelected;

  const _CategoryChip({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
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
              color: isSelected
                  ? const Color(0xFF7C3AED)
                  : const Color(0xFF555566),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Info Card (Date / Wallet)
// ─────────────────────────────────────────────────────────────────────────────
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
