import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ── Data Models ────────────────────────────────────────────────────────────────

class _CardData {
  final String name;
  final String last4;
  final double balance;
  final double limit;
  final Color bgStart;
  final Color bgEnd;
  final Color textColor;
  final bool isDark;

  const _CardData({
    required this.name,
    required this.last4,
    required this.balance,
    required this.limit,
    required this.bgStart,
    required this.bgEnd,
    required this.textColor,
    this.isDark = false,
  });

  double get usedPercent => balance / limit;
  String get usedLabel => '${(usedPercent * 100).toStringAsFixed(1)}% USED';
  String get limitLabel => 'LIMIT  \$${(limit / 1000).toStringAsFixed(0)}K';
}

class _PaymentData {
  final String cardName;
  final String last4;
  final double minDue;
  final String dueLabel;
  final bool isUrgent;

  const _PaymentData({
    required this.cardName,
    required this.last4,
    required this.minDue,
    required this.dueLabel,
    required this.isUrgent,
  });
}

// ── Screen ─────────────────────────────────────────────────────────────────────

class CreditCardsScreen extends StatelessWidget {
  const CreditCardsScreen({super.key});

  static const List<_CardData> _cards = [
    _CardData(
      name: 'Platinum Elite',
      last4: '8024',
      balance: 4120.45,
      limit: 15000,
      bgStart: Color(0xFF1C1C2E),
      bgEnd: Color(0xFF2D2D44),
      textColor: Colors.white,
      isDark: true,
    ),
    _CardData(
      name: 'Obsidian Infinite',
      last4: '4112',
      balance: 8450.00,
      limit: 70000,
      bgStart: Colors.white,
      bgEnd: Color(0xFFF5F5F5),
      textColor: Color(0xFF1A1A1A),
    ),
    _CardData(
      name: 'Emerald Rewards',
      last4: '9003',
      balance: 1200.00,
      limit: 10000,
      bgStart: Color(0xFF38C068),
      bgEnd: Color(0xFF1B7A47),
      textColor: Colors.white,
      isDark: true,
    ),
  ];

  static const List<_PaymentData> _payments = [
    _PaymentData(
      cardName: 'Obsidian Infinite',
      last4: '4112',
      minDue: 450.00,
      dueLabel: 'Due in 7 days • Dec 14',
      isUrgent: true,
    ),
    _PaymentData(
      cardName: 'Platinum Elite',
      last4: '8024',
      minDue: 120.00,
      dueLabel: 'Due in 15 days • Dec 27',
      isUrgent: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F8),
      floatingActionButton: _AddCardFAB(),
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

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Section Header ─────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Cards',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4F8D4),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '${_cards.length} ACTIVE',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B7A47),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),

                    // ── Card List ──────────────────────────────────
                    ..._cards.map(
                      (card) => Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: _CreditCardWidget(card: card),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // ── Payment Schedule ───────────────────────────
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Payment Schedule',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ..._payments.map(
                            (p) => Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: _PaymentTile(payment: p),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 90.h),
                  ],
                ),
              ),
            ),

            // ── Bottom Nav ─────────────────────────────────────────────
            _BottomNavBar(),
          ],
        ),
      ),
    );
  }
}

// ── Credit Card Widget ─────────────────────────────────────────────────────────

class _CreditCardWidget extends StatelessWidget {
  final _CardData card;

