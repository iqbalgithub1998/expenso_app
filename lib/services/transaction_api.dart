import '../core/constants/api_constants.dart';
import 'api_client.dart';

class TransactionApi {
  final _client = ApiClient();

  Future addTransaction(Map data) async {
    return await _client.post(ApiConstants.transactions, data);
  }

  Future<List> getTransactions(String friendId) async {
    return await _client.get("${ApiConstants.transactions}/$friendId");
  }
}
