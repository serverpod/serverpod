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
import 'package:serverpod/serverpod.dart' as _i1;

class ParentWithChangedId
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ParentWithChangedId({_i1.UuidValue? id}) : id = id ?? _i1.Uuid().v7obj();

  factory ParentWithChangedId.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentWithChangedId(
        id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']));
  }

  _i1.UuidValue id;

  /// Returns a shallow copy of this [ParentWithChangedId]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ParentWithChangedId copyWith({_i1.UuidValue? id}) {
    return ParentWithChangedId(id: id ?? this.id);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'id': id.toJson()};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}
