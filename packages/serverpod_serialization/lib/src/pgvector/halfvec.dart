import 'utils.dart';

class HalfVector {
  final List<double> _vec;

  const HalfVector(this._vec);

  List<double> toList() {
    return _vec;
  }

  @override
  String toString() {
    return _vec.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is HalfVector && listEquals(other._vec, _vec);

  @override
  int get hashCode => _vec.hashCode;
}
