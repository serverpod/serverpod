/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Just some simple data.
abstract class ExtraDataSimple extends _i1.SerializableEntity {
  const ExtraDataSimple._();

  const factory ExtraDataSimple({int? num}) = _ExtraDataSimple;

  factory ExtraDataSimple.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ExtraDataSimple(
        num: serializationManager.deserialize<int?>(jsonSerialization['num']));
  }

  ExtraDataSimple copyWith({int? num});
  int? get num;
}

class _Undefined {}

/// Just some simple data.
class _ExtraDataSimple extends ExtraDataSimple {
  const _ExtraDataSimple({this.num}) : super._();

  @override
  final int? num;

  @override
  Map<String, dynamic> toJson() {
    return {'num': num};
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ExtraDataSimple &&
            (identical(
                  other.num,
                  num,
                ) ||
                other.num == num));
  }

  @override
  int get hashCode => num.hashCode;

  @override
  ExtraDataSimple copyWith({Object? num = _Undefined}) {
    return ExtraDataSimple(num: num == _Undefined ? this.num : (num as int?));
  }
}
