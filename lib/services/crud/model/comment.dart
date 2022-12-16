// Comment model class

import 'package:flutter/material.dart';
import 'package:mhike/services/crud/model/model_constants.dart';

@immutable
class Comment {
  final int? id;
  final int hikeId;
  final String userEmail;
  final double hikeRating;
  final String hikeComment;
  final DateTime dateTime;

  const Comment( {
    this.id,
    required this.hikeId,
    required this.userEmail,
    required this.hikeRating,
    required this.hikeComment,
    required this.dateTime,
  });

  // A Comment.fromJson() constructor, to crate a new Comment instance from a map structure.
  Comment.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        hikeId = map[hikeIdColumn] as int,
        userEmail = map[userEmailColumn] as String,
        hikeRating = map[hikeRatingColumn] as double,
        hikeComment = map[hikeCommentColumn] as String,
        dateTime = DateTime.parse(
          map[dateTimeColumn] as String,
        );
        
  // A toJson() method, which converts a Comment instance into a map.
  Map<String, Object?> toJson() => {
        idColumn: id,
        hikeIdColumn: hikeId,
        userEmailColumn: userEmail,
        hikeRatingColumn: hikeRating,
        hikeCommentColumn: hikeComment,
        dateTimeColumn: dateTime.toIso8601String(),
      };

  @override
  String toString() => 'Comment, ID = $id, user email = $userEmail, hike rating = $hikeRating';

  @override
  bool operator ==(covariant Comment other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
