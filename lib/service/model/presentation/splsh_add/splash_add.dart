import 'package:freezed_annotation/freezed_annotation.dart';

part 'splash_add.freezed.dart';
part 'splash_add.g.dart';

@freezed
class SplashAddResponse with _$SplashAddResponse {
  const factory SplashAddResponse({
    @Default([]) List<SplashAddData> data, // Default an empty list
    @Default('') String message, // Default an empty message
  }) = _SplashAddResponse;

  factory SplashAddResponse.fromJson(Map<String, dynamic> json) =>
      _$SplashAddResponseFromJson(json);
}

@freezed
class SplashAddData with _$SplashAddData {
  const factory SplashAddData({
    @JsonKey(name: '_id') String? id, // Nullable id
    String? image, // Nullable image
    String? hyperLink, // Nullable hyperLink
    @Default(false) bool isDeleted, // Default false for isDeleted
    @Default('InActive') String status, // Default 'InActive' for status
    DateTime? createdAt, // Nullable createdAt
    DateTime? updatedAt, // Nullable updatedAt
    @JsonKey(name: '__v') @Default(0) int v, // Default 0 for version
  }) = _SplashAddData;

  factory SplashAddData.fromJson(Map<String, dynamic> json) =>
      _$SplashAddDataFromJson(json);
}
