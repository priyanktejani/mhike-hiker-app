// Picture model class

import 'package:flutter/material.dart';
import 'package:mhike/services/crud/model/model_constants.dart';

@immutable
class Picture {
  final int? id;
  final int hikeId;
  final String hikePicture;
  final DateTime dateTime;

  const Picture({
    this.id,
    required this.hikeId,
    required this.hikePicture,
    required this.dateTime,
  });

  // A Picture.fromJson() constructor, to crate a new Picture instance from a map structure.
  Picture.fromJson(Map<String, Object?> map)
      : id = map[idColumn] as int,
        hikeId = map[hikeIdColumn] as int,
        hikePicture = map[hikePictureColumn] as String,
        dateTime = DateTime.parse(
          map[dateTimeColumn] as String,
        );

  // A toJson() method, which converts a Picture instance into a map.
  Map<String, Object?> toJson() => {
        idColumn: id,
        hikeIdColumn: hikeId,
        hikePictureColumn: hikePicture,
        dateTimeColumn: dateTime.toIso8601String(),
      };

  @override
  String toString() => 'Picture, ID = $id, date time = $dateTime';

  @override
  bool operator ==(covariant Picture other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
