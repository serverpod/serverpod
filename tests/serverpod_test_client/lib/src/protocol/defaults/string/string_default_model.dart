/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class StringDefaultModel implements _i1.SerializableModel {
  StringDefaultModel._({
    this.id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  })  : stringDefaultModel =
            stringDefaultModel ?? 'This is a default model value',
        stringDefaultModelNull =
            stringDefaultModelNull ?? 'This is a default model null value';

  factory StringDefaultModel({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) = _StringDefaultModelImpl;

  factory StringDefaultModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefaultModel(
      id: jsonSerialization['id'] as int?,
      stringDefaultModel: jsonSerialization['stringDefaultModel'] as String,
      stringDefaultModelNull:
          jsonSerialization['stringDefaultModelNull'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String stringDefaultModel;

  String stringDefaultModelNull;

  /// Returns a shallow copy of this [StringDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StringDefaultModel copyWith({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'stringDefaultModel': stringDefaultModel,
      'stringDefaultModelNull': stringDefaultModelNull,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultModelImpl extends StringDefaultModel {
  _StringDefaultModelImpl({
    int? id,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) : super._(
          id: id,
          stringDefaultModel: stringDefaultModel,
          stringDefaultModelNull: stringDefaultModelNull,
        );

  /// Returns a shallow copy of this [StringDefaultModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StringDefaultModel copyWith({
    Object? id = _Undefined,
    String? stringDefaultModel,
    String? stringDefaultModelNull,
  }) {
    return StringDefaultModel(
      id: id is int? ? id : this.id,
      stringDefaultModel: stringDefaultModel ?? this.stringDefaultModel,
      stringDefaultModelNull:
          stringDefaultModelNull ?? this.stringDefaultModelNull,
    );
  }
}
