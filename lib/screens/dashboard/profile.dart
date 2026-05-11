import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;

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
                  children: [
                    SizedBox(height: 16.h),

                    // ── Avatar ─────────────────────────────────────────
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // Outer glow ring
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF2E9E5C),
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF2E9E5C,
                                ).withValues(alpha: 0.25),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        // Avatar container
                        Container(
                          width: 112.w,
                          height: 112.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5DEB3),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Icon(
                              Icons.person,
                              size: 72.sp,
                              color: const Color(0xFFD4A574),
                            ),
                          ),
                        ),
                        // Edit badge
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 34.w,
                              height: 34.w,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF7C3AED),
                                    Color(0xFFAB65F5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF2F4F8),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF7C3AED,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.edit,
                                size: 15.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // ── Name & Badge ───────────────────────────────────
                    Text(
                      'Alex Sterling',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1A1A1A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Premium Member Since 2022',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: const Color(0xFF888888),
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // ── Preferences ────────────────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Preferences',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Preferences card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Push Notifications
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 14.h,
                            ),
                            child: Row(
                              children: [
                                _PrefIcon(
                                  icon: Icons.notifications_active_outlined,
                                  bg: const Color(0xFFE8E8EE),
                                  color: const Color(0xFF555566),
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Push Notifications',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Alerts for unusual spending',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: const Color(0xFF999999),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: _pushNotifications,
                                  onChanged: (v) =>
                                      setState(() => _pushNotifications = v),
                                  activeThumbColor: Colors.white,
                                  activeTrackColor: const Color(0xFF2E9E5C),
                                  inactiveThumbColor: Colors.white,
                                  inactiveTrackColor: const Color(0xFFCCCCCC),
                                ),
                              ],
                            ),
                          ),

                          _Divider(),

                          // Language
                          _PrefRow(
                            icon: Icons.language_outlined,
                            iconBg: const Color(0xFFE8E8EE),
                            iconColor: const Color(0xFF555566),
                            title: 'Language',
                            subtitle: 'English (US)',
                            onTap: () {},
                          ),

                          _Divider(),

                          // Currency
                          _PrefRow(
                            icon: Icons.monetization_on_outlined,
                            iconBg: const Color(0xFFE8E8EE),
                            iconColor: const Color(0xFF555566),
                            title: 'Currency',
                            subtitle: 'USD (\$)',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // ── Logout Button ──────────────────────────────────
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: const Color(0xFFE53935),
                            width: 1.5,
                            style: BorderStyle.solid,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFFE53935,
                              ).withValues(alpha: 0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              size: 20.sp,
                              color: const Color(0xFFE53935),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              'Logout from Expenso',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFE53935),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // ── Version ────────────────────────────────────────
                    Text(
                      'APP VERSION 4.8.2 (2024)',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFFBBBBBB),
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 24.h),
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

// ── Preference Icon ────────────────────────────────────────────────────────────

class _PrefIcon extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color color;

  const _PrefIcon({required this.icon, required this.bg, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(icon, size: 20.sp, color: color),
    );
  }
}

// ── Preference Row ─────────────────────────────────────────────────────────────

class _PrefRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _PrefRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            _PrefIcon(icon: icon, bg: iconBg, color: iconColor),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20.sp,
              color: const Color(0xFFCCCCCC),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Divider ────────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(height: 1, color: const Color(0xFFF0F0F0)),
    );
  }
}

