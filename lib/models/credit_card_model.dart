import 'dart:convert';

List<CreditCardModel> creditCardFromJson(String str) =>
    List<CreditCardModel>.from(
      json.decode(str).map((x) => CreditCardModel.fromJson(x)),
    );

String creditCardToJson(List<CreditCardModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CreditCardModel {
  final String id;
  final String userId;
  final String name;
  final int last4;
  final double balance;
  final double cardLimit;
  final int color;
  final int billingDate;
  final int paymentDueDate;
  final DateTime createdAt;

  CreditCardModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.last4,
    required this.balance,
    required this.cardLimit,
    required this.color,
    required this.billingDate,
    required this.paymentDueDate,
    required this.createdAt,
  });

  double get usedPercent => (balance / cardLimit).clamp(0.0, 1.0);
  String get usedLabel => '${(usedPercent * 100).toStringAsFixed(1)}% USED';
  String get limitLabel => 'LIMIT  ₹${(cardLimit / 1000).toStringAsFixed(0)}K';

  String get formattedBalance {
    final parts = balance.toStringAsFixed(2).split('.');
    final intPart = parts[0].replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$intPart.${parts[1]}';
  }

  factory CreditCardModel.fromJson(Map<String, dynamic> json) =>
      CreditCardModel(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        last4: int.parse(json["last4"]), // json["last4"],
        balance: json["balance"],
        cardLimit: json["card_limit"],
        color: int.parse(json["color"]), // json["color"],
        billingDate: int.parse(json["color"]), // json["billing_date"],
        paymentDueDate: int.parse(json["color"]), // json["payment_due_date"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "last4": last4,
    "balance": balance,
    "card_limit": cardLimit,
    "color": color,
    "billing_date": billingDate,
    "payment_due_date": paymentDueDate,
    "created_at": createdAt.toIso8601String(),
  };
}
