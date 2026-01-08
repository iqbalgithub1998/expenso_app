import 'dart:developer';

import '../core/constants/api_constants.dart';
import 'api_client.dart';

class ExpenseApi {
  final _client = ApiClient();

  Future<dynamic> getExpenses(String month) async {
    log(month);
    return await _client.get(ApiConstants.expenses, {"month": month});
  }

  Future addExpense(Map data) async {
    return await _client.post(ApiConstants.expenses, data);
  }

  Future deleteExpense(String id) async {
    return await _client.delete("${ApiConstants.expenses}/$id");
  }

  Future<dynamic> getMonthlyExpense(int month, int year) async {
    return await _client.get(
      "${ApiConstants.analytics}/monthly-expense?month=$month&year=$year",
    );
  }
}
