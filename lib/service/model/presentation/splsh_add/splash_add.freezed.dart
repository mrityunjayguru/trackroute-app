// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_add.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SplashAddResponse _$SplashAddResponseFromJson(Map<String, dynamic> json) {
  return _SplashAddResponse.fromJson(json);
}

/// @nodoc
mixin _$SplashAddResponse {
  List<SplashAddData> get data =>
      throw _privateConstructorUsedError; // Default an empty list
  String get message => throw _privateConstructorUsedError;

  /// Serializes this SplashAddResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SplashAddResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SplashAddResponseCopyWith<SplashAddResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplashAddResponseCopyWith<$Res> {
  factory $SplashAddResponseCopyWith(
          SplashAddResponse value, $Res Function(SplashAddResponse) then) =
      _$SplashAddResponseCopyWithImpl<$Res, SplashAddResponse>;
  @useResult
  $Res call({List<SplashAddData> data, String message});
}

/// @nodoc
class _$SplashAddResponseCopyWithImpl<$Res, $Val extends SplashAddResponse>
    implements $SplashAddResponseCopyWith<$Res> {
  _$SplashAddResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplashAddResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<SplashAddData>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SplashAddResponseImplCopyWith<$Res>
    implements $SplashAddResponseCopyWith<$Res> {
  factory _$$SplashAddResponseImplCopyWith(_$SplashAddResponseImpl value,
          $Res Function(_$SplashAddResponseImpl) then) =
      __$$SplashAddResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SplashAddData> data, String message});
}

/// @nodoc
class __$$SplashAddResponseImplCopyWithImpl<$Res>
    extends _$SplashAddResponseCopyWithImpl<$Res, _$SplashAddResponseImpl>
    implements _$$SplashAddResponseImplCopyWith<$Res> {
  __$$SplashAddResponseImplCopyWithImpl(_$SplashAddResponseImpl _value,
      $Res Function(_$SplashAddResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplashAddResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? message = null,
  }) {
    return _then(_$SplashAddResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<SplashAddData>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SplashAddResponseImpl implements _SplashAddResponse {
  const _$SplashAddResponseImpl(
      {final List<SplashAddData> data = const [], this.message = ''})
      : _data = data;

  factory _$SplashAddResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SplashAddResponseImplFromJson(json);

  final List<SplashAddData> _data;
  @override
  @JsonKey()
  List<SplashAddData> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

// Default an empty list
  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'SplashAddResponse(data: $data, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplashAddResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), message);

  /// Create a copy of SplashAddResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplashAddResponseImplCopyWith<_$SplashAddResponseImpl> get copyWith =>
      __$$SplashAddResponseImplCopyWithImpl<_$SplashAddResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SplashAddResponseImplToJson(
      this,
    );
  }
}

abstract class _SplashAddResponse implements SplashAddResponse {
  const factory _SplashAddResponse(
      {final List<SplashAddData> data,
      final String message}) = _$SplashAddResponseImpl;

  factory _SplashAddResponse.fromJson(Map<String, dynamic> json) =
      _$SplashAddResponseImpl.fromJson;

  @override
  List<SplashAddData> get data; // Default an empty list
  @override
  String get message;

  /// Create a copy of SplashAddResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplashAddResponseImplCopyWith<_$SplashAddResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SplashAddData _$SplashAddDataFromJson(Map<String, dynamic> json) {
  return _SplashAddData.fromJson(json);
}

/// @nodoc
mixin _$SplashAddData {
  @JsonKey(name: '_id')
  String? get id => throw _privateConstructorUsedError; // Nullable id
  String? get image => throw _privateConstructorUsedError; // Nullable image
  String? get hyperLink =>
      throw _privateConstructorUsedError; // Nullable hyperLink
  bool get isDeleted =>
      throw _privateConstructorUsedError; // Default false for isDeleted
  String get status =>
      throw _privateConstructorUsedError; // Default 'InActive' for status
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Nullable createdAt
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Nullable updatedAt
  @JsonKey(name: '__v')
  int get v => throw _privateConstructorUsedError;

  /// Serializes this SplashAddData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SplashAddData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SplashAddDataCopyWith<SplashAddData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplashAddDataCopyWith<$Res> {
  factory $SplashAddDataCopyWith(
          SplashAddData value, $Res Function(SplashAddData) then) =
      _$SplashAddDataCopyWithImpl<$Res, SplashAddData>;
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? image,
      String? hyperLink,
      bool isDeleted,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt,
      @JsonKey(name: '__v') int v});
}

