import 'dart:convert';

enum TransactionType { lend, borrow, settlement }

List<FriendTransactionModel> friendTransactionModelFromJson(String str) =>
    List<FriendTransactionModel>.from(
      json.decode(str).map((x) => FriendTransactionModel.fromJson(x)),
    );

String friendTransactionModelToJson(List<FriendTransactionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FriendTransactionModel {
  String id;
  String friendId;
  double amount;
  TransactionType type;
  String note;
  DateTime date;

  FriendTransactionModel({
    required this.id,
    required this.friendId,
    required this.amount,
    required this.type,
    required this.note,
    required this.date,
  });

  factory FriendTransactionModel.fromJson(Map<String, dynamic> json) =>
      FriendTransactionModel(
        id: json["id"],
        friendId: json["friendId"],
        amount: (json["amount"] as num).toDouble(),
        type: TransactionType.values.firstWhere(
          (e) => e.name == json["type"], // "lend" -> TransactionType.lend
        ),
        note: json["note"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "friendId": friendId,
    "amount": amount,
    "type": type.name,
    "note": note,
    "date": date.toIso8601String(),
  };
}
