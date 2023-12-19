/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A GeographyPoint is a point on the surface of the earth.
abstract class GeographyPoint extends _i1.SerializableEntity {
  GeographyPoint._({
    required this.longitude,
    required this.latitude,
  });

  factory GeographyPoint({
    required double longitude,
    required double latitude,
  }) = _GeographyPointImpl;

  factory GeographyPoint.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return GeographyPoint(
      longitude: serializationManager
          .deserialize<double>(jsonSerialization['longitude']),
      latitude: serializationManager
          .deserialize<double>(jsonSerialization['latitude']),
    );
  }

  /// Longitude
  double longitude;

  /// Latitude
  double latitude;

  GeographyPoint copyWith({
    double? longitude,
    double? latitude,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'longitude': longitude,
      'latitude': latitude,
    };
  }
}

class _GeographyPointImpl extends GeographyPoint {
  _GeographyPointImpl({
    required double longitude,
    required double latitude,
  }) : super._(
          longitude: longitude,
          latitude: latitude,
        );

  @override
  GeographyPoint copyWith({
    double? longitude,
    double? latitude,
  }) {
    return GeographyPoint(
      longitude: longitude ?? this.longitude,
      latitude: latitude ?? this.latitude,
    );
  }
}
