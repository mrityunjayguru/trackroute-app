// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alerts_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertsListing<T> _$AlertsListingFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) =>
    AlertsListing<T>(
      totalCount: (json['totalCount'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
    );

Map<String, dynamic> _$AlertsListingToJson<T>(
  AlertsListing<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'message': instance.message,
      'data': instance.data?.map(toJsonT).toList(),
    };
