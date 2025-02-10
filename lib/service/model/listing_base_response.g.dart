// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'listing_base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListingBaseResponse<T> _$ListingBaseResponseFromJson<T>(
  Map json,
  T Function(Object? json) fromJsonT,
) =>
    ListingBaseResponse<T>(
      status: (json['status'] as num?)?.toInt(),
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)?.map(fromJsonT).toList(),
    );

Map<String, dynamic> _$ListingBaseResponseToJson<T>(
  ListingBaseResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data?.map(toJsonT).toList(),
    };
