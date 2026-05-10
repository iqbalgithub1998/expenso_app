import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ── Sample users the transaction can be "Used By" ─────────────────────────────

class _User {
  final String id;
  final String name;
  final Color avatarColor;
  const _User(
      {required this.id, required this.name, required this.avatarColor});
}

const List<_User> _users = [
  _User(id: 'self', name: 'Me (Self)', avatarColor: Color(0xFF2E9E5C)),
  _User(id: 'u1', name: 'Sarah Jenkins', avatarColor: Color(0xFF7C3AED)),
  _User(id: 'u2', name: 'Mike T.', avatarColor: Color(0xFFD97706)),
  _User(id: 'u3', name: 'Jessica R.', avatarColor: Color(0xFFE53935)),
  _User(id: 'u4', name: 'David K.', avatarColor: Color(0xFF1B7A47)),
];

// ── Screen ─────────────────────────────────────────────────────────────────────

class AddCardTransactionScreen extends StatefulWidget {
  const AddCardTransactionScreen({super.key});

  @override
  State<AddCardTransactionScreen> createState() =>
      _AddCardTransactionScreenState();
}

class _AddCardTransactionScreenState extends State<AddCardTransactionScreen> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String _selectedDate = '';
  String _selectedUserId = 'self';
  bool _isExpense = true; // expense vs income toggle

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
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
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        final months = [
          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];
        _selectedDate =
            '${picked.day} ${months[picked.month - 1]}, ${picked.year}';
      });
    }
  }

  _User get _selectedUser =>
      _users.firstWhere((u) => u.id == _selectedUserId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
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
                      child: Icon(Icons.arrow_back_ios_new,
                          size: 16.sp, color: const Color(0xFF1A1A1A)),
                    ),
                  ),
                  SizedBox(width: 14.w),
                  Text(
                    'Add Transaction',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A)),
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
                    SizedBox(height: 4.h),

                    // ── Type Toggle (Expense / Income) ─────────────
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: Row(
                        children: [
                          _TypeTab(
                            label: 'Expense',
                            icon: Icons.arrow_upward_rounded,
                            isActive: _isExpense,
                            activeColor: const Color(0xFFE53935),
                            onTap: () => setState(() => _isExpense = true),
                          ),
                          _TypeTab(
                            label: 'Income',
                            icon: Icons.arrow_downward_rounded,
                            isActive: !_isExpense,
                            activeColor: const Color(0xFF2E9E5C),
                            onTap: () => setState(() => _isExpense = false),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 22.h),

                    // ── Amount ─────────────────────────────────────
                    _label('Amount'),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
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
                            margin: EdgeInsets.all(12.w),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: _isExpense
                                  ? const Color(0xFFFFE4E4)
                                  : const Color(0xFFD4F8D4),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              '\$',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w700,
                                  color: _isExpense
                                      ? const Color(0xFFE53935)
                                      : const Color(0xFF2E9E5C)),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: _amountCtrl,
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}')),
                              ],
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1A1A1A)),
                              decoration: InputDecoration(
                                hintText: '0.00',
                                hintStyle: TextStyle(
                                    fontSize: 24.sp,
                                    color: const Color(0xFFCCCCCC),
                                    fontWeight: FontWeight.w700),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(right: 16.w),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // ── Date ───────────────────────────────────────
                    _label('Date'),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
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
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFB45309), Color(0xFFD97706)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(11.r),
                              ),
                              child: Icon(Icons.calendar_today_outlined,
                                  size: 18.sp, color: Colors.white),
                            ),
                            SizedBox(width: 14.w),
                            Text(
                              _selectedDate.isEmpty
                                  ? 'Select date'
                                  : _selectedDate,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: _selectedDate.isEmpty
                                      ? FontWeight.w400
                                      : FontWeight.w600,
                                  color: _selectedDate.isEmpty
                                      ? const Color(0xFFAAAAAA)
                                      : const Color(0xFF1A1A1A)),
                            ),
                            const Spacer(),
                            Icon(Icons.chevron_right,
                                size: 20.sp, color: const Color(0xFFCCCCCC)),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // ── Used By ────────────────────────────────────
                    _label('Used By'),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 80.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _users.length,
                        itemBuilder: (_, i) {
                          final u = _users[i];
                          final isSelected = _selectedUserId == u.id;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedUserId = u.id),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              margin: EdgeInsets.only(right: 12.w),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? u.avatarColor.withValues(alpha: 0.12)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSelected
                                      ? u.avatarColor
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2))
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 36.w,
                                    height: 36.w,
                                    decoration: BoxDecoration(
                                      color: u.avatarColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        u.name[0],
                                        style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    u.name.split(' ')[0],
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? u.avatarColor
                                            : const Color(0xFF666666)),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // ── Note ───────────────────────────────────────
                    _label('Note'),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ],
                      ),
                      child: TextField(
                        controller: _noteCtrl,
                        maxLines: 4,
                        style: TextStyle(
                            fontSize: 14.sp, color: const Color(0xFF1A1A1A)),
                        decoration: InputDecoration(
                          hintText: 'What was this for?',
                          hintStyle: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFFAAAAAA)),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                                left: 14.w, right: 10.w, top: 14.h),
                            child: Icon(Icons.edit_note_outlined,
                                size: 22.sp,
                                color: const Color(0xFFAAAAAA)),
                          ),
                          prefixIconConstraints: const BoxConstraints(),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.fromLTRB(
                              4.w, 16.h, 16.w, 16.h),
                        ),
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // ── Selected Summary ───────────────────────────
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
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
                              color: _selectedUser.avatarColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                _selectedUser.name[0],
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Used by',
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: const Color(0xFF888888))),
                                Text(_selectedUser.name,
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: _selectedUser.avatarColor)),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle,
                              size: 20.sp, color: _selectedUser.avatarColor),
                        ],
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // ── Save Button ────────────────────────────────
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _isExpense
                                ? [
                                    const Color(0xFFB91C1C),
                                    const Color(0xFFE53935)
                                  ]
                                : [
                                    const Color(0xFF1B7A47),
                                    const Color(0xFF38C068)
                                  ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: (_isExpense
                                      ? const Color(0xFFE53935)
                                      : const Color(0xFF2E9E5C))
                                  .withValues(alpha: 0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline,
                                color: Colors.white, size: 20.sp),
                            SizedBox(width: 10.w),
                            Text(
                              'Save Transaction',
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF666666)),
      );
}

// ── Type Tab ───────────────────────────────────────────────────────────────────

class _TypeTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _TypeTab({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 13.h),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 16.sp,
                  color: isActive ? Colors.white : const Color(0xFF999999)),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: isActive ? Colors.white : const Color(0xFF999999)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
