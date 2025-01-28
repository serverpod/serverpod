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

abstract class StringDefaultPersist implements _i1.SerializableModel {
  StringDefaultPersist._({
    this.id,
    this.stringDefaultPersist,
    this.stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
    this.stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
    this.stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
    this.stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
    this.stringDefaultPersistSingleQuoteWithOneDoubleQuote,
    this.stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
    this.stringDefaultPersistDoubleQuoteWithOneSingleQuote,
    this.stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
  });

  factory StringDefaultPersist({
    int? id,
    String? stringDefaultPersist,
    String? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithOneDoubleQuote,
    String? stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
    String? stringDefaultPersistDoubleQuoteWithOneSingleQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
  }) = _StringDefaultPersistImpl;

  factory StringDefaultPersist.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return StringDefaultPersist(
      id: jsonSerialization['id'] as int?,
      stringDefaultPersist:
          jsonSerialization['stringDefaultPersist'] as String?,
      stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote:
          jsonSerialization[
                  'stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote']
              as String?,
      stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote:
          jsonSerialization[
                  'stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote']
              as String?,
      stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote:
          jsonSerialization[
                  'stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote']
              as String?,
      stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote:
          jsonSerialization[
                  'stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote']
              as String?,
      stringDefaultPersistSingleQuoteWithOneDoubleQuote:
          jsonSerialization['stringDefaultPersistSingleQuoteWithOneDoubleQuote']
              as String?,
      stringDefaultPersistSingleQuoteWithTwoDoubleQuote:
          jsonSerialization['stringDefaultPersistSingleQuoteWithTwoDoubleQuote']
              as String?,
      stringDefaultPersistDoubleQuoteWithOneSingleQuote:
          jsonSerialization['stringDefaultPersistDoubleQuoteWithOneSingleQuote']
              as String?,
      stringDefaultPersistDoubleQuoteWithTwoSingleQuote:
          jsonSerialization['stringDefaultPersistDoubleQuoteWithTwoSingleQuote']
              as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String? stringDefaultPersist;

  String? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote;

  String? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote;

  String? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote;

  String? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote;

  String? stringDefaultPersistSingleQuoteWithOneDoubleQuote;

  String? stringDefaultPersistSingleQuoteWithTwoDoubleQuote;

  String? stringDefaultPersistDoubleQuoteWithOneSingleQuote;

  String? stringDefaultPersistDoubleQuoteWithTwoSingleQuote;

  /// Returns a shallow copy of this [StringDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  StringDefaultPersist copyWith({
    int? id,
    String? stringDefaultPersist,
    String? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithOneDoubleQuote,
    String? stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
    String? stringDefaultPersistDoubleQuoteWithOneSingleQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (stringDefaultPersist != null)
        'stringDefaultPersist': stringDefaultPersist,
      if (stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote != null)
        'stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote':
            stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
      if (stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote != null)
        'stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote':
            stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
      if (stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote != null)
        'stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote':
            stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
      if (stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote != null)
        'stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote':
            stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
      if (stringDefaultPersistSingleQuoteWithOneDoubleQuote != null)
        'stringDefaultPersistSingleQuoteWithOneDoubleQuote':
            stringDefaultPersistSingleQuoteWithOneDoubleQuote,
      if (stringDefaultPersistSingleQuoteWithTwoDoubleQuote != null)
        'stringDefaultPersistSingleQuoteWithTwoDoubleQuote':
            stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
      if (stringDefaultPersistDoubleQuoteWithOneSingleQuote != null)
        'stringDefaultPersistDoubleQuoteWithOneSingleQuote':
            stringDefaultPersistDoubleQuoteWithOneSingleQuote,
      if (stringDefaultPersistDoubleQuoteWithTwoSingleQuote != null)
        'stringDefaultPersistDoubleQuoteWithTwoSingleQuote':
            stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StringDefaultPersistImpl extends StringDefaultPersist {
  _StringDefaultPersistImpl({
    int? id,
    String? stringDefaultPersist,
    String? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
    String? stringDefaultPersistSingleQuoteWithOneDoubleQuote,
    String? stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
    String? stringDefaultPersistDoubleQuoteWithOneSingleQuote,
    String? stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
  }) : super._(
          id: id,
          stringDefaultPersist: stringDefaultPersist,
          stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote:
              stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
          stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote:
              stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
          stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote:
              stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
          stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote:
              stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
          stringDefaultPersistSingleQuoteWithOneDoubleQuote:
              stringDefaultPersistSingleQuoteWithOneDoubleQuote,
          stringDefaultPersistSingleQuoteWithTwoDoubleQuote:
              stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
          stringDefaultPersistDoubleQuoteWithOneSingleQuote:
              stringDefaultPersistDoubleQuoteWithOneSingleQuote,
          stringDefaultPersistDoubleQuoteWithTwoSingleQuote:
              stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
        );

  /// Returns a shallow copy of this [StringDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  StringDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? stringDefaultPersist = _Undefined,
    Object? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote =
        _Undefined,
    Object? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote =
        _Undefined,
    Object? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote =
        _Undefined,
    Object? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote =
        _Undefined,
    Object? stringDefaultPersistSingleQuoteWithOneDoubleQuote = _Undefined,
    Object? stringDefaultPersistSingleQuoteWithTwoDoubleQuote = _Undefined,
    Object? stringDefaultPersistDoubleQuoteWithOneSingleQuote = _Undefined,
    Object? stringDefaultPersistDoubleQuoteWithTwoSingleQuote = _Undefined,
  }) {
    return StringDefaultPersist(
      id: id is int? ? id : this.id,
      stringDefaultPersist: stringDefaultPersist is String?
          ? stringDefaultPersist
          : this.stringDefaultPersist,
      stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote:
          stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote is String?
              ? stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote
              : this.stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote,
      stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote:
          stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote is String?
              ? stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote
              : this.stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote,
      stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote:
          stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote is String?
              ? stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote
              : this.stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote,
      stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote:
          stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote is String?
              ? stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote
              : this.stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote,
      stringDefaultPersistSingleQuoteWithOneDoubleQuote:
          stringDefaultPersistSingleQuoteWithOneDoubleQuote is String?
              ? stringDefaultPersistSingleQuoteWithOneDoubleQuote
              : this.stringDefaultPersistSingleQuoteWithOneDoubleQuote,
      stringDefaultPersistSingleQuoteWithTwoDoubleQuote:
          stringDefaultPersistSingleQuoteWithTwoDoubleQuote is String?
              ? stringDefaultPersistSingleQuoteWithTwoDoubleQuote
              : this.stringDefaultPersistSingleQuoteWithTwoDoubleQuote,
      stringDefaultPersistDoubleQuoteWithOneSingleQuote:
          stringDefaultPersistDoubleQuoteWithOneSingleQuote is String?
              ? stringDefaultPersistDoubleQuoteWithOneSingleQuote
              : this.stringDefaultPersistDoubleQuoteWithOneSingleQuote,
      stringDefaultPersistDoubleQuoteWithTwoSingleQuote:
          stringDefaultPersistDoubleQuoteWithTwoSingleQuote is String?
              ? stringDefaultPersistDoubleQuoteWithTwoSingleQuote
              : this.stringDefaultPersistDoubleQuoteWithTwoSingleQuote,
    );
  }
}
