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

abstract class StringDefaultMix implements _i1.SerializableModel {
  StringDefaultMix._({
    this.id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  })  : stringDefaultAndDefaultModel =
            stringDefaultAndDefaultModel ?? 'This is a default model value',
        stringDefaultAndDefaultPersist =
            stringDefaultAndDefaultPersist ?? 'This is a default value',
        stringDefaultModelAndDefaultPersist =
            stringDefaultModelAndDefaultPersist ?? 'This is a default value';

  factory StringDefaultMix({
    int? id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  }) = _StringDefaultMixImpl;

  factory StringDefaultMix.fromJson(Map<String, dynamic> jsonSerialization) {
    return StringDefaultMix(
      id: jsonSerialization['id'] as int?,
      stringDefaultAndDefaultModel:
          jsonSerialization['stringDefaultAndDefaultModel'] as String,
      stringDefaultAndDefaultPersist:
          jsonSerialization['stringDefaultAndDefaultPersist'] as String,
      stringDefaultModelAndDefaultPersist:
          jsonSerialization['stringDefaultModelAndDefaultPersist'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String stringDefaultAndDefaultModel;

  String stringDefaultAndDefaultPersist;

  String stringDefaultModelAndDefaultPersist;

  /// Returns a shallow copy of this [StringDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StringDefaultMix copyWith({
    int? id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'stringDefaultAndDefaultModel': stringDefaultAndDefaultModel,
      'stringDefaultAndDefaultPersist': stringDefaultAndDefaultPersist,
      'stringDefaultModelAndDefaultPersist':
          stringDefaultModelAndDefaultPersist,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultMixImpl extends StringDefaultMix {
  _StringDefaultMixImpl({
    int? id,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  }) : super._(
          id: id,
          stringDefaultAndDefaultModel: stringDefaultAndDefaultModel,
          stringDefaultAndDefaultPersist: stringDefaultAndDefaultPersist,
          stringDefaultModelAndDefaultPersist:
              stringDefaultModelAndDefaultPersist,
        );

  /// Returns a shallow copy of this [StringDefaultMix]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StringDefaultMix copyWith({
    Object? id = _Undefined,
    String? stringDefaultAndDefaultModel,
    String? stringDefaultAndDefaultPersist,
    String? stringDefaultModelAndDefaultPersist,
  }) {
    return StringDefaultMix(
      id: id is int? ? id : this.id,
      stringDefaultAndDefaultModel:
          stringDefaultAndDefaultModel ?? this.stringDefaultAndDefaultModel,
      stringDefaultAndDefaultPersist:
          stringDefaultAndDefaultPersist ?? this.stringDefaultAndDefaultPersist,
      stringDefaultModelAndDefaultPersist:
          stringDefaultModelAndDefaultPersist ??
              this.stringDefaultModelAndDefaultPersist,
    );
  }
}