/// @nodoc
class _$SplashAddDataCopyWithImpl<$Res, $Val extends SplashAddData>
    implements $SplashAddDataCopyWith<$Res> {
  _$SplashAddDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SplashAddData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? image = freezed,
    Object? hyperLink = freezed,
    Object? isDeleted = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? v = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      hyperLink: freezed == hyperLink
          ? _value.hyperLink
          : hyperLink // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      v: null == v
          ? _value.v
          : v // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SplashAddDataImplCopyWith<$Res>
    implements $SplashAddDataCopyWith<$Res> {
  factory _$$SplashAddDataImplCopyWith(
          _$SplashAddDataImpl value, $Res Function(_$SplashAddDataImpl) then) =
      __$$SplashAddDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_id') String? id,
      String? image,
      String? hyperLink,
      bool isDeleted,
      String status,
      DateTime? createdAt,
      DateTime? updatedAt,
      @JsonKey(name: '__v') int v});
}

/// @nodoc
class __$$SplashAddDataImplCopyWithImpl<$Res>
    extends _$SplashAddDataCopyWithImpl<$Res, _$SplashAddDataImpl>
    implements _$$SplashAddDataImplCopyWith<$Res> {
  __$$SplashAddDataImplCopyWithImpl(
      _$SplashAddDataImpl _value, $Res Function(_$SplashAddDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SplashAddData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? image = freezed,
    Object? hyperLink = freezed,
    Object? isDeleted = null,
    Object? status = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? v = null,
  }) {
    return _then(_$SplashAddDataImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      hyperLink: freezed == hyperLink
          ? _value.hyperLink
          : hyperLink // ignore: cast_nullable_to_non_nullable
              as String?,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      v: null == v
          ? _value.v
          : v // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SplashAddDataImpl implements _SplashAddData {
  const _$SplashAddDataImpl(
      {@JsonKey(name: '_id') this.id,
      this.image,
      this.hyperLink,
      this.isDeleted = false,
      this.status = 'InActive',
      this.createdAt,
      this.updatedAt,
      @JsonKey(name: '__v') this.v = 0});

  factory _$SplashAddDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SplashAddDataImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String? id;
// Nullable id
  @override
  final String? image;
// Nullable image
  @override
  final String? hyperLink;
// Nullable hyperLink
  @override
  @JsonKey()
  final bool isDeleted;
// Default false for isDeleted
  @override
  @JsonKey()
  final String status;
// Default 'InActive' for status
  @override
  final DateTime? createdAt;
// Nullable createdAt
  @override
  final DateTime? updatedAt;
// Nullable updatedAt
  @override
  @JsonKey(name: '__v')
  final int v;

  @override
  String toString() {
    return 'SplashAddData(id: $id, image: $image, hyperLink: $hyperLink, isDeleted: $isDeleted, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplashAddDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.hyperLink, hyperLink) ||
                other.hyperLink == hyperLink) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.v, v) || other.v == v));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, image, hyperLink, isDeleted,
      status, createdAt, updatedAt, v);

  /// Create a copy of SplashAddData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SplashAddDataImplCopyWith<_$SplashAddDataImpl> get copyWith =>
      __$$SplashAddDataImplCopyWithImpl<_$SplashAddDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SplashAddDataImplToJson(
      this,
    );
  }
}

abstract class _SplashAddData implements SplashAddData {
  const factory _SplashAddData(
      {@JsonKey(name: '_id') final String? id,
      final String? image,
      final String? hyperLink,
      final bool isDeleted,
      final String status,
      final DateTime? createdAt,
      final DateTime? updatedAt,
      @JsonKey(name: '__v') final int v}) = _$SplashAddDataImpl;

  factory _SplashAddData.fromJson(Map<String, dynamic> json) =
      _$SplashAddDataImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String? get id; // Nullable id
  @override
  String? get image; // Nullable image
  @override
  String? get hyperLink; // Nullable hyperLink
  @override
  bool get isDeleted; // Default false for isDeleted
  @override
  String get status; // Default 'InActive' for status
  @override
  DateTime? get createdAt; // Nullable createdAt
  @override
  DateTime? get updatedAt; // Nullable updatedAt
  @override
  @JsonKey(name: '__v')
  int get v;

  /// Create a copy of SplashAddData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SplashAddDataImplCopyWith<_$SplashAddDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
