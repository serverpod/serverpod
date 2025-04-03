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
import 'package:uuid/uuid.dart' as _i2;

abstract class ActiveSession implements _i1.SerializableModel {
  ActiveSession._({
    _i1.UuidValue? id,
    required this.userId,
    required this.created,
    required this.sessionKey,
  }) : id = id ?? _i2.Uuid().v4obj();

  factory ActiveSession({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required DateTime created,
    required String sessionKey,
  }) = _ActiveSessionImpl;

  factory ActiveSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return ActiveSession(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      sessionKey: jsonSerialization['sessionKey'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  /// The id of the [AuthUser] this session belongs to
  _i1.UuidValue userId;

  /// The time when this sesion was created.
  DateTime created;

  String sessionKey;

  /// Returns a shallow copy of this [ActiveSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ActiveSession copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    DateTime? created,
    String? sessionKey,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      'created': created.toJson(),
      'sessionKey': sessionKey,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ActiveSessionImpl extends ActiveSession {
  _ActiveSessionImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    required DateTime created,
    required String sessionKey,
  }) : super._(
          id: id,
          userId: userId,
          created: created,
          sessionKey: sessionKey,
        );

  /// Returns a shallow copy of this [ActiveSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ActiveSession copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    DateTime? created,
    String? sessionKey,
  }) {
    return ActiveSession(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      created: created ?? this.created,
      sessionKey: sessionKey ?? this.sessionKey,
    );
  }
}
