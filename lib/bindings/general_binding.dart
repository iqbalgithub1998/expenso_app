import 'package:expenso/controllers/friends_store_controller.dart';
import 'package:expenso/controllers/navigation_controller.dart';
import 'package:expenso/utils/helpers/network_manager.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(NavigationController());
    // Global friends cache — fetched once, shared across every screen.
    Get.put(FriendsStore(), permanent: true);
    // Get.put(AuthController());
    // Get.put(GlobalDataController());
  }
}
