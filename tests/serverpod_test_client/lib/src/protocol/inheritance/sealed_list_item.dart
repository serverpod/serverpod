/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class SealedListItem
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SealedListItem._({required this.value});

  factory SealedListItem({required String value}) = _SealedListItemImpl;

  factory SealedListItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return SealedListItem(value: jsonSerialization['value'] as String);
  }

  String value;

  /// Returns a shallow copy of this [SealedListItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SealedListItem copyWith({String? value});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SealedListItem',
      'value': value,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SealedListItem',
      'value': value,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SealedListItemImpl extends SealedListItem {
  _SealedListItemImpl({required String value}) : super._(value: value);

  /// Returns a shallow copy of this [SealedListItem]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SealedListItem copyWith({String? value}) {
    return SealedListItem(value: value ?? this.value);
  }
}
