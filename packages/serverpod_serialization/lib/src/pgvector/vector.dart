import 'dart:typed_data';
import 'utils.dart';

class Vector {
  final List<double> _vec;

  const Vector(this._vec);

  factory Vector.fromBinary(Uint8List bytes) {
    var buf = new ByteData.view(bytes.buffer, bytes.offsetInBytes);
    var dim = buf.getInt16(0);

    var unused = buf.getInt16(2);
    if (unused != 0) {
      throw FormatException('expected unused to be 0');
    }

    var vec = <double>[];
    for (var i = 0; i < dim; i++) {
      vec.add(buf.getFloat32(4 + i * 4));
    }

    return Vector(vec);
  }

  Uint8List toBinary() {
    var dim = _vec.length;
    var bytes = new Uint8List(4 + 4 * dim);
    var buf = new ByteData.view(bytes.buffer, bytes.offsetInBytes);

    buf.setInt16(0, dim);
    buf.setInt16(2, 0);

    for (var i = 0; i < dim; i++) {
      buf.setFloat32(4 + i * 4, _vec[i]);
    }

    return bytes;
  }

  List<double> toList() {
    return _vec;
  }

  @override
  String toString() {
    return _vec.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is Vector && listEquals(other._vec, _vec);

  @override
  int get hashCode => _vec.hashCode;
}
