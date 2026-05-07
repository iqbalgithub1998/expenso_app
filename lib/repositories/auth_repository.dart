import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();

  final GetStorage deviceStorage = GetStorage();

  @override
  void onReady() {
    initializeApp();
  }

  Future<void> initializeApp() async {
    // final String data = await AuthController.instance.initAuthUser();

    // if (data == "User") {
    //   Get.offAll(() => DashboardScreen());
    // } else {
    //   print("No User");

    //   Get.offAll(() => LoginScreen());
    // }
  }
}
