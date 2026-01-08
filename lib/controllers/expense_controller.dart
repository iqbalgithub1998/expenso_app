import 'dart:convert';
import 'dart:developer';

import 'package:expenso/services/expense_api.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  final api = ExpenseApi();
  RxList<Expense> expenses = RxList([]);
  RxList<Expense> TodayExpenses = RxList([]);
  final selectedMonth = DateTime.now().obs;
  final monthlyExpenseTotal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    var month = selectedMonth.value.month.toString().padLeft(2, '0');
    var year = selectedMonth.value.year;
    var date = "$year-$month";
    fetchExpenses(date);
  }

  Future fetchExpenses(String date) async {
    final res = await api.getExpenses(date);
    if (res == null) return;
    log(res.toString());
    log('${DateTime.now().year}-${DateTime.now().month}');
    if (res["month"] ==
        '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}') {
      TodayExpenses.value = expenseFromJson(json.encode(res["expenses"]));
    }
    expenses.value = expenseFromJson(json.encode(res["expenses"]));
    monthlyExpenseTotal.value = res["total"].toDouble();
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
    final res = await api.addExpense(data);
    if (res == null) return;
    fetchExpenses('${selectedMonth.value.year}-${selectedMonth.value.month}');
  }

  Map<int, double> getMonthlyExpenseMap(DateTime month) {
    final Map<int, double> dailyTotals = {};

    for (var e in TodayExpenses) {
      if (e.date.year == month.year && e.date.month == month.month) {
        final day = e.date.day;
        dailyTotals[day] = (dailyTotals[day] ?? 0) + e.amount;
      }
    }

    return dailyTotals;
  }

  List<Expense> get monthlyExpenses {
    return expenses.where((expense) {
      return expense.date.year == selectedMonth.value.year &&
          expense.date.month == selectedMonth.value.month;
    }).toList();
  }

  // double get monthlyTotal {
  //   return monthlyExpenses.fold(0, (sum, expense) => sum + expense.amount);
  // }

  // Group expenses by date
  Map<DateTime, List<Expense>> get groupedExpenses {
    final Map<DateTime, List<Expense>> grouped = {};

    for (var expense in monthlyExpenses) {
      final dateOnly = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );

      if (grouped[dateOnly] == null) {
        grouped[dateOnly] = [];
      }
      grouped[dateOnly]!.add(expense);
    }

    return grouped;
  }

  void previousMonth() {
    fetchExpenses(
      '${selectedMonth.value.year}-${selectedMonth.value.month - 1}',
    );
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month - 1,
    );
  }

  void nextMonth() {
    fetchExpenses(
      '${selectedMonth.value.year}-${selectedMonth.value.month + 1}',
    );
    selectedMonth.value = DateTime(
      selectedMonth.value.year,
      selectedMonth.value.month + 1,
    );
  }

  void deleteExpense(String id) {
    expenses.removeWhere((e) => e.id == id);
  }
}
