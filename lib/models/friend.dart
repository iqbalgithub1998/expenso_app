import 'dart:convert';

List<Friends> friendsFromJson(String str) =>
    List<Friends>.from(json.decode(str).map((x) => Friends.fromJson(x)));

String friendsToJson(List<Friends> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Friends {
  final String id;
  final String ownerId;
  final String name;
  final String number;
  final String? linkedUserId;
  final double closingBalance;
  final DateTime createdAt;

  Friends({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.number,
    this.linkedUserId,
    this.closingBalance = 0.00,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Friends.fromJson(Map<String, dynamic> json) => Friends(
    id: json['id'],
    ownerId: json['owner_id'],
    name: json['name'],
    number: json['phone'] ?? '',
    linkedUserId: json['linked_user_id'],
    closingBalance: double.tryParse(json['closing_balance'].toString()) ?? 0.00,
    createdAt: DateTime.parse(json['created_at']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'owner_id': ownerId,
    'name': name,
    'phone': number,
    'linked_user_id': linkedUserId,
    'closing_balance': closingBalance,
    'created_at': createdAt.toIso8601String(),
  };

  /// Initials for avatar
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Badge / avatar accent colour
  int get badgeColorValue {
    if (closingBalance > 0) return 0xFF00A651; // green  — you lent
    if (closingBalance < 0) return 0xFFE07B00; // orange — you owe
    return 0xFF6B7280; // grey   — settled
  }

  /// Badge / avatar background colour
  int get badgeBgValue {
    if (closingBalance > 0) return 0xFF0D1E14; // dark green tint
    if (closingBalance < 0) return 0xFF1A1200; // dark amber tint
    return 0xFF1A1D26; // neutral dark
  }

  /// Amount colour (green = owed to you, red = you owe)
  int get amountColorValue {
    if (closingBalance == 0) return 0xFF374151;
    return closingBalance > 0 ? 0xFF00A651 : 0xFFDC2626;
  }

  /// Formatted amount label, e.g. "\$45.00"
  String get amountLabel {
    if (closingBalance == 0) return r'₹0.00';
    final abs = closingBalance.abs().toStringAsFixed(2);
    return closingBalance > 0 ? '₹$abs' : '-₹$abs';
  }
}
