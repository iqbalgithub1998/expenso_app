class User {
  String name;
  String email;
  String id;

  User({required this.name, required this.email, required this.id});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(name: json["name"], email: json["email"], id: json["_id"]);

  Map<String, dynamic> toJson() => {"name": name, "email": email, "_id": id};
}
