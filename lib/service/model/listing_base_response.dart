import 'package:json_annotation/json_annotation.dart';

part 'listing_base_response.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
  anyMap: true,
  explicitToJson: true,
)
class ListingBaseResponse<T> {
  @JsonKey(name: 'status')
  int? status;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'data')
  List<T>? data;

  ListingBaseResponse({
    this.status,
    this.message,
    this.data,
  });

  factory ListingBaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ListingBaseResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ListingBaseResponseToJson(this, toJsonT);
}
