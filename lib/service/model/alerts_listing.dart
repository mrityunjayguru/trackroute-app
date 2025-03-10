import 'package:json_annotation/json_annotation.dart';

part 'alerts_listing.g.dart';

@JsonSerializable(
  genericArgumentFactories: true,
  anyMap: true,
  explicitToJson: true,
)
class AlertsListing<T> {
  @JsonKey(name: 'totalCount')
  int? totalCount;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'data')
  List<T>? data;

  AlertsListing({
    this.totalCount,
    this.message,
    this.data,
  });

  factory AlertsListing.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json) fromJsonT,
      ) =>
      _$AlertsListingFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$AlertsListingToJson(this, toJsonT);
}
