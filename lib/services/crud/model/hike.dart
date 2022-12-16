// Hike model class

import 'package:flutter/material.dart';
import 'package:mhike/services/crud/model/model_constants.dart';

@immutable
class Hike {
  final int? id;
  final String userEmail;
  final String coverImage;
  final String title;
  final DateTime dateTime;
  final String difficultyLevel;
  final bool parkingAvailability;
  final String location;
  final double length;
  final String estimatedTime;
  final String? description;
  final int? popularityIndex;

  const Hike({
    this.id,
    required this.userEmail,
    required this.coverImage,
    required this.title,
    required this.dateTime,
    required this.difficultyLevel,
    required this.parkingAvailability,
    required this.length,
    required this.location,
    required this.estimatedTime,
    this.description,
    this.popularityIndex = 0,
  });

  // A Hike.fromJson() constructor, to crate a new Hike instance from a map structure.
  Hike.fromJson(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userEmail = map[userEmailColumn] as String,
        coverImage = map[coverImageColumn] as String,
        title = map[titleColumn] as String,
        dateTime = DateTime.parse(map[dateTimeColumn] as String),
        difficultyLevel = map[difficultyLevelColumn] as String,
        parkingAvailability = map[parkingAvailabilityColumn] == 1,
        length = map[lengthColumn] as double,
        location = map[locationColumn] as String,
        estimatedTime = map[estimatedTimeColumn] as String,
        description = map[descriptionColumn] as String,
        popularityIndex = map[popularityIndexColumn] as int;

  // A toJson() method, which converts a Hike instance into a map.
  Map<String, Object?> toJson() => {
        idColumn: id,
        userEmailColumn: userEmail,
        coverImageColumn: coverImage,
        titleColumn: title,
        dateTimeColumn: dateTime.toIso8601String(),
        difficultyLevelColumn: difficultyLevel,
        parkingAvailabilityColumn: parkingAvailability ? 1 : 0,
        lengthColumn: length,
        locationColumn: location,
        estimatedTimeColumn: estimatedTime,
        descriptionColumn: description,
        popularityIndexColumn: popularityIndex,
      };

  @override
  String toString() =>
      'Hike, ID = $id, userEmail = $userEmail, title =$title, popularity index =$popularityIndex';

  @override
  bool operator ==(covariant Hike other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
