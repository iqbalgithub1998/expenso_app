import 'package:expenso/controllers/auth_controller.dart';
import 'package:expenso/utils/validator/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ── Theme Constants ────────────────────────────────────────────────────────────

const _bg = Color(0xFF0D0F14);
const _surface = Color(0xFF151820);
const _surface2 = Color(0xFF1C1F28);
const _border = Color(0xFF252830);
const _textPrimary = Color(0xFFEEEFF4);
const _textSecondary = Color(0xFF6B7280);
const _textLight = Color(0xFF4B5563);
const _green = Color(0xFF2E9E5C);
const _greenDim = Color(0xFF1B7A47);
const _error = Color(0xFFEF4444);

// ── Screen ─────────────────────────────────────────────────────────────────────

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // ── Full-screen decorative glow ──
          Positioned(
            right: -100,
            top: -100,
            child: Container(
              width: 305.w,
              height: 305.w,
              decoration: BoxDecoration(
                color: _green.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _green.withValues(alpha: 0.25),
                    blurRadius: 90,
                    spreadRadius: 30,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: -100,
            bottom: -100,
            child: Container(
              width: 305.w,
              height: 305.w,
              decoration: BoxDecoration(
                color: _textPrimary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: _textPrimary.withValues(alpha: 0.20),
                    blurRadius: 80,
                    spreadRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                _buildAuthCard(controller),
                SizedBox(height: 24.h),
                _buildFeatureCard(
                  icon: Icons.shield_outlined,
                  iconColor: _green,
                  title: 'Bank-Grade Security',
                  subtitle: 'Your data is encrypted with 256-bit protocols.',
                  bgColor: _surface,
                  borderColor: _greenDim.withValues(alpha: 0.4),
                ),
                SizedBox(height: 12.h),
                _buildFeatureCard(
                  icon: Icons.auto_awesome,
                  iconColor: const Color(0xFFD4A74A),
                  title: 'Smart Insights',
                  subtitle: 'AI-driven trends for your monthly spending.',
                  bgColor: _surface,
                  borderColor: const Color(0xFFD4A74A).withValues(alpha: 0.2),
                ),
                SizedBox(height: 32.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text.rich(
                    TextSpan(
                      text: 'By continuing, you agree to our ',
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: _textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: _textPrimary,
                          ),
                        ),
                        const TextSpan(text: '\nand '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: _textPrimary,
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
        ],
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
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: _green.withValues(alpha: 0.30),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
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
              color: _textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Your financial vitality, visualized.',
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: _textSecondary,
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
        color: _surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: _border),
      ),
      child: Column(
        children: [
          _buildTabSwitcher(controller),
          SizedBox(height: 28.h),
          Obx(() {
            final isLogin = controller.selectedTab.value == 0;
            return ClipRect(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeInOutCubic,
                switchOutCurve: Curves.easeInOutCubic,
                transitionBuilder: (child, animation) {
                  final isLoginForm = child.key == const ValueKey('login');
                  final beginOffset = isLoginForm
                      ? const Offset(-1.0, 0.0)
                      : const Offset(1.0, 0.0);
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: beginOffset,
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutCubic,
                          ),
                        ),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      ...previousChildren.map(
                        (child) => Positioned.fill(child: child),
                      ),
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
  //  TAB SWITCHER
  // ═══════════════════════════════════════════════════════════
  Widget _buildTabSwitcher(AuthController controller) {
    return Obx(() {
      final isLogin = controller.selectedTab.value == 0;
      return Container(
        width: double.infinity,
        height: 48.h,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: _surface2,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: _border),
        ),
        child: Stack(
          children: [
            // Sliding active pill
            AnimatedAlign(
              alignment: isLogin ? Alignment.centerLeft : Alignment.centerRight,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: _green,
                    borderRadius: BorderRadius.circular(26.r),
                    boxShadow: [
                      BoxShadow(
                        color: _green.withValues(alpha: 0.30),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Labels
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
                          color: isLogin ? Colors.white : _textSecondary,
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
                          color: !isLogin ? Colors.white : _textSecondary,
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
            validator: Validators.email,
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
                    color: _green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Obx(
            () => _buildTextField(
              controller: controller.loginPassword,
              hint: '••••••••',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: !controller.isLoginPasswordVisible.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isLoginPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _textSecondary,
                  size: 20.sp,
                ),
                onPressed: controller.toggleLoginPasswordVisibility,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter password';
                return null;
              },
            ),
          ),
          SizedBox(height: 28.h),
          Obx(
            () => _buildPrimaryButton(
              label: controller.isLoading.value ? 'Logging in...' : 'Continue to Dashboard',
              onPressed: controller.isLoading.value ? () {} : controller.onLoginPressed,
              isLoading: controller.isLoading.value,
            ),
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
            validator: Validators.name,
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel('Phone Number'),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: controller.registerPhone,
            hint: '9876543210',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: Validators.phone,
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel('Email Address'),
          SizedBox(height: 8.h),
          _buildTextField(
            controller: controller.registerEmail,
            hint: 'name@example.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel('Password'),
          SizedBox(height: 8.h),
          Obx(
            () => _buildTextField(
              controller: controller.registerPassword,
              hint: '••••••••',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: !controller.isRegisterPasswordVisible.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isRegisterPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _textSecondary,
                  size: 20.sp,
                ),
                onPressed: controller.toggleRegisterPasswordVisibility,
              ),
              validator: Validators.password,
            ),
          ),
          SizedBox(height: 20.h),
          _buildFieldLabel('Confirm Password'),
          SizedBox(height: 8.h),
          Obx(
            () => _buildTextField(
              controller: controller.registerConfirmPassword,
              hint: '••••••••',
              prefixIcon: Icons.lock_outline_rounded,
              obscureText: !controller.isRegisterConfirmPasswordVisible.value,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isRegisterConfirmPasswordVisible.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: _textSecondary,
                  size: 20.sp,
                ),
                onPressed: controller.toggleRegisterConfirmPasswordVisibility,
              ),
              validator: (value) => Validators.confirmPassword(
                value,
                controller.registerPassword.text,
              ),
            ),
          ),
          SizedBox(height: 28.h),
          Obx(
            () => _buildPrimaryButton(
              label: controller.isLoading.value ? 'Creating...' : 'Create Account',
              onPressed: controller.isLoading.value ? () {} : controller.onRegisterPressed,
              isLoading: controller.isLoading.value,
            ),
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
        color: _textSecondary,
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      style: GoogleFonts.poppins(fontSize: 14.sp, color: _textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 14.sp, color: _textLight),
        prefixIcon: Icon(prefixIcon, color: _textSecondary, size: 20.sp),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: _surface2,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: _border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: _border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: _error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: _error, width: 1.5),
        ),
        errorStyle: GoogleFonts.poppins(fontSize: 11.sp, color: _error),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: isLoading ? () {} : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: _green.withValues(alpha: 0.30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24.w,
                height: 24.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
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
        Expanded(
          child: Divider(color: _border, thickness: 1.h),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'OR CONNECT WITH',
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: _textLight,
              letterSpacing: 1.0,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: _border, thickness: 1.h),
        ),
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
          side: BorderSide(color: _border, width: 1.2),
          backgroundColor: _surface2,
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
    required Color borderColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 24.sp),
          ),
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
                    color: _textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: _textSecondary,
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
