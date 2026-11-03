/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'sealed_list_parent.dart';

abstract class SealedListChild extends _iv35mfmj.SealedListParent
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SealedListChild._({
    required super.items,
    required this.name,
  });

  factory SealedListChild({
    required List<_iwm5xm7b.SealedListItem> items,
    required String name,
  }) = _SealedListChildImpl;

  factory SealedListChild.fromJson(Map<String, dynamic> jsonSerialization) {
    return SealedListChild(
      items: _iza9lbb5.Protocol().deserialize<List<_iwm5xm7b.SealedListItem>>(
        jsonSerialization['items'],
      ),
      name: jsonSerialization['name'] as String,
    );
  }

  String name;

  /// Returns a shallow copy of this [SealedListChild]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  SealedListChild copyWith({
    List<_iwm5xm7b.SealedListItem>? items,
    String? name,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SealedListChild',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'name': name,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SealedListChild',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'name': name,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SealedListChildImpl extends SealedListChild {
  _SealedListChildImpl({
    required List<_iwm5xm7b.SealedListItem> items,
    required String name,
  }) : super._(
         items: items,
         name: name,
       );

  /// Returns a shallow copy of this [SealedListChild]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SealedListChild copyWith({
    List<_iwm5xm7b.SealedListItem>? items,
    String? name,
  }) {
    return SealedListChild(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      name: name ?? this.name,
    );
  }
}
