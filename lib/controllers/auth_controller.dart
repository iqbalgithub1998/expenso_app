import 'package:expenso/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  // --- Tab State ---
  final RxInt selectedTab = 0.obs; // 0 = Login, 1 = Register

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

  void onLoginPressed() {
    Get.to(() => DashboardScreen());
    // if (loginFormKey.currentState!.validate()) {
    //   // TODO: Implement Supabase login
    // }
  }

  void onRegisterPressed() {
    if (registerFormKey.currentState!.validate()) {
      // TODO: Implement Supabase registration
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
