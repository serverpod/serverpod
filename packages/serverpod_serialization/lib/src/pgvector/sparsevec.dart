import 'dart:typed_data';
import 'utils.dart';

/// Represents a sparse vector that stores only non-zero elements.
class SparseVector {
  /// The total number of dimensions in the vector.
  final int dimensions;

  /// The indices of non-zero values in the vector.
  final List<int> indices;

  /// The non-zero values in the vector.
  final List<double> values;

  /// Creates a new [SparseVector] object.
  const SparseVector._(this.dimensions, this.indices, this.values);

  /// Creates a [SparseVector] from a list of doubles with all values.
  factory SparseVector(List<double> value) {
    var dimensions = value.length;
    var indices = <int>[];
    var values = <double>[];

    for (var i = 0; i < value.length; i++) {
      if (value[i] != 0) {
        indices.add(i);
        values.add(value[i]);
      }
    }

    return SparseVector._(dimensions, indices, values);
  }

  /// Creates a [SparseVector] from a map of indices to values.
  ///
  /// Map keys are indices and values are the vector values at those positions.
  /// The [dimensions] parameter specifies the total vector length.
  factory SparseVector.fromMap(Map<int, double> map, int dimensions) {
    if (map[0] != null) {
      throw ArgumentError('SparseVector map is 1-indexed, but 0 was used.');
    }

    var elements = map.entries.where((v) => v.value != 0).toList();
    elements.sort((a, b) => a.key.compareTo(b.key));

    var indices = elements.map((v) => v.key - 1).toList();
    var values = elements.map((v) => v.value).toList();

    return SparseVector._(dimensions, indices, values);
  }

  /// Creates a [SparseVector] from its binary representation.
  factory SparseVector.fromBinary(Uint8List bytes) {
    var buf = ByteData.view(bytes.buffer, bytes.offsetInBytes);
    var dimensions = buf.getInt32(0);
    var nnz = buf.getInt32(4);

    var unused = buf.getInt32(8);
    if (unused != 0) {
      throw const FormatException('Expected unused to be 0.');
    }

    var indices = <int>[];
    for (var i = 0; i < nnz; i++) {
      indices.add(buf.getInt32(12 + i * 4));
    }

    var values = <double>[];
    for (var i = 0; i < nnz; i++) {
      values.add(buf.getFloat32(12 + nnz * 4 + i * 4));
    }

    return SparseVector._(dimensions, indices, values);
  }

  /// Converts the sparse vector to its binary representation.
  Uint8List toBinary() {
    var nnz = indices.length;
    var bytes = Uint8List(12 + 8 * nnz);
    var buf = ByteData.view(bytes.buffer, bytes.offsetInBytes);

    buf.setInt32(0, dimensions);
    buf.setInt32(4, nnz);
    buf.setInt32(8, 0);

    for (var i = 0; i < nnz; i++) {
      buf.setInt32(12 + i * 4, indices[i]);
    }

    for (var i = 0; i < nnz; i++) {
      buf.setFloat32(12 + nnz * 4 + i * 4, values[i]);
    }

    return bytes;
  }

  /// Returns the sparse vector as a dense list of double values.
  List<double> toList() {
    var vec = List<double>.filled(dimensions, 0.0);
    for (var i = 0; i < indices.length; i++) {
      vec[indices[i]] = values[i];
    }
    return vec;
  }

  @override
  String toString() {
    var elements = [
      for (var i = 0; i < indices.length; i++) '${indices[i] + 1}:${values[i]}'
    ].join(',');
    return '{$elements}/$dimensions';
  }

  /// Creates a [SparseVector] from a string representation.
  static SparseVector fromString(String value) {
    if (value.isEmpty || !(value.startsWith('{') && value.contains('}/'))) {
      throw FormatException('Invalid sparse vector string: $value');
    }
    final parts = value.split('/');
    final mapStr = parts.first.substring(1, parts.first.length - 1);
    final map = <int, double>{
      if (mapStr.isNotEmpty)
        for (var v in mapStr.split(',').map((e) => e.split(':')))
          int.parse(v.first): double.parse(v.last)
    };
    return SparseVector.fromMap(map, int.parse(parts.last));
  }

  @override
  bool operator ==(Object other) =>
      other is SparseVector &&
      other.dimensions == dimensions &&
      other.indices.equals(indices) &&
      other.values.equals(values);

  @override
  int get hashCode => Object.hash(dimensions, indices, values);
}
