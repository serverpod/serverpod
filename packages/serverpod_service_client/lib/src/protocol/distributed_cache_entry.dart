/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// An entry in the distributed cache.
abstract class DistributedCacheEntry extends _i1.SerializableModel {
  DistributedCacheEntry._({required this.data});

  factory DistributedCacheEntry({required String data}) =
      _DistributedCacheEntryImpl;

  factory DistributedCacheEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DistributedCacheEntry(
        data: serializationManager
            .deserialize<String>(jsonSerialization['data']));
  }

  /// The cached data.
  String data;

  DistributedCacheEntry copyWith({String? data});
  @override
  Map<String, dynamic> toJson() {
    return {'data': data};
  }
}

class _DistributedCacheEntryImpl extends DistributedCacheEntry {
  _DistributedCacheEntryImpl({required String data}) : super._(data: data);

  @override
  DistributedCacheEntry copyWith({String? data}) {
    return DistributedCacheEntry(data: data ?? this.data);
  }
}
