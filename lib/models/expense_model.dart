// To parse this JSON data, do
//
//     final expense = expenseFromJson(jsonString);

import 'dart:convert';

List<Expense> expenseFromJson(String str) =>
    List<Expense>.from(json.decode(str).map((x) => Expense.fromJson(x)));

String expenseToJson(List<Expense> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Expense {
  String id;
  int amount;
  String category;
  String description;
  DateTime date;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.description,
    required this.date,
  });

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json["id"],
    amount: json["amount"],
    category: json["category"],
    description: json["description"],
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "amount": amount,
    "category": category,
    "description": description,
    "date": date.toIso8601String(),
  };
}
