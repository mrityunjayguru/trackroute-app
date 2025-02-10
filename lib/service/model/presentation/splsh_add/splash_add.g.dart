// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_add.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SplashAddResponseImpl _$$SplashAddResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SplashAddResponseImpl(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => SplashAddData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      message: json['message'] as String? ?? '',
    );

Map<String, dynamic> _$$SplashAddResponseImplToJson(
        _$SplashAddResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
    };

_$SplashAddDataImpl _$$SplashAddDataImplFromJson(Map<String, dynamic> json) =>
    _$SplashAddDataImpl(
      id: json['_id'] as String?,
      image: json['image'] as String?,
      hyperLink: json['hyperLink'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      status: json['status'] as String? ?? 'InActive',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      v: (json['__v'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$SplashAddDataImplToJson(_$SplashAddDataImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'image': instance.image,
      'hyperLink': instance.hyperLink,
      'isDeleted': instance.isDeleted,
      'status': instance.status,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      '__v': instance.v,
    };