  const _CreditCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    final subtleColor = card.isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.black.withValues(alpha: 0.06);
    final labelColor = card.isDark
        ? Colors.white.withValues(alpha: 0.6)
        : const Color(0xFF999999);
    final progressBg = card.isDark
        ? Colors.white.withValues(alpha: 0.15)
        : const Color(0xFFE0E0E0);
    final progressFill = card.isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [card.bgStart, card.bgEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: card.bgStart.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card name + chip icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: card.textColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '•••• ${card.last4}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: labelColor,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: subtleColor,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.credit_card,
                  size: 20.sp,
                  color: card.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // Balance
          Text(
            'Current Balance',
            style: TextStyle(fontSize: 11.sp, color: labelColor),
          ),
          SizedBox(height: 4.h),
          Text(
            '\$${_fmt(card.balance)}',
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w900,
              color: card.textColor,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 14.h),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: card.usedPercent,
              minHeight: 4.h,
              backgroundColor: progressBg,
              valueColor: AlwaysStoppedAnimation<Color>(progressFill),
            ),
          ),
          SizedBox(height: 8.h),

          // Limit + used
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.limitLabel,
                style: TextStyle(fontSize: 10.sp, color: labelColor),
              ),
              Text(
                card.usedLabel,
                style: TextStyle(fontSize: 10.sp, color: labelColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    final parts = v.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$intPart.${parts[1]}';
  }
}

// ── Payment Tile ───────────────────────────────────────────────────────────────

class _PaymentTile extends StatelessWidget {
  final _PaymentData payment;

  const _PaymentTile({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: payment.isUrgent
            ? const Color(0xFFFFF5F5)
            : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(14.r),
        border: Border(
          left: BorderSide(
            color: payment.isUrgent
                ? const Color(0xFFE53935)
                : const Color(0xFFCCCCCC),
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: payment.isUrgent
                  ? const Color(0xFFFFE0E0)
                  : const Color(0xFFE8E8EE),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              payment.isUrgent
                  ? Icons.warning_amber_rounded
                  : Icons.receipt_long_outlined,
              size: 20.sp,
              color: payment.isUrgent
                  ? const Color(0xFFE53935)
                  : const Color(0xFF888888),
            ),
          ),
          SizedBox(width: 12.w),

          // Labels
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.cardName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  payment.dueLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),

          // Amount + badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${payment.minDue.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: payment.isUrgent
                      ? const Color(0xFFE53935)
                      : const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: payment.isUrgent
                      ? const Color(0xFFE53935)
                      : const Color(0xFF888888),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'MIN DUE',
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
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

// ── Add Card FAB ───────────────────────────────────────────────────────────────

class _AddCardFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const _AddCardBottomSheet(),
        );
      },
      child: Container(
        height: 56.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1B7A47), Color(0xFF38C068)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E9E5C).withValues(alpha: 0.45),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_card_outlined, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Add New Card',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Add Card Bottom Sheet ──────────────────────────────────────────────────────

class _AddCardBottomSheet extends StatefulWidget {
  const _AddCardBottomSheet();

  @override
  State<_AddCardBottomSheet> createState() => _AddCardBottomSheetState();
}

class _AddCardBottomSheetState extends State<_AddCardBottomSheet> {
  final _nameCtrl = TextEditingController();
  final _last4Ctrl = TextEditingController();
  final _billingCtrl = TextEditingController();
  final _paymentCtrl = TextEditingController();

  // Live card preview state
  String _previewName = 'Card Name';
  String _previewLast4 = '0000';
  String _previewBilling = '--';
  String _previewPayment = '--';

  // Selected card theme index
  int _themeIndex = 0;

  final List<List<Color>> _themes = [
    [const Color(0xFF1C1C2E), const Color(0xFF2D2D44)], // Dark
    [const Color(0xFF1B7A47), const Color(0xFF38C068)], // Green
    [const Color(0xFF7C3AED), const Color(0xFFAB65F5)], // Purple
    [const Color(0xFFB45309), const Color(0xFFD97706)], // Amber
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _last4Ctrl.dispose();
    _billingCtrl.dispose();
    _paymentCtrl.dispose();
    super.dispose();
  }

  bool get _isDark => _themeIndex != 3; // amber is light-ish but keep white

