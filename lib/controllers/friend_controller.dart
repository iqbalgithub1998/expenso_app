import 'dart:convert';
import 'dart:developer';

import 'package:expenso/services/friend_api.dart';
import 'package:expenso/services/transaction_api.dart';
import 'package:get/get.dart';
import '../models/friend_model.dart';
import '../models/transaction_model.dart';

class FriendController extends GetxController {
  final api = FriendApi();
  final transactionApi = TransactionApi();
  final friends = <FriendModel>[].obs;
  final transactions = <FriendTransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFriends();
  }

  Future<void> fetchTransactions(String friendId) async {
    final res = await transactionApi.getTransactions(friendId);
    transactions.value = friendTransactionModelFromJson(json.encode(res));
  }

  Future fetchFriends() async {
    final res = await api.getFriends();
    friends.value = friendModelFromJson(json.encode(res));
  }

  void addFriend(String name, String phone) async {
    final res = await api.addFriend({"name": name, "phone": phone});
    if (res == null) {
      return;
    }
    friends.add(FriendModel.fromJson(res));
  }

  void addTransaction({
    required FriendModel friend,
    required double amount,
    required TransactionType type,
    required DateTime date,
    required String note,
  }) async {
    final data = {
      "friendId": friend.id,
      "amount": amount,
      'type': type.name,
      "date": date.toIso8601String(),
      "note": note,
    };
    final res = await transactionApi.addTransaction(data);

    transactions.insert(0, FriendTransactionModel.fromJson(res["transaction"]));
    // 🔥 BALANCE UPDATE LOGIC
    final index = friends.indexWhere((f) => f.id == friend.id);
    if (index != -1) {
      friends[index] = friends[index].copyWith(
        balance: res["updatedBalance"].toDouble(),
      );
    }
    friends.refresh();
  }

  List<FriendTransactionModel> friendTransactions(String friendId) {
    return transactions.where((t) => t.friendId == friendId).toList();
  }

  Map<String, double> getBalanceSummary() {
    double toReceive = 0;
    double toPay = 0;

    for (var friend in friends) {
      if (friend.balance > 0) {
        toReceive += friend.balance;
      } else if (friend.balance < 0) {
        toPay += friend.balance.abs();
      }
    }

    return {'toReceive': toReceive, 'toPay': toPay};
  }
}
