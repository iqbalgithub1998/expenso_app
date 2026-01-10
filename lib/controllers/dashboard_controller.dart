import 'package:expenso/controllers/expense_controller.dart';
import 'package:expenso/controllers/friend_controller.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  // final todayExpense = 0.0.obs;

  // final totalTake = 0.0.obs;
  // final totalPay = 0.0.obs;

  final expenseController = Get.find<ExpenseController>();
  final friendController = Get.find<FriendController>();

  void changeTab(int index) {
    currentIndex.value = index;
  }

  // 📅 Today's expense - Make it reactive
  double get todayExpense {
    // Access the observable to create reactive dependency
    expenseController.TodayExpenses.length; // This triggers reactivity

    final today = DateTime.now();
    return expenseController.TodayExpenses.where(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    ).fold(0.0, (sum, e) => sum + e.amount);
  }

  // 📅 Monthly expense - Make it reactive
  double get monthlyExpense {
    // Access the observable to create reactive dependency
    expenseController.monthlyExpenses.length; // This triggers reactivity

    return expenseController.monthlyExpenses.fold(
      0.0,
      (sum, e) => sum + e.amount,
    );
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
