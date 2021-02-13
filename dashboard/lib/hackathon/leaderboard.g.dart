// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) {
  return Participant(
    json['total_points'] as int,
    json['_id'] as String,
    json['name'] as String,
    json['email'] as String,
  );
}

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'total_points': instance.total_points,
      '_id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
