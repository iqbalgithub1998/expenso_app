import 'package:expenso/screens/auth/auth_screen.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final pushNotifications = true.obs;

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
  }

  void onEditAvatar() {
    // TODO: implement avatar editing
  }

  void onLanguageTap() {
    // TODO: implement language selection
  }

  void onCurrencyTap() {
    // TODO: implement currency selection
  }

  Future<void> onLogout() async {
    await Supabase.instance.client.auth.signOut();
    Get.offAll(() => const AuthScreen());
  }
}
