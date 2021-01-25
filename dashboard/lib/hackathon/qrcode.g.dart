// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qrcode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckinItem _$CheckinItemFromJson(Map<String, dynamic> json) {
  return CheckinItem(
    json['_id'] as String,
    json['name'] as String,
    json['desc'] as String,
    json['date'] as String,
    json['lat'] as int,
    json['long'] as int,
    json['units'] as int,
    json['checkin_limit'] as int,
    json['access_code'] as int,
    json['active_status'] as int,
  );
}

Map<String, dynamic> _$CheckinItemToJson(CheckinItem instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'desc': instance.desc,
      'date': instance.date,
      'lat': instance.lat,
      'long': instance.long,
      'units': instance.units,
      'checkin_limit': instance.checkin_limit,
      'access_code': instance.access_code,
      'active_status': instance.active_status,
    };

CheckinEvent _$CheckinEventFromJson(Map<String, dynamic> json) {
  return CheckinEvent(
    json['_id'] as String,
    json['timestamp'] as String,
    json['checkin_item'] == null
        ? null
        : CheckinItem.fromJson(json['checkin_item'] as Map<String, dynamic>),
    json['user'] as String,
  );
}

Map<String, dynamic> _$CheckinEventToJson(CheckinEvent instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'timestamp': instance.timestamp,
      'checkin_item': instance.checkin_item,
      'user': instance.user,
    };
