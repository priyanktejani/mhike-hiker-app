// Observation model class

import 'package:flutter/material.dart';
import 'package:mhike/services/crud/model/model_constants.dart';

@immutable
class Observation {
  final int? id;
  final int hikeId;
  final String observationTitle;
  final String observationCategory;
  final String observationDetail;
  final DateTime dateTime;

  const Observation({
    this.id,
    required this.hikeId,
    required this.observationTitle,
    required this.observationCategory,
    required this.observationDetail,
    required this.dateTime,
  });

  // A Observation.fromJson() constructor, to crate a new Observation instance from a map structure.
  Observation.fromJson(Map<String, Object?> map)
      : id = map[idColumn] as int,
        hikeId = map[hikeIdColumn] as int,
        observationTitle = map[observationTitleColumn] as String,
        observationCategory = map[observationCategoryColumn] as String,
        observationDetail = map[observationDetailColumn] as String,
        dateTime = DateTime.parse(map[dateTimeColumn] as String);

  // A toJson() method, which converts a Hike Observation into a map.
  Map<String, Object?> toJson() => {
        idColumn: id,
        hikeIdColumn: hikeId,
        observationTitleColumn: observationTitle,
        observationCategoryColumn: observationCategory,
        observationDetailColumn: observationDetail,
        dateTimeColumn: dateTime.toIso8601String(),
      };

  @override
  String toString() =>
      'Observation, ID = $id, observation title = $observationTitle, observation category = $observationCategory';

  @override
  bool operator ==(covariant Observation other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
