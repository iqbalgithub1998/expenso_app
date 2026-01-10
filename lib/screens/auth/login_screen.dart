// import 'package:expenso/controllers/auth_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../core/theme/app_colors.dart';
// import 'signup_screen.dart';

// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});

//   final emailCtrl = TextEditingController();
//   final passwordCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 60),

//               // 👋 Title
//               Text(
//                 "Welcome Back 👋",
//                 style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.textDark,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 "Track your expenses & money easily",
//                 style: TextStyle(color: AppColors.textLight),
//               ),

//               const SizedBox(height: 40),

//               // 📦 Card
//               Container(
//                 padding: const EdgeInsets.all(24),
//                 decoration: BoxDecoration(
//                   color: AppColors.card,
//                   borderRadius: BorderRadius.circular(24),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.05),
//                       blurRadius: 20,
//                       offset: const Offset(0, 10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     _inputField(
//                       label: "Email",
//                       controller: emailCtrl,
//                       icon: Icons.email_outlined,
//                     ),
//                     const SizedBox(height: 20),
//                     _inputField(
//                       label: "Password",
//                       controller: passwordCtrl,
//                       icon: Icons.lock_outline,
//                       isPassword: true,
//                     ),
//                     const SizedBox(height: 30),

//                     // 🔵 Login Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 54,
//                       child: Obx(
//                         () => ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primary,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                           ),
//                           onPressed: () {
//                             if (AuthController.instance.isLoading.value) {
//                               return;
//                             }
//                             AuthController.instance.login(
//                               emailCtrl.text.trim(),
//                               passwordCtrl.text.trim(),
//                             );
//                             // AuthController.instance.verify();
//                           },
//                           child: AuthController.instance.isLoading.value
//                               ? SizedBox(
//                                   height: 15,
//                                   width: 15,
//                                   child: const CircularProgressIndicator(
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               : const Text(
//                                   "Login",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 30),

//               // 🔗 Signup Link
//               Center(
//                 child: GestureDetector(
//                   onTap: () => Get.to(() => SignupScreen()),
//                   child: RichText(
//                     text: const TextSpan(
//                       text: "Don't have an account? ",
//                       style: TextStyle(color: AppColors.textLight),
//                       children: [
//                         TextSpan(
//                           text: "Sign Up",
//                           style: TextStyle(
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _inputField({
//     required String label,
//     required TextEditingController controller,
//     required IconData icon,
//     bool isPassword = false,
//   }) {
//     return TextField(
//       controller: controller,
//       obscureText: isPassword,
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon),
//         filled: true,
//         fillColor: AppColors.background,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(16),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }
// }

import 'package:expenso/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // Logo/Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 👋 Title
              Center(
                child: Column(
                  children: [
                    Text(
                      "Welcome Back!",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Sign in to continue managing your expenses",
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 📧 Email Field
              const Text(
                "Email",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              _inputField(
                controller: emailCtrl,
                hint: "Enter your email",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // 🔒 Password Field
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => _inputField(
                  controller: passwordCtrl,
                  hint: "Enter your password",
                  icon: Icons.lock_outline,
                  isPassword: !isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textLight,
                    ),
                    onPressed: () =>
                        isPasswordVisible.value = !isPasswordVisible.value,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                    Get.snackbar(
                      'Info',
                      'Forgot password feature coming soon',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 🔵 Login Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                    ),
                    onPressed: AuthController.instance.isLoading.value
                        ? null
                        : () {
                            if (emailCtrl.text.trim().isEmpty ||
                                passwordCtrl.text.trim().isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Please fill in all fields',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.red.shade900,
                              );
                              return;
                            }
                            AuthController.instance.login(
                              emailCtrl.text.trim(),
                              passwordCtrl.text.trim(),
                            );
                          },
                    child: AuthController.instance.isLoading.value
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // // Divider with "OR"
              // Row(
              //   children: [
              //     Expanded(
              //       child: Divider(color: Colors.grey.shade300, thickness: 1),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 16),
              //       child: Text(
              //         "OR",
              //         style: TextStyle(
              //           color: AppColors.textLight,
              //           fontWeight: FontWeight.w500,
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //       child: Divider(color: Colors.grey.shade300, thickness: 1),
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 30),

              // // Social Login Buttons (Optional)
              // Row(
              //   children: [
              //     Expanded(
              //       child: _socialButton(
              //         icon: Icons.g_mobiledata,
              //         label: "Google",
              //         onTap: () {
              //           Get.snackbar(
              //             'Info',
              //             'Google sign-in coming soon',
              //             snackPosition: SnackPosition.BOTTOM,
              //           );
              //         },
              //       ),
              //     ),
              //     const SizedBox(width: 16),
              //     Expanded(
              //       child: _socialButton(
              //         icon: Icons.apple,
              //         label: "Apple",
              //         onTap: () {
              //           Get.snackbar(
              //             'Info',
              //             'Apple sign-in coming soon',
              //             snackPosition: SnackPosition.BOTTOM,
              //           );
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 40),

              // 🔗 Signup Link
              Center(
                child: GestureDetector(
                  onTap: () => Get.to(() => SignupScreen()),
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.textLight.withOpacity(0.6),
          fontWeight: FontWeight.normal,
        ),
        prefixIcon: Icon(icon, color: AppColors.textLight, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
      ),
    );
  }

  Widget _socialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: AppColors.textDark),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
