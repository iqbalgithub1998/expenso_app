import 'package:expenso/models/user.dart';
import 'package:expenso/screens/auth/auth_screen.dart';
import 'package:expenso/screens/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

class AuthRepository extends GetxController {
  static AuthRepository get instance => Get.find();
  UserModel? user;

  final GetStorage deviceStorage = GetStorage();

  @override
  void onReady() {
    initializeApp();
  }

  Future<void> initializeApp() async {
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      // user = await getUserDetails();
      Get.offAll(() => const DashboardScreen());
    } else {
      Get.offAll(() => const AuthScreen());
    }
  }

  // Future<UserModel> getUserDetails() async {
  //   final response = await Supabase.instance.client
  //       .from('users')
  //       .select()
  //       .eq('id', Supabase.instance.client.auth.currentUser?.id)
  //       .single();
  //   return UserModel.fromMap(response);
  // }
}
