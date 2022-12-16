// User model class

import 'package:flutter/material.dart';
import 'package:mhike/services/crud/model/model_constants.dart';

@immutable
class User {
  final int? id;
  final String email;
  final String username;
  final String fullName;
  const User({
    this.id,
    required this.email,
    required this.username,
    required this.fullName,
  });

   // A User.fromJson() constructor, to crate a new User instance from a map structure.
  User.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String,
        username = map[usernameColumn] as String,
        fullName = map[fullNameColumn] as String;

  // A toJson() method, which converts a User Observation into a map.
  Map<String, Object?> toJson() => {
        idColumn: id,
        emailColumn: email,
        usernameColumn: username,
        fullNameColumn: fullName,
      };

  @override
  String toString() => 'User, ID = $id, email = $email';

  @override
  bool operator ==(covariant User other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
