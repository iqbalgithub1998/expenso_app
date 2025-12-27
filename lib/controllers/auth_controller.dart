import 'dart:developer';

import 'package:expenso/models/user_model.dart';
import 'package:expenso/screens/auth/login_screen.dart';
import 'package:expenso/screens/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../services/auth_api.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final api = AuthApi();
  final storage = GetStorage();
  final Rx<String?> token = Rx<String?>(null);
  User? authUser;
  final RxBool isLoading = false.obs;

  Future login(String email, String password) async {
    isLoading.value = true;
    final res = await api.login(email, password);
    isLoading.value = false;
    storage.write("ExpensoAuthToken", res["token"]);
    token.value = res["token"];
    authUser = User.fromJson(res["user"]);
    // log(res.toString());
    Get.offAll(() => DashboardScreen());
  }

  Future register(String name, String email, String password) async {
    log("name: $name, email: $email, password: $password");
    final res = await api.register(name, email, password);
    storage.write("ExpensoAuthToken", res["token"]);
    token.value = res["token"];
    authUser = User.fromJson(res["user"]);
    Get.offAll(() => DashboardScreen());
  }

  Future<void> verify() async {
    final res = await api.verify();
    authUser = User.fromJson(res["user"]);
  }

  Future<String> initAuthUser() async {
    final token = await storage.read('ExpensoAuthToken');
    log("token: $token");

    if (token == null) {
      return "No User";
    }
    log("token found: $token");
    try {
      final res = await api.verify();
      authUser = User.fromJson(res["user"]);
      return "User";
    } catch (e) {
      // developer.log("initAuthUser: $e");
      return 'No User';
    }
  }

  signOut() {
    storage.remove("ExpensoAuthToken");
    Get.offAll(() => LoginScreen());
  }
}
