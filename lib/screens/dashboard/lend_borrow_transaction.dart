import 'package:expenso/controllers/lend_borrow_controller.dart';
import 'package:expenso/screens/dashboard/record_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────
enum TxType { lent, borrowed, settled }

class TxMessage {
  final String amount;
  final String note;
  final String time;
  final TxType type;
  final bool isRead; // true = double tick, false = single tick

  const TxMessage({
    required this.amount,
    required this.note,
    required this.time,
    required this.type,
    this.isRead = true,
  });

  bool get isMine => type == TxType.lent; // lent = sent bubble (right)
}

class TxDay {
  final String dateLabel;
  final List<TxMessage> messages;

  const TxDay({required this.dateLabel, required this.messages});
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────
class LendBorrowTransaction extends StatelessWidget {
  final ContactData contact;

  const LendBorrowTransaction({super.key, required this.contact});

  static const _bg = Color(0xFF0D0F14);

  // Demo data — in production inject via controller
  static const _days = [
    TxDay(
      dateLabel: 'MONDAY, OCT 24',
      messages: [
        TxMessage(
          amount: '\$45.00',
          note: 'Lunch at Olive Garden',
          time: '12:45 PM',
          type: TxType.borrowed,
        ),
        TxMessage(
          amount: '\$120.00',
          note: 'Concert Tickets Pre-sale',
          time: '02:15 PM',
          type: TxType.lent,
        ),
      ],
    ),
    TxDay(
      dateLabel: 'YESTERDAY',
      messages: [
        TxMessage(amount: '\$45.00', note: '', time: '', type: TxType.settled),
        TxMessage(
          amount: '\$65.00',
          note: 'Grocery split - Whole Foods',
          time: '06:30 PM',
          type: TxType.lent,
        ),
        TxMessage(
          amount: '\$20.00',
          note: 'Uber to Airport',
          time: '09:12 PM',
          type: TxType.lent,
          isRead: false,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────
            _Header(contact: contact),

            // ── Chat list ────────────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ).copyWith(top: 8.h, bottom: 100.h),
                itemCount: _days.length,
                itemBuilder: (_, di) {
                  final day = _days[di];
                  return Column(
                    children: [
                      _DateChip(label: day.dateLabel),
                      SizedBox(height: 12.h),
                      ...day.messages.map((msg) {
                        if (msg.type == TxType.settled) {
                          return _SettledBanner(amount: msg.amount);
                        }
                        return Container(
                          width: double.infinity,
                          alignment: msg.isMine ? Alignment.centerRight : null,
                          child: msg.isMine
                              ? _SentBubble(msg: msg)
                              : _ReceivedBubble(msg: msg),
                        );
                      }),
                      SizedBox(height: 8.h),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ── New Transaction FAB ──────────────────────────────────────────────
      floatingActionButton: _NewTxFab(contact: contact),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final ContactData contact;

  const _Header({required this.contact});

  @override
  Widget build(BuildContext context) {
    final badgeColor = Color(contact.badgeColorValue);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ).copyWith(top: 12.h, bottom: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.06)),
        ),
      ),
      child: Row(
        children: [
          // Back
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1D26),
                borderRadius: BorderRadius.circular(11.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 15.sp,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Avatar
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(contact.badgeBgValue),
              border: Border.all(
                color: badgeColor.withValues(alpha: 0.35),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                contact.initials,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                  color: badgeColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          SizedBox(width: 10.w),

          // Name + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2.h),
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 11.sp),
                    children: [
                      TextSpan(
                        text: contact.amount >= 0 ? 'You lent ' : 'You owe ',
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      ),
                      TextSpan(
                        text: contact.amountLabel,
                        style: TextStyle(
                          color: Color(contact.amountColorValue),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // More
          Container(
            width: 38.w,
            height: 38.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1D26),
              borderRadius: BorderRadius.circular(11.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Icon(
              Icons.more_vert_rounded,
              size: 18.sp,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Date chip
// ─────────────────────────────────────────────────────────────────────────────
class _DateChip extends StatelessWidget {
  final String label;

  const _DateChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1D26),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF6B7280),
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sent bubble  (lent — right aligned, green gradient)
// ─────────────────────────────────────────────────────────────────────────────
class _SentBubble extends StatelessWidget {
  final TxMessage msg;

  const _SentBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF00603A),
                  Color(0xFF00A854),
                  Color(0xFF00E676),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.55, 1.0],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
                bottomRight: Radius.circular(5.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00C853).withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  msg.amount,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                if (msg.note.isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  Text(
                    msg.note,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Lent',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF00E676),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                msg.time,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF4B5563),
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                msg.isRead ? Icons.done_all_rounded : Icons.access_time_rounded,
                size: 13.sp,
                color: msg.isRead
                    ? const Color(0xFF00E676)
                    : const Color(0xFF4B5563),
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Received bubble  (borrowed — left aligned, purple tint)
// ─────────────────────────────────────────────────────────────────────────────
class _ReceivedBubble extends StatelessWidget {
  final TxMessage msg;

  const _ReceivedBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 180, 0, 0),
                  Color.fromARGB(255, 242, 35, 35),
                  Color.fromARGB(255, 255, 102, 102),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.0, 0.55, 1.0],
              ),
              border: Border.all(
                color: const Color.fromARGB(
                  255,
                  255,
                  72,
                  72,
                ).withValues(alpha: 0.20),
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(5.r),
                bottomRight: Radius.circular(20.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg.amount,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                if (msg.note.isNotEmpty) ...[
                  SizedBox(height: 3.h),
                  Text(
                    msg.note,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg.time,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF4B5563),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                'Borrowed',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color.fromARGB(255, 252, 134, 134),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Settled banner
// ─────────────────────────────────────────────────────────────────────────────
class _SettledBanner extends StatelessWidget {
  final String amount;

  const _SettledBanner({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.white.withValues(alpha: 0.06),
              thickness: 1,
            ),
          ),
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1E14),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFF00E676).withValues(alpha: 0.20),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 14.sp,
                  color: const Color(0xFF00E676),
                ),
                SizedBox(width: 6.w),
                Text(
                  'You settled $amount',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF00E676),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Divider(
              color: Colors.white.withValues(alpha: 0.06),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// New Transaction FAB + Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _NewTxFab extends StatelessWidget {
  final ContactData contact;

  const _NewTxFab({required this.contact});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => RecordTransactionScreen()),
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 22.w),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00A854), Color(0xFF00E676)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C853).withValues(alpha: 0.40),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 20.sp, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              'New Transaction',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// New Transaction Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
void _showNewTxSheet(BuildContext context, ContactData contact) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _NewTxSheet(contact: contact),
  );
}

class _NewTxSheet extends StatefulWidget {
  final ContactData contact;

  const _NewTxSheet({required this.contact});

  @override
  State<_NewTxSheet> createState() => _NewTxSheetState();
}

class _NewTxSheetState extends State<_NewTxSheet> {
  TxType _selected = TxType.lent;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_amountCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() => _loading = false);
    if (mounted) Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isLent = _selected == TxType.lent;
    final accentColor = isLent
        ? const Color(0xFF00E676)
        : const Color.fromARGB(255, 252, 134, 134);

    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 20.h,
        bottom: 28.h + bottomInset,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 40,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),

          SizedBox(height: 22.h),

          // Title
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C853), Color(0xFF00E676)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00E676).withValues(alpha: 0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.handshake_outlined,
                  size: 18.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Transaction',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.4,
                    ),
                  ),
                  Text(
                    'with ${widget.contact.name}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Lent / Borrowed toggle
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: const Color(0xFF0D0F14),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
            ),
            child: Row(
              children: [
                _ToggleBtn(
                  label: 'Lent',
                  icon: Icons.arrow_upward_rounded,
                  isActive: _selected == TxType.lent,
                  activeColor: const Color(0xFF00E676),
                  activeBg: const Color(0xFF0D1E14),
                  onTap: () => setState(() => _selected = TxType.lent),
                ),
                SizedBox(width: 4.w),
                _ToggleBtn(
                  label: 'Borrowed',
                  icon: Icons.arrow_downward_rounded,
                  isActive: _selected == TxType.borrowed,
                  activeColor: const Color.fromARGB(255, 252, 134, 134),
                  activeBg: const Color(0xFF18102A),
                  onTap: () => setState(() => _selected = TxType.borrowed),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Amount field
          _DarkField(
            controller: _amountCtrl,
            label: 'Amount',
            hint: '0.00',
            icon: Icons.attach_money_rounded,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            accentColor: accentColor,
          ),

          SizedBox(height: 14.h),

          // Note field
          _DarkField(
            controller: _noteCtrl,
            label: 'Note',
            hint: 'What was this for?',
            icon: Icons.notes_rounded,
            accentColor: accentColor,
          ),

          SizedBox(height: 28.h),

          // Submit
          GestureDetector(
            onTap: _loading ? null : _submit,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 54.h,
              decoration: BoxDecoration(
                gradient: isLent
                    ? const LinearGradient(
                        colors: [Color(0xFF00A854), Color(0xFF00E676)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 182, 33, 33),
                          Color.fromARGB(255, 252, 134, 134),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.32),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: _loading
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        isLent ? 'Record Lent' : 'Record Borrowed',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Toggle button
// ─────────────────────────────────────────────────────────────────────────────
class _ToggleBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final Color activeColor;
  final Color activeBg;
  final VoidCallback onTap;

  const _ToggleBtn({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.activeColor,
    required this.activeBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 11.h),
          decoration: BoxDecoration(
            color: isActive ? activeBg : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            border: isActive
                ? Border.all(color: activeColor.withValues(alpha: 0.25))
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14.sp,
                color: isActive ? activeColor : const Color(0xFF4B5563),
              ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: isActive ? activeColor : const Color(0xFF4B5563),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Dark text field
// ─────────────────────────────────────────────────────────────────────────────
class _DarkField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final Color accentColor;

  const _DarkField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.accentColor,
    this.keyboardType,
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
            color: const Color(0xFF9CA3AF),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D0F14),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF4B5563),
              ),
              prefixIcon: Icon(
                icon,
                size: 18.sp,
                color: const Color(0xFF6B7280),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 14.h),
            ),
          ),
        ),
      ],
    );
  }
}
