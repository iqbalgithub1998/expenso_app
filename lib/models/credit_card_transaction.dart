import 'dart:convert';

List<CreditCardTransaction> creditCardTransactionFromJson(String str) =>
    List<CreditCardTransaction>.from(
      json.decode(str).map((x) => CreditCardTransaction.fromJson(x)),
    );

String creditCardTransactionToJson(List<CreditCardTransaction> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CreditCardTransaction {
  final String id;
  final String cardId;
  final String userId;
  final String type;
  final double amount;
  final String? usedBy;
  final DateTime usedOn;
  final String? note;
  final DateTime createdAt;
  final Friend? friend;

  CreditCardTransaction({
    required this.id,
    required this.cardId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.usedBy,
    required this.usedOn,
    required this.note,
    required this.createdAt,
    required this.friend,
  });

  factory CreditCardTransaction.fromJson(Map<String, dynamic> json) =>
      CreditCardTransaction(
        id: json["id"],
        cardId: json["card_id"],
        userId: json["user_id"],
        type: json["type"],
        amount: json["amount"],
        usedBy: json["used_by"],
        usedOn: DateTime.parse(json["used_on"]),
        note: json["note"],
        createdAt: DateTime.parse(json["created_at"]),
        friend: json["friend"] == null ? null : Friend.fromJson(json["friend"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "card_id": cardId,
    "user_id": userId,
    "type": type,
    "amount": amount,
    "used_by": usedBy,
    "used_on":
        "${usedOn.year.toString().padLeft(4, '0')}-${usedOn.month.toString().padLeft(2, '0')}-${usedOn.day.toString().padLeft(2, '0')}",
    "note": note,
    "created_at": createdAt.toIso8601String(),
    "friend": friend?.toJson(),
  };
}

class Friend {
  final String id;
  final String name;
  final String phone;

  Friend({required this.id, required this.name, required this.phone});

  factory Friend.fromJson(Map<String, dynamic> json) =>
      Friend(id: json["id"], name: json["name"], phone: json["phone"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name, "phone": phone};
}
