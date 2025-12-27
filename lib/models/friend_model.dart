// To parse this JSON data, do
//
//     final friendModel = friendModelFromJson(jsonString);

import 'dart:convert';

List<FriendModel> friendModelFromJson(String str) => List<FriendModel>.from(
  json.decode(str).map((x) => FriendModel.fromJson(x)),
);

String friendModelToJson(List<FriendModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FriendModel {
  String id;
  String name;
  String phone;
  double balance;

  FriendModel({
    required this.id,
    required this.name,
    required this.phone,
    this.balance = 0,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) => FriendModel(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    balance: json["balance"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "balance": balance,
  };

  FriendModel copyWith({
    String? id,
    String? name,
    String? phone,
    double? balance,
  }) {
    return FriendModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
    );
  }
}
