// To parse this JSON data, do
//
//     final socialLogins = socialLoginsFromJson(jsonString);

import 'dart:convert';

SocialLogins socialLoginsFromJson(String str) => SocialLogins.fromJson(json.decode(str));

String socialLoginsToJson(SocialLogins data) => json.encode(data.toJson());

class SocialLogins {
  SocialLogins({
    required this.name,
    required this.email,
    required this.token,
  });

  String? name;
  String? email;
  String? token;

  factory SocialLogins.fromJson(Map<String, dynamic> json) => SocialLogins(
    name: json["name"],
    email: json["email"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "token": token,
  };
}
