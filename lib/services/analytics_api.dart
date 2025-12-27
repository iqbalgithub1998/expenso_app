import '../core/constants/api_constants.dart';
import 'api_client.dart';

class AnalyticsApi {
  final _client = ApiClient();

  Future<Map> getOverview() async {
    return await _client.get("${ApiConstants.analytics}/overview");
  }

  Future<Map> getMonthlyExpense(int month, int year) async {
    return await _client.get(
      "${ApiConstants.analytics}/monthly-expense?month=$month&year=$year",
    );
  }

  Future<Map> getLendBorrow() async {
    return await _client.get("${ApiConstants.analytics}/lend-borrow");
  }
}