  @override
  Widget build(BuildContext context) {
    final theme = _themes[_themeIndex];
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle ──────────────────────────────────────────────
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12.h, bottom: 20.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFCCCCCC),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            Text(
              'Add New Card',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            Text(
              'Fill in your card details below',
              style: TextStyle(fontSize: 13.sp, color: const Color(0xFF999999)),
            ),
            SizedBox(height: 22.h),

            // ── Live Card Preview ────────────────────────────────────
            Container(
              width: double.infinity,
              height: 180.h,
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: theme,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22.r),
                boxShadow: [
                  BoxShadow(
                    color: theme[0].withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Watermark circles
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Container(
                      width: 100.w,
                      height: 100.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.07),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
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
                  // Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _previewName,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.credit_card,
                            size: 22.sp,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Chip icon
                      Container(
                        width: 32.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '•••• •••• •••• $_previewLast4',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BILLING DATE',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                _previewBilling,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 24.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'PAYMENT DUE',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.white.withValues(alpha: 0.6),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                _previewPayment,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 18.h),

            // ── Theme Picker ─────────────────────────────────────────
            Row(
              children: List.generate(_themes.length, (i) {
                final isSelected = _themeIndex == i;
                return GestureDetector(
                  onTap: () => setState(() => _themeIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: EdgeInsets.only(right: 10.w),
                    width: isSelected ? 32.w : 26.w,
                    height: isSelected ? 32.w : 26.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _themes[i],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: _themes[i][0].withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                  ),
                );
              }),
            ),

            SizedBox(height: 22.h),

            // ── Form Fields ──────────────────────────────────────────
            _FormField(
              label: 'Card Name',
              hint: 'e.g. Platinum Elite',
              icon: Icons.credit_card_outlined,
              iconColor: const Color(0xFF2E9E5C),
              controller: _nameCtrl,
              onChanged: (v) =>
                  setState(() => _previewName = v.isEmpty ? 'Card Name' : v),
            ),
            SizedBox(height: 14.h),
            _FormField(
              label: 'Last 4 Digits',
              hint: '0000',
              icon: Icons.pin_outlined,
              iconColor: const Color(0xFF7C3AED),
              controller: _last4Ctrl,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              onChanged: (v) => setState(
                () => _previewLast4 = v.isEmpty ? '0000' : v.padRight(4, '0'),
              ),
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: _FormField(
                    label: 'Billing Date',
                    hint: 'Day (1-31)',
                    icon: Icons.calendar_today_outlined,
                    iconColor: const Color(0xFFD97706),
                    controller: _billingCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    onChanged: (v) => setState(
                      () => _previewBilling = v.isEmpty ? '--' : '${v}th',
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: _FormField(
                    label: 'Payment Due Date',
                    hint: 'Day (1-31)',
                    icon: Icons.event_outlined,
                    iconColor: const Color(0xFFE53935),
                    controller: _paymentCtrl,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    onChanged: (v) => setState(
                      () => _previewPayment = v.isEmpty ? '--' : '${v}th',
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 28.h),

            // ── Save Button ──────────────────────────────────────────
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: double.infinity,
                height: 56.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _themes[_themeIndex],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: _themes[_themeIndex][0].withValues(alpha: 0.4),
                      blurRadius: 14,
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
                      size: 20.sp,
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Save Card',
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
      ),
    );
  }
}

// ── Form Field Helper ──────────────────────────────────────────────────────────

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final Color iconColor;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String> onChanged;

  const _FormField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.iconColor,
    required this.controller,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.inputFormatters = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF666666),
          ),
        ),
        SizedBox(height: 6.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: TextStyle(fontSize: 14.sp, color: const Color(0xFF1A1A1A)),
            decoration: InputDecoration(
              prefixIcon: Container(
                margin: EdgeInsets.all(10.w),
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Icon(icon, size: 16.sp, color: iconColor),
              ),
              prefixIconConstraints: BoxConstraints(minWidth: 52.w),
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFFBBBBBB),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 16.h,
              ),
            ),
          ),
        ),
      ],
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
                isActive: true,
              ),
              _NavItem(
                icon: Icons.handshake_outlined,
                label: 'Lend/Borrow',
                isActive: false,
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
