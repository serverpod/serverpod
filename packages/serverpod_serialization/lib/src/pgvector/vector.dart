import 'dart:typed_data';
import 'utils.dart';

/// Represents a vector of double values.
class Vector {
  final List<double> _vec;

  /// Creates a new [Vector] from a list of double values.
  const Vector(this._vec);

  /// Creates a [Vector] from its binary representation.
  factory Vector.fromBinary(Uint8List bytes) {
    var buf = ByteData.view(bytes.buffer, bytes.offsetInBytes);
    var dim = buf.getInt16(0);

    var unused = buf.getInt16(2);
    if (unused != 0) {
      throw const FormatException('Expected unused byte to be 0.');
    }

    var vec = <double>[];
    for (var i = 0; i < dim; i++) {
      vec.add(buf.getFloat32(4 + i * 4));
    }

    return Vector(vec);
  }

  /// Converts the vector to its binary representation.
  Uint8List toBinary() {
    var dim = _vec.length;
    var bytes = Uint8List(4 + 4 * dim);
    var buf = ByteData.view(bytes.buffer, bytes.offsetInBytes);

    buf.setInt16(0, dim);
    buf.setInt16(2, 0);

    for (var i = 0; i < dim; i++) {
      buf.setFloat32(4 + i * 4, _vec[i]);
    }

    return bytes;
  }

  /// Returns the vector as a list of double values.
  List<double> toList() => _vec;

  @override
  String toString() => _vec.toString();

  @override
  bool operator ==(Object other) => other is Vector && other._vec.equals(_vec);

  @override
  int get hashCode => _vec.hashCode;
}
