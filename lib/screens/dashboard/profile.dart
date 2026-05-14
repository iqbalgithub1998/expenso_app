import 'package:expenso/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// ── Theme Constants ────────────────────────────────────────────────────────────

const _bg = Color(0xFF0D0F14);
const _surface = Color(0xFF151820);
const _surface2 = Color(0xFF1C1F28);
const _border = Color(0xFF252830);
const _textPrimary = Color(0xFFEEEFF4);
const _textSecondary = Color(0xFF6B7280);
const _green = Color(0xFF2E9E5C);
const _greenDim = Color(0xFF1B7A47);

// ── Screen ─────────────────────────────────────────────────────────────────────

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: _bg,
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
                          color: _green,
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
                          color: _textPrimary,
                        ),
                      ),
                    ],
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
                        Container(
                          width: 120.w,
                          height: 120.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _green, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: _green.withValues(alpha: 0.20),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 112.w,
                          height: 112.w,
                          decoration: const BoxDecoration(
                            color: _surface2,
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Icon(
                              Icons.person,
                              size: 72.sp,
                              color: _textSecondary,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: controller.onEditAvatar,
                            child: Container(
                              width: 34.w,
                              height: 34.w,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [_greenDim, _green],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(color: _bg, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: _green.withValues(alpha: 0.35),
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
                        color: _textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Premium Member Since 2022',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: _textSecondary,
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
                          color: _textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    Container(
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: _border),
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
                                  bg: _surface2,
                                  color: _textSecondary,
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
                                          color: _textPrimary,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Alerts for unusual spending',
                                        style: TextStyle(
                                          fontSize: 11.sp,
                                          color: _textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => Switch(
                                    value: controller.pushNotifications.value,
                                    onChanged:
                                        controller.togglePushNotifications,
                                    activeThumbColor: Colors.white,
                                    activeTrackColor: _green,
                                    inactiveThumbColor: _textSecondary,
                                    inactiveTrackColor: _surface2,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          _Divider(),

                          _PrefRow(
                            icon: Icons.language_outlined,
                            iconBg: _surface2,
                            iconColor: _textSecondary,
                            title: 'Language',
                            subtitle: 'English (US)',
                            onTap: controller.onLanguageTap,
                          ),

                          _Divider(),

                          _PrefRow(
                            icon: Icons.monetization_on_outlined,
                            iconBg: _surface2,
                            iconColor: _textSecondary,
                            title: 'Currency',
                            subtitle: 'USD (\$)',
                            onTap: controller.onCurrencyTap,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // ── Logout Button ──────────────────────────────────
                    GestureDetector(
                      onTap: controller.onLogout,
                      child: Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: _surface,
                          borderRadius: BorderRadius.circular(30.r),
                          border: Border.all(
                            color: const Color(0xFFE53935),
                            width: 1.5,
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
                      'APP VERSION 4.8.2 (2026)',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: _textSecondary,
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
        border: Border.all(color: _border),
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
                      color: _textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.sp, color: _textSecondary),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 20.sp, color: _border),
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
      child: Container(height: 1, color: _border),
    );
  }
}
