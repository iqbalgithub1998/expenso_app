import '../core/constants/api_constants.dart';
import 'api_client.dart';

class FriendApi {
  final _client = ApiClient();

  Future<List> getFriends() async {
    return await _client.get(ApiConstants.friends);
  }

  Future addFriend(Map data) async {
    return await _client.post(ApiConstants.friends, data);
  }
}
