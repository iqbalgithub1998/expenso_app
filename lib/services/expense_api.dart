import '../core/constants/api_constants.dart';
import 'api_client.dart';

class ExpenseApi {
  final _client = ApiClient();

  Future<List> getExpenses() async {
    return await _client.get(ApiConstants.expenses);
  }

  Future addExpense(Map data) async {
    return await _client.post(ApiConstants.expenses, data);
  }

  Future deleteExpense(String id) async {
    return await _client.delete("${ApiConstants.expenses}/$id");
  }

  Future<Map> getMonthlyExpense(int month, int year) async {
    return await _client.get(
      "${ApiConstants.analytics}/monthly-expense?month=$month&year=$year",
    );
  }
}
