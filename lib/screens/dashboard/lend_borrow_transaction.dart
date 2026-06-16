import 'dart:ui';
import 'package:expenso/models/friend.dart';
import 'package:expenso/screens/dashboard/record_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:expenso/controllers/lend_borrow_controller.dart';
import 'package:intl/intl.dart';

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
  final DateTime whenDate;
  final DateTime? returnDate;

  const TxMessage({
    required this.amount,
    required this.note,
    required this.time,
    required this.type,
    required this.whenDate,
    this.returnDate,
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
  final Friends contact;

  const LendBorrowTransaction({super.key, required this.contact});

  static const _bg = Color(0xFF0D0F14);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LendBorrowController>();

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Obx(() {
          final currentFriend = controller.displayedFriends.firstWhere(
            (f) => f.id == contact.id,
            orElse: () => contact,
          );

          return Column(
            children: [
              // ── Header ───────────────────────────────────────────────────
              _Header(friend: currentFriend),

              // ── Chat list ────────────────────────────────────────────────
              Expanded(
                child: controller.isLoadingTransactions.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF00E676)),
                        ),
                      )
                    : controller.friendTxDays.isEmpty
                    ? Center(
                        child: Text(
                          'No transactions recorded yet.',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF4B5563),
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ).copyWith(top: 8.h, bottom: 100.h),
                        itemCount: controller.friendTxDays.length,
                        itemBuilder: (_, di) {
                          final day = controller.friendTxDays[di];
                          return Column(
                            children: [
                              _DateChip(label: day.dateLabel),
                              SizedBox(height: 12.h),
                              ...day.messages.map((msg) {
                                if (msg.type == TxType.settled) {
                                  return _SettledBanner(msg: msg, context: context);
                                }
                                return GestureDetector(
                                  onTap: () => _showTxDetailModal(context, msg),
                                  child: Container(
                                    width: double.infinity,
                                    alignment: msg.isMine
                                        ? Alignment.centerRight
                                        : null,
                                    child: msg.isMine
                                        ? _SentBubble(msg: msg)
                                        : _ReceivedBubble(msg: msg),
                                  ),
                                );
                              }),
                              SizedBox(height: 8.h),
                            ],
                          );
                        },
                      ),
              ),
            ],
          );
        }),
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
  final Friends friend;

  const _Header({required this.friend});

  @override
  Widget build(BuildContext context) {
    final badgeColor = Color(friend.badgeColorValue);

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

          // Name + subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.name,
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
                        text: friend.closingBalance > 0
                            ? 'You lent'
                            : 'You borrow',
                        style: const TextStyle(color: Color(0xFF6B7280)),
                      ),
                      TextSpan(
                        text: friend.amountLabel,
                        style: TextStyle(
                          color: Color(friend.amountColorValue),
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
// Settled banner  (centre-aligned card — tappable for details)
// ─────────────────────────────────────────────────────────────────────────────
class _SettledBanner extends StatelessWidget {
  final TxMessage msg;
  final BuildContext context;

  const _SettledBanner({required this.msg, required this.context});

  @override
  Widget build(BuildContext ctx) {
    const teal = Color(0xFF00D4AA);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Center(
        child: GestureDetector(
          onTap: () => _showTxDetailModal(context, msg),
          child: Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(ctx).size.width * 0.78),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 13.h),
            decoration: BoxDecoration(
              color: const Color(0xFF0E1A16),
              borderRadius: BorderRadius.circular(22.r),
              border: Border.all(
                color: teal.withValues(alpha: 0.28),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: teal.withValues(alpha: 0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon container
                Container(
                  width: 34.w,
                  height: 34.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00A37A), teal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: teal.withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12.w),
                // Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Settled',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: teal.withValues(alpha: 0.75),
                        letterSpacing: 0.8,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      msg.amount,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (msg.note.isNotEmpty) ...[
                      SizedBox(height: 1.h),
                      Text(
                        msg.note,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white.withValues(alpha: 0.50),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(width: 12.w),
                // Tap hint
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18.sp,
                  color: teal.withValues(alpha: 0.50),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Transaction Detail Modal
// ─────────────────────────────────────────────────────────────────────────────
void _showTxDetailModal(BuildContext context, TxMessage msg) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Transaction Detail',
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
    transitionBuilder: (ctx, anim, secAnim, child) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: _TxDetailOverlay(msg: msg, animation: curved),
      );
    },
  );
}

class _TxDetailOverlay extends StatelessWidget {
  final TxMessage msg;
  final Animation<double> animation;

  const _TxDetailOverlay({required this.msg, required this.animation});

  @override
  Widget build(BuildContext context) {
    final isSettled = msg.type == TxType.settled;
    final isLent = msg.type == TxType.lent;

    final primaryColor = isSettled
        ? const Color(0xFF00D4AA)
        : isLent
            ? const Color(0xFF00E676)
            : const Color(0xFFFF6666);

    final gradientColors = isSettled
        ? [
            const Color(0xFF004D38),
            const Color(0xFF007A5E),
            const Color(0xFF00D4AA),
          ]
        : isLent
            ? [
                const Color(0xFF00603A),
                const Color(0xFF00A854),
                const Color(0xFF00E676),
              ]
            : [
                const Color(0xFFB40000),
                const Color(0xFFF22323),
                const Color(0xFFFF6666),
              ];

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Blurred backdrop
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  color: const Color(0xFF0D0F14).withValues(alpha: 0.72),
                ),
              ),
            ),
            // Card
            Center(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.12),
                  end: Offset.zero,
                ).animate(animation),
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutBack,
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {}, // prevent dismiss on card tap
                    child: _TxDetailCard(
                      msg: msg,
                      primaryColor: primaryColor,
                      gradientColors: gradientColors,
                      isLent: isLent,
                      isSettled: isSettled,
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
}

class _TxDetailCard extends StatelessWidget {
  final TxMessage msg;
  final Color primaryColor;
  final List<Color> gradientColors;
  final bool isLent;
  final bool isSettled;

  const _TxDetailCard({
    required this.msg,
    required this.primaryColor,
    required this.gradientColors,
    required this.isLent,
    this.isSettled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141720),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.18),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.18),
            blurRadius: 48,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.60),
            blurRadius: 32,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Gradient Header ─────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28.r),
                topRight: Radius.circular(28.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSettled
                            ? Icons.check_circle_rounded
                            : isLent
                                ? Icons.arrow_upward_rounded
                                : Icons.arrow_downward_rounded,
                        size: 12.sp,
                        color: Colors.white,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        isSettled ? 'SETTLED' : isLent ? 'LENT' : 'BORROWED',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
                // Amount
                Text(
                  msg.amount,
                  style: TextStyle(
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1.5,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                if (msg.note.isNotEmpty) ...[
                  SizedBox(height: 6.h),
                  Text(
                    msg.note,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white.withValues(alpha: 0.80),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Details body ─────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ).copyWith(top: 22.h, bottom: 8.h),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Transaction Date',
                  value: DateFormat('EEE, dd MMM yyyy').format(msg.whenDate),
                  iconColor: primaryColor,
                ),
                _DetailDivider(),
                _DetailRow(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: msg.time,
                  iconColor: primaryColor,
                ),
                if (msg.returnDate != null) ...[
                  _DetailDivider(),
                  _DetailRow(
                    icon: Icons.event_available_rounded,
                    label: 'Expected Return',
                    value: DateFormat(
                      'EEE, dd MMM yyyy',
                    ).format(msg.returnDate!),
                    iconColor: primaryColor,
                    highlight: true,
                    highlightColor: primaryColor,
                  ),
                ],
                _DetailDivider(),
                _DetailRow(
                  icon: msg.isRead
                      ? Icons.done_all_rounded
                      : Icons.access_time_rounded,
                  label: 'Status',
                  value: msg.isRead ? 'Confirmed' : 'Pending',
                  iconColor: msg.isRead
                      ? const Color(0xFF00E676)
                      : const Color(0xFFFFB74D),
                  valueColor: msg.isRead
                      ? const Color(0xFF00E676)
                      : const Color(0xFFFFB74D),
                ),
              ],
            ),
          ),

          // ── Close button ─────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
            ).copyWith(bottom: 24.h, top: 16.h),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1D26),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF9CA3AF),
                    ),
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final bool highlight;
  final Color? highlightColor;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
    this.highlight = false,
    this.highlightColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 16.sp, color: iconColor),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: const Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (highlight && highlightColor != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: highlightColor!.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: highlightColor!.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                'Due',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: highlightColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white.withValues(alpha: 0.05),
      thickness: 1,
      height: 1,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// New Transaction FAB + Bottom Sheet
// ─────────────────────────────────────────────────────────────────────────────
class _NewTxFab extends StatelessWidget {
  final Friends contact;

  const _NewTxFab({required this.contact});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => RecordTransactionScreen(friendId: contact.id)),
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
