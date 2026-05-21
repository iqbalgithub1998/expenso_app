import 'package:expenso/controllers/add_expense_controller.dart';
import 'package:expenso/models/category_items.dart';
import 'package:expenso/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddExpenseScreen extends StatelessWidget {
  const AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AddExpenseController());

    return Scaffold(
      backgroundColor: const Color(0xFF0D0F14),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00C853), Color(0xFF00E676)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(13.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF00E676,
                          ).withValues(alpha: 0.30),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Expenso',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  // Close
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 38.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1D26),
                        borderRadius: BorderRadius.circular(11.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        size: 16.sp,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Scrollable Body ────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    // ── Amount display ─────────────────────────────────────
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'How much did you spend?',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: const Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 18.h),
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '₹',
                                  style: TextStyle(
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF00E676),
                                    height: 1.6,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  c.formattedAmount,
                                  style: TextStyle(
                                    fontSize: 54.sp,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -1.5,
                                    height: 1.0,
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

                    SizedBox(height: 24.h),

                    // ── Category ───────────────────────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _SectionHeader('Category'),
                        GestureDetector(
                          onTap: () => _showAllCategoriesSheet(context, c),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFBB86FC,
                              ).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: const Color(
                                  0xFFBB86FC,
                                ).withValues(alpha: 0.25),
                              ),
                            ),
                            child: Text(
                              'CHANGE',
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFBB86FC),
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // Selected category — single chip display
                    Obx(() {
                      final idx = c.selectedCategoryIndex.value;

                      // Flag to check if no category is selected yet
                      final hasNoSelection =
                          idx == -1 || idx >= categories.length;
                      final category = hasNoSelection ? null : categories[idx];

                      return Theme(
                        data: Theme.of(
                          context,
                        ).copyWith(splashColor: Colors.transparent),
                        child: InkWell(
                          onTap: () => _showAllCategoriesSheet(context, c),
                          borderRadius: BorderRadius.circular(12.r),
                          highlightColor: Colors.white.withOpacity(0.05),
                          splashColor: Colors.white.withOpacity(0.1),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.h,
                              horizontal: 4.w,
                            ),
                            child: Row(
                              children: [
                                // --- Dynamic Chip Area ---
                                hasNoSelection
                                    ? Container(
                                        width: 44
                                            .w, // Adjust to match your _CategoryChip dimensions
                                        height: 44.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.03),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.15,
                                            ),
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons
                                              .grid_view_rounded, // Clean placeholder layout icon
                                          size: 20.sp,
                                          color: const Color(0xFF9CA3AF),
                                        ),
                                      )
                                    : _CategoryChip(
                                        item: category!,
                                        isSelected: true,
                                      ),

                                SizedBox(width: 14.w),

                                // --- Text Stack ---
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        hasNoSelection
                                            ? 'Select Category'
                                            : category!.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w700,
                                          // Muted color opacity for placeholder text state
                                          color: hasNoSelection
                                              ? Colors.white.withOpacity(0.5)
                                              : Colors.white,
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.touch_app_rounded,
                                            size: 12.sp,
                                            color: const Color(0xFF9CA3AF),
                                          ),
                                          SizedBox(width: 4.w),
                                          Text(
                                            hasNoSelection
                                                ? 'Tap to choose one'
                                                : 'Tap to change category',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                              color: const Color(0xFF9CA3AF),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(width: 8.w),

                                // --- Trailing Action Indicator ---
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: const Color(0xFF9CA3AF),
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    SizedBox(height: 24.h),

                    // ── Date & Wallet ──────────────────────────────────────
                    _SectionHeader('Details'),
                    SizedBox(height: 12.h),

                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => _InfoCard(
                              icon: Icons.calendar_today_rounded,
                              iconColor: const Color(0xFFFFB74D),
                              iconBg: const Color(0xFF1E1A12),
                              label: 'DATE',
                              value: c.formattedDate,
                              onTap: () => c.pickDate(context),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // ── Note ──────────────────────────────────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF141720),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                      child: TextField(
                        maxLines: 5,
                        controller: c.noteController,
                        onChanged: (v) => c.note.value = v,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Add a quick note...',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF4B5563),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(left: 14.w, right: 8.w),
                            child: Icon(
                              Icons.edit_note_rounded,
                              size: 20.sp,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 16.h,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 28.h),
                  ],
                ),
              ),
            ),

            // ── Save Button ────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: Obx(
                () => GestureDetector(
                  onTap: () =>
                      c.isSaving.value ? null : c.saveTransaction(context),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 58.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: c.isSaving.value
                            ? [
                                const Color(0xFF00603A).withValues(alpha: 0.55),
                                const Color(0xFF00E676).withValues(alpha: 0.55),
                              ]
                            : [
                                const Color(0xFF00A854),
                                const Color(0xFF00E676),
                              ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(22.r),
                      boxShadow: c.isSaving.value
                          ? []
                          : [
                              BoxShadow(
                                color: const Color(
                                  0xFF00C853,
                                ).withValues(alpha: 0.35),
                                blurRadius: 24,
                                spreadRadius: -4,
                                offset: const Offset(0, 10),
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
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        else
                          Container(
                            width: 26.w,
                            height: 26.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.20),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check_rounded,
                              size: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        SizedBox(width: 10.w),
                        Text(
                          c.isSaving.value ? 'Saving...' : 'Save Transaction',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.2,
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

  void _showAllCategoriesSheet(BuildContext context, AddExpenseController c) {
    final searchController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final query = searchController.text.trim().toLowerCase();
            final filtered = query.isEmpty
                ? categories
                : categories
                      .where((cat) => cat.label.toLowerCase().contains(query))
                      .toList();

            return Container(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 28.h),
              decoration: BoxDecoration(
                color: const Color(0xFF0D0F14),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
                border: Border(
                  top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
                      width: 36.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                  SizedBox(height: 14.h),

                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF141720),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      autofocus: false,
                      style: TextStyle(fontSize: 13.sp, color: Colors.white),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search category…',
                        hintStyle: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF4B5563),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 14.w, right: 8.w),
                          child: Icon(
                            Icons.search_rounded,
                            size: 18.sp,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 14.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Category grid
                  if (filtered.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      child: Center(
                        child: Text(
                          'No categories found.',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 380.h,
                      child: GridView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 14.h,
                          crossAxisSpacing: 10.w,
                          childAspectRatio: 0.82,
                        ),
                        itemBuilder: (_, i) {
                          final item = filtered[i];
                          final realIndex = categories.indexOf(item);
                          final isSel =
                              c.selectedCategoryIndex.value == realIndex;

                          return GestureDetector(
                            onTap: () {
                              c.selectCategory(realIndex);
                              Navigator.pop(context);
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 56.w,
                                  height: 56.w,
                                  decoration: BoxDecoration(
                                    gradient: isSel
                                        ? const LinearGradient(
                                            colors: [
                                              Color(0xFF7C3AED),
                                              Color(0xFFBB86FC),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          )
                                        : null,
                                    color: isSel
                                        ? null
                                        : const Color(0xFF1A1D26),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSel
                                          ? Colors.transparent
                                          : Colors.white.withValues(
                                              alpha: 0.07,
                                            ),
                                    ),
                                  ),
                                  child: Icon(
                                    item.icon,
                                    size: 22.sp,
                                    color: isSel
                                        ? Colors.white
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    color: isSel
                                        ? const Color(0xFFBB86FC)
                                        : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showWalletSheet(BuildContext context, AddExpenseController c) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 28.h),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0F14),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
                width: 36.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Text(
              'Select Wallet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 16.h),
            ...c.wallets.map(
              (w) => Obx(() {
                final isSel = c.selectedWallet.value == w;
                return GestureDetector(
                  onTap: () {
                    c.selectWallet(w);
                    Navigator.pop(context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSel
                          ? const Color(0xFF00C853).withValues(alpha: 0.10)
                          : const Color(0xFF141720),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: isSel
                            ? const Color(0xFF00E676).withValues(alpha: 0.35)
                            : Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _walletIcon(w),
                          size: 18.sp,
                          color: isSel
                              ? const Color(0xFF00E676)
                              : const Color(0xFF6B7280),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            w,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isSel
                                  ? Colors.white
                                  : const Color(0xFF9CA3AF),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        if (isSel)
                          Icon(
                            Icons.check_circle_rounded,
                            size: 18.sp,
                            color: const Color(0xFF00E676),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  IconData _walletIcon(String wallet) {
    switch (wallet) {
      case 'Bank Account':
        return Icons.account_balance_rounded;
      case 'Credit Card':
        return Icons.credit_card_rounded;
      case 'UPI':
        return Icons.phone_android_rounded;
      default:
        return Icons.wallet_rounded;
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Blinking cursor
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
      duration: const Duration(milliseconds: 550),
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
          height: 50.h,
          decoration: BoxDecoration(
            color: const Color(0xFF00E676),
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
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      padding: EdgeInsets.all(10.w),
      child: Column(
        children: _keys.map((row) {
          return Row(
            children: row.map((key) {
              final isDelete = key == '⌫';
              final isDot = key == '.';
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (isDelete) {
                      controller.deleteDigit();
                    } else if (isDot) {
                      controller.appendDecimal();
                    } else {
                      controller.appendDigit(key);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    margin: EdgeInsets.all(4.w),
                    height: 54.h,
                    decoration: BoxDecoration(
                      color: isDelete
                          ? const Color(0xFFFF5252).withValues(alpha: 0.10)
                          : const Color(0xFF1A1D26),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: isDelete
                            ? const Color(0xFFFF5252).withValues(alpha: 0.20)
                            : Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Center(
                      child: isDelete
                          ? Icon(
                              Icons.backspace_rounded,
                              size: 18.sp,
                              color: const Color(0xFFFF5252),
                            )
                          : Text(
                              key,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: isDot
                                    ? const Color(0xFF9CA3AF)
                                    : Colors.white,
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
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF7C3AED), Color(0xFFBB86FC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: isSelected ? null : const Color(0xFF1A1D26),
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? Colors.transparent
                    : Colors.white.withValues(alpha: 0.07),
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xFF7C3AED).withValues(alpha: 0.35),
                        blurRadius: 14,
                        spreadRadius: -2,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              item.icon,
              size: 24.sp,
              color: isSelected ? Colors.white : const Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            item.label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFFBB86FC)
                  : const Color(0xFF6B7280),
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
  final Color iconBg;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF141720),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 16.sp, color: iconColor),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w700,
                      color: iconColor.withValues(alpha: 0.80),
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16.sp,
              color: const Color(0xFF4B5563),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.3,
      ),
    );
  }
}
