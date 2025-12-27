import 'dart:convert';
import 'dart:developer';

import 'package:expenso/services/expense_api.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  final api = ExpenseApi();
  RxList<Expense> expenses = RxList([]);

  @override
  void onInit() {
    super.onInit();
    fetchExpenses();
  }

  Future fetchExpenses() async {
    final res = await api.getExpenses();
    log(res.toString());
    expenses.value = expenseFromJson(json.encode(res));
  }

  Future addExpense({
    required double amount,
    required String category,
    required String description,
    required DateTime date,
  }) async {
    final data = {
      "amount": amount,
      "category": category,
      "description": description,
      "date": date.toIso8601String(),
    };
    await api.addExpense(data);
    fetchExpenses();
  }

  Map<int, double> getMonthlyExpenseMap(DateTime month) {
    final Map<int, double> dailyTotals = {};

    for (var e in expenses) {
      if (e.date.year == month.year && e.date.month == month.month) {
        final day = e.date.day;
        dailyTotals[day] = (dailyTotals[day] ?? 0) + e.amount;
      }
    }

    return dailyTotals;
  }

  // void addDummyMonthlyExpenses() {
  //   if (expenses.isNotEmpty) return; // prevent duplicates

  //   final now = DateTime.now();
  //   final randomAmounts = [
  //     120,
  //     340,
  //     560,
  //     220,
  //     890,
  //     150,
  //     430,
  //     700,
  //     260,
  //     510,
  //     90,
  //     310,
  //     640,
  //   ];

  //   for (int i = 0; i < randomAmounts.length; i++) {
  //     expenses.add(
  //       ExpenseModel(
  //         id: const Uuid().v4(),
  //         amount: randomAmounts[i].toDouble(),
  //         category: "Food",
  //         description: "Dummy expense",
  //         date: DateTime(now.year, now.month, i + 1),
  //       ),
  //     );
  //   }
  // }
}
