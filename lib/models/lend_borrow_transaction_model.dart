// To parse this JSON data, do
//
//     final lendBorrowTransaction = lendBorrowTransactionFromJson(jsonString);

import 'dart:convert';

List<LendBorrowTransaction> lendBorrowTransactionFromJson(String str) =>
    List<LendBorrowTransaction>.from(
      json.decode(str).map((x) => LendBorrowTransaction.fromJson(x)),
    );

String lendBorrowTransactionToJson(List<LendBorrowTransaction> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LendBorrowTransaction {
  final String id;
  final String userId;
  final String friendId;
  final String amount;
  final String? note;
  final DateTime? returnDate;
  final String type;
  final DateTime createdAt;
  final DateTime whenDate;

  LendBorrowTransaction({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.amount,
    this.note,
    this.returnDate,
    required this.type,
    required this.createdAt,
    required this.whenDate,
  });

  factory LendBorrowTransaction.fromJson(Map<String, dynamic> json) =>
      LendBorrowTransaction(
        id: json["id"] ?? "",
        userId: json["user_id"] ?? "",
        friendId: json["friend_id"] ?? "",
        amount: json["amount"]?.toString() ?? "0.00",
        note: json["note"],
        returnDate: json["return_date"] != null
            ? DateTime.parse(json["return_date"])
            : null,
        type: json["type"] ?? "",
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : DateTime.now(),
        whenDate: json["when_date"] != null
            ? DateTime.parse(json["when_date"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "friend_id": friendId,
    "amount": amount,
    "note": note,
    "return_date": returnDate != null
        ? "${returnDate!.year.toString().padLeft(4, '0')}-${returnDate!.month.toString().padLeft(2, '0')}-${returnDate!.day.toString().padLeft(2, '0')}"
        : null,
    "type": type,
    "created_at": createdAt.toIso8601String(),
    "when_date":
        "${whenDate.year.toString().padLeft(4, '0')}-${whenDate.month.toString().padLeft(2, '0')}-${whenDate.day.toString().padLeft(2, '0')}",
  };
}
