import 'package:expenso/controllers/expense_controller.dart';
import 'package:expenso/controllers/friend_controller.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  final expenseController = Get.find<ExpenseController>();
  final friendController = Get.find<FriendController>();

  void changeTab(int index) {
    currentIndex.value = index;
  }

  // 📅 Today's expense
  double get todayExpense {
    final today = DateTime.now();
    return expenseController.TodayExpenses.where(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    ).fold(0.0, (sum, e) => sum + e.amount);
  }

  // 🟢 You will take
  double get totalTake {
    return friendController.friends
        .where((f) => f.balance > 0)
        .fold(0.0, (sum, f) => sum + f.balance);
  }

  // 🔴 You will pay
  double get totalPay {
    return friendController.friends
        .where((f) => f.balance < 0)
        .fold(0.0, (sum, f) => sum + f.balance.abs());
  }

  // ⚖ Net balance
  double get netBalance => totalTake - totalPay;
}
