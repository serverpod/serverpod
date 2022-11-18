/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: public_member_api_docs
// ignore_for_file: unnecessary_import

import 'package:serverpod_client/serverpod_client.dart';

class TestEnum extends SerializableEntity {
  @override
  String get className => 'TestEnum';

  late final int _index;
  int get index => _index;

  TestEnum._internal(this._index);

  TestEnum.fromSerialization(Map<String, dynamic> serialization) {
    var data = unwrapSerializationData(serialization);
    _index = data['index'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'index': _index,
    });
  }

  static final one = TestEnum._internal(0);
  static final two = TestEnum._internal(1);
  static final three = TestEnum._internal(2);

  @override
  int get hashCode => _index.hashCode;
  @override
  bool operator ==(other) => other is TestEnum && other._index == _index;

  static final values = <TestEnum>[
    one,
    two,
    three,
  ];

  String get name {
    if (this == one) return 'one';
    if (this == two) return 'two';
    if (this == three) return 'three';
    throw const FormatException();
  }
}
