import 'package:expenso/controllers/auth_controller.dart';
import 'package:expenso/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FE),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(),
            _buildAuthCard(controller),
            SizedBox(height: 24.h),
            _buildFeatureCard(
              icon: Icons.shield_outlined,
              iconColor: const Color(0xFF2E7D5B),
              title: 'Bank-Grade Security',
              subtitle: 'Your data is encrypted with 256-bit protocols.',
              bgColor: const Color(0xFFE8F5E9),
            ),
            SizedBox(height: 12.h),
            _buildFeatureCard(
              icon: Icons.auto_awesome,
              iconColor: const Color(0xFFB8860B),
              title: 'Smart Insights',
              subtitle: 'AI-driven trends for your monthly spending.',
              bgColor: const Color(0xFFFFF3E0),
            ),
            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text.rich(
                TextSpan(
                  text: 'By continuing, you agree to our ',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: TColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: TColors.textPrimary,
                      ),
                    ),
                    const TextSpan(text: '\nand '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: TColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  HEADER
  // ═══════════════════════════════════════════════════════════
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 70.h, bottom: 40.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE8F5E9).withValues(alpha: 0.6),
            const Color(0xFFF6F8FE),
            const Color(0xFFE8EAF6).withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D5B),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Expenso',
            style: GoogleFonts.poppins(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: TColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Your financial vitality, visualized.',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: TColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  AUTH CARD
  // ═══════════════════════════════════════════════════════════
  Widget _buildAuthCard(AuthController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Full-width sliding pill tab ──
          _buildTabSwitcher(controller),

          SizedBox(height: 28.h),

          // ── Animated form switcher (content-sized, no overflow) ──
          Obx(() {
            final isLogin = controller.selectedTab.value == 0;
            return ClipRect(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                // Custom slide direction: login slides from left, register from right
                transitionBuilder: (child, animation) {
                  final isLoginForm =
                      child.key == const ValueKey('login');
                  final beginOffset = isLoginForm
                      ? const Offset(-1.0, 0.0)
                      : const Offset(1.0, 0.0);
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: beginOffset,
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeInOutCubic,
                    )),
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  );
                },
                // Custom layout: size to current child only (no Stack max-height)
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // Previous form slides out underneath
                      ...previousChildren.map(
                        (child) => Positioned.fill(child: child),
                      ),
                      // Current form dictates the height
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
                child: isLogin
                    ? _buildLoginForm(controller)
                    : _buildRegisterForm(controller),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  FULL-WIDTH SLIDING PILL TAB SWITCHER
  // ═══════════════════════════════════════════════════════════
  Widget _buildTabSwitcher(AuthController controller) {
    return Obx(() {
      final isLogin = controller.selectedTab.value == 0;
      return Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F7),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Stack(
          children: [
            // Sliding white pill
            AnimatedAlign(
              alignment:
                  isLogin ? Alignment.centerLeft : Alignment.centerRight,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(26.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Labels on top of pill
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.switchTab(0),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: isLogin
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isLogin
                              ? TColors.textPrimary
                              : TColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.switchTab(1),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Text(
                        'Register',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: !isLogin
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: !isLogin
                              ? TColors.textPrimary
                              : TColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  // ═══════════════════════════════════════════════════════════
  //  LOGIN FORM
  // ═══════════════════════════════════════════════════════════
  Widget _buildLoginForm(AuthController controller) {
    return Form(
      key: controller.loginFormKey,
      child: Column(
        key: const ValueKey('login'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Email Address'),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: controller.loginEmail,
            hint: 'name@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your email';
              if (!GetUtils.isEmail(v)) return 'Enter a valid email';
              return null;
            },
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildFieldLabel('Password'),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Forgot?',
                  style: GoogleFonts.poppins(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2E7D5B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(() => _buildTextField(
                controller: controller.loginPassword,
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: !controller.isLoginPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isLoginPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: TColors.textSecondary,
                    size: 20.sp,
                  ),
                  onPressed: controller.toggleLoginPasswordVisibility,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter password';
                  return null;
                },
              )),
          SizedBox(height: 28.h),
          _buildPrimaryButton(
            label: 'Continue to Dashboard',
            onPressed: controller.onLoginPressed,
          ),
          SizedBox(height: 24.h),
          _buildOrDivider(),
          SizedBox(height: 16.h),
          _buildGoogleButton(),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  REGISTER FORM
  // ═══════════════════════════════════════════════════════════
  Widget _buildRegisterForm(AuthController controller) {
    return Form(
      key: controller.registerFormKey,
      child: Column(
        key: const ValueKey('register'),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel('Full Name'),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: controller.registerName,
            hint: 'John Doe',
            prefixIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your name';
              if (v.length < 2) return 'Min 2 characters';
              return null;
            },
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel('Phone Number'),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: controller.registerPhone,
            hint: '9876543210',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter phone number';
              if (!GetUtils.isPhoneNumber(v)) return 'Enter a valid number';
              return null;
            },
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel('Email Address'),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: controller.registerEmail,
            hint: 'name@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Please enter your email';
              if (!GetUtils.isEmail(v)) return 'Enter a valid email';
              return null;
            },
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel('Password'),
          SizedBox(height: 8.h),
          Obx(() => _buildTextField(
                controller: controller.registerPassword,
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: !controller.isRegisterPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isRegisterPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: TColors.textSecondary,
                    size: 20.sp,
                  ),
                  onPressed: controller.toggleRegisterPasswordVisibility,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter password';
                  if (v.length < 6) return 'Min 6 characters';
                  return null;
                },
              )),
          SizedBox(height: 20.h),
          _buildFieldLabel('Confirm Password'),
          SizedBox(height: 8.h),
          Obx(() => _buildTextField(
                controller: controller.registerConfirmPassword,
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText:
                    !controller.isRegisterConfirmPasswordVisible.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isRegisterConfirmPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: TColors.textSecondary,
                    size: 20.sp,
                  ),
                  onPressed:
                      controller.toggleRegisterConfirmPasswordVisibility,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please confirm password';
                  if (v != controller.registerPassword.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              )),
          SizedBox(height: 28.h),
          _buildPrimaryButton(
            label: 'Create Account',
            onPressed: controller.onRegisterPressed,
          ),
          SizedBox(height: 24.h),
          _buildOrDivider(),
          SizedBox(height: 16.h),
          _buildGoogleButton(),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════
  //  SHARED HELPERS
  // ═══════════════════════════════════════════════════════════

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: TColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 14.sp, color: TColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14.sp,
          color: TColors.textLight,
        ),
        prefixIcon: Icon(prefixIcon, color: TColors.textSecondary, size: 20.sp),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF5F6FA),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFF2E7D5B), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: TColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: TColors.error, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2E7D5B),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: TColors.grey, thickness: 1.h)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'OR CONNECT WITH',
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: TColors.textLight,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Expanded(child: Divider(color: TColors.grey, thickness: 1.h)),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide(color: TColors.grey, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Text(
          'G',
          style: GoogleFonts.poppins(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF4285F4),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Color bgColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 28.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: TColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: TColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
