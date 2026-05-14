import 'package:get/get.dart';

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

  void onLogout() {
    // TODO: implement logout
  }
}
