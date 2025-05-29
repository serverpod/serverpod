import 'utils.dart';

/// Represents a vector of half-precision float values.
class HalfVector {
  final List<double> _vec;

  /// Creates a new [HalfVector] from a list of double values.
  const HalfVector(this._vec);

  /// Returns the half-precision vector as a list of double values.
  List<double> toList() => _vec;

  @override
  String toString() => _vec.toString();

  @override
  bool operator ==(Object other) =>
      other is HalfVector && other._vec.equals(_vec);

  @override
  int get hashCode => _vec.hashCode;
}
