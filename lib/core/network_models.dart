import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_models.freezed.dart';
part 'network_models.g.dart';

@freezed
abstract class VinData with _$VinData {
  const factory VinData({
    String? feedback,
    String? make,
    String? model,
    String? externalId,
    double? price,
    bool? positiveCustomerFeedback,
    String? origin,
    String? containerName,
    int? similarity,
    @JsonKey(name: '_fk_uuid_auction') String? auctionUuid,
  }) = _VinData;

  factory VinData.fromJson(Map<String, dynamic> json) =>
      _$VinDataFromJson(json);
}
