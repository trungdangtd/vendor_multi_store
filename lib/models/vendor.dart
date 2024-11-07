// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Vendor {
  final String id;
  final String fullname;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String role;
  final String password;

  Vendor(
      {required this.id,
      required this.fullname,
      required this.email,
      required this.state,
      required this.city,
      required this.locality,
      required this.role,
      required this.password});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullname': fullname,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'role': role,
      'password': password,
    };
  }

  String toJson() => json.encode(toMap());
  factory Vendor.fromMap(Map<String, dynamic> map) {
    return Vendor(
      id: map['_id'] as String? ?? "",
      fullname: map['fullname'] as String? ?? "",
      email: map['email'] as String? ?? "",
      state: map['state'] as String? ?? "",
      city: map['city'] as String? ?? "",
      locality: map['locality'] as String? ?? "",
      role: map['role'] as String? ?? "",
      password: map['password'] as String? ?? "",
    );
  }

  factory Vendor.fromJson(String source) =>
      Vendor.fromMap(json.decode(source) as Map<String, dynamic>);
}
