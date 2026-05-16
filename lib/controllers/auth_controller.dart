import 'package:expenso/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  // --- Tab State ---
  final RxInt selectedTab = 0.obs; // 0 = Login, 1 = Register

  // --- Loading State ---
  final RxBool isLoading = false.obs;

  // --- Form Keys ---
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // --- Login Fields ---
  final loginEmail = TextEditingController();
  final loginPassword = TextEditingController();

  // --- Register Fields ---
  final registerName = TextEditingController();
  final registerPhone = TextEditingController();
  final registerEmail = TextEditingController();
  final registerPassword = TextEditingController();
  final registerConfirmPassword = TextEditingController();

  // --- Password Visibility ---
  final RxBool isLoginPasswordVisible = false.obs;
  final RxBool isRegisterPasswordVisible = false.obs;
  final RxBool isRegisterConfirmPasswordVisible = false.obs;

  void switchTab(int index) {
    if (selectedTab.value == index) return;
    selectedTab.value = index;
  }

  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordVisible.value = !isRegisterPasswordVisible.value;
  }

  void toggleRegisterConfirmPasswordVisibility() {
    isRegisterConfirmPasswordVisible.value =
        !isRegisterConfirmPasswordVisible.value;
  }

  Future<void> onLoginPressed() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final authResponse = await Supabase.instance.client.auth
          .signInWithPassword(
            email: loginEmail.text.trim(),
            password: loginPassword.text,
          );

      if (authResponse.user == null) {
        Get.snackbar(
          'Error',
          'Invalid email or password.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      Get.snackbar(
        'Success',
        'Welcome back!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => DashboardScreen());
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar(
        'Error',
        'Login failed. Please check your credentials.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> onRegisterPressed() async {
    if (!registerFormKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      // Register user with Supabase Auth
      final authResponse = await Supabase.instance.client.auth.signUp(
        email: registerEmail.text.trim(),
        password: registerPassword.text,
      );

      if (authResponse.user == null) {
        Get.snackbar(
          'Error',
          'Registration failed. Please try again.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Save additional user data in users table
      await Supabase.instance.client.from('users').insert({
        'name': registerName.text.trim(),
        'number': registerPhone.text.trim(),
        'email': registerEmail.text.trim(),
      });

      Get.snackbar(
        'Success',
        'Account created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAll(() => DashboardScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    loginEmail.dispose();
    loginPassword.dispose();
    registerName.dispose();
    registerPhone.dispose();
    registerEmail.dispose();
    registerPassword.dispose();
    registerConfirmPassword.dispose();
    super.onClose();
  }
}
