import 'dart:typed_data';
import 'utils.dart';

/// Represents a binary vector, where each element is either `true` or `false`.
class Bit {
  final int _len;
  final Uint8List _data;

  const Bit._(this._len, this._data);

  /// Creates a [Bit] from a list of boolean values.
  factory Bit(List<bool> value) {
    var length = value.length;
    var data = Uint8List((length + 7) ~/ 8);
    for (var i = 0; i < length; i++) {
      data[i ~/ 8] |= (value[i] ? 1 : 0) << (7 - (i % 8));
    }
    return Bit._(length, data);
  }

  /// Creates a [Bit] from its binary representation.
  factory Bit.fromBinary(Uint8List bytes) {
    var buf = ByteData.view(bytes.buffer, bytes.offsetInBytes);
    var length = buf.getInt32(0);
    return Bit._(length, bytes.sublist(4));
  }

  /// Converts the bit vector to its binary representation.
  Uint8List toBinary() {
    var bytes = Uint8List(4 + (_len + 7) ~/ 8);
    var buf = ByteData.view(bytes.buffer, bytes.offsetInBytes);

    buf.setInt32(0, _len);

    for (var i = 0; i < _data.length; i++) {
      buf.setUint8(4 + i, _data[i]);
    }

    return bytes;
  }

  /// Returns the bit vector as a list of boolean values.
  List<bool> toList() {
    var vec = <bool>[];
    for (var i = 0; i < _len; i++) {
      vec.add((_data[i ~/ 8] >> (7 - (i % 8))) & 1 == 1);
    }
    return vec;
  }

  /// Creates a [Bit] from a string representation.
  static Bit fromString(String value) {
    if (value.isEmpty || !RegExp(r'^[01]+$').hasMatch(value)) {
      throw FormatException('Invalid bit string: $value');
    }
    return Bit(value.split('').map((c) => c == '1').toList());
  }

  @override
  String toString() => toList().map((v) => v ? '1' : '0').join();

  @override
  bool operator ==(Object other) =>
      other is Bit && other._len == _len && other._data.equals(_data);

  @override
  int get hashCode => Object.hash(_len, _data);
}
