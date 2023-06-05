/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class _Undefined {}

/// Just some simple data.
class SimpleData extends _i1.SerializableEntity {
  SimpleData({
    this.id,
    required this.num,
  });

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
  final int? id;

  /// The only field of [SimpleData]
  ///
  /// Second Value Extra Text
  final int num;

  late Function({
    int? id,
    int? num,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'num': num,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is SimpleData &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.num,
                  num,
                ) ||
                other.num == num));
  }

  @override
  int get hashCode => Object.hash(
        id,
        num,
      );

  SimpleData _copyWith({
    Object? id = _Undefined,
    int? num,
  }) {
    return SimpleData(
      id: id == _Undefined ? this.id : (id as int?),
      num: num ?? this.num,
    );
  }
}
