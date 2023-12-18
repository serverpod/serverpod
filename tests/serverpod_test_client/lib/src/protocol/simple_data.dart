/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Just some simple data.
abstract class SimpleData extends _i1.SerializableModel {
  SimpleData._({
    this.id,
    required this.num,
  });

  factory SimpleData({
    int? id,
    required int num,
  }) = _SimpleDataImpl;

  factory SimpleData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SimpleData(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      num: serializationManager.deserialize<int>(jsonSerialization['num']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  int num;

  SimpleData copyWith({
    int? id,
    int? num,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': num,
    };
  }
}

class _Undefined {}

class _SimpleDataImpl extends SimpleData {
  _SimpleDataImpl({
    int? id,
    required int num,
  }) : super._(
          id: id,
          num: num,
        );

  @override
  SimpleData copyWith({
    Object? id = _Undefined,
    int? num,
  }) {
    return SimpleData(
      id: id is int? ? id : this.id,
      num: num ?? this.num,
    );
  }
}
