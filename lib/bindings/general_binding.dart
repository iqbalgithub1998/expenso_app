import 'package:expenso/controllers/navigation_controller.dart';
import 'package:expenso/utils/helpers/network_manager.dart';
import 'package:get/get.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(NavigationController());
    // Get.put(AuthController());
    // Get.put(GlobalDataController());
  }
}
