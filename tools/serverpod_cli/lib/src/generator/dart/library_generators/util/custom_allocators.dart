import 'package:code_builder/code_builder.dart';

class PartOfAllocator implements Allocator {
  static final _doNotPrefix = ['dart:core'];

  final _imports = <String, int>{};
  var _keys = 1;

  PartOfAllocator(List<String>? doNotPrefix) {
    _doNotPrefix.addAll(doNotPrefix ?? []);
  }

  @override
  String allocate(Reference reference) {
    var symbol = reference.symbol;
    var url = reference.url;

    if (url == null || _doNotPrefix.contains(url)) {
      return symbol!;
    }

    return '_i${_imports.putIfAbsent(url, _nextKey)}.$symbol';
  }

  int _nextKey() => _keys++;

  @override
  Iterable<Directive> get imports => [];
}

class PartAllocator implements Allocator {
  PartOfAllocator _partOfAllocator;

  PartAllocator._(this._partOfAllocator);

  factory PartAllocator(PartOfAllocator partOfAllocator) {
    return PartAllocator._(partOfAllocator);
  }

  @override
  String allocate(Reference reference) {
    return _partOfAllocator.allocate(reference);
  }

  @override
  Iterable<Directive> get imports => _partOfAllocator._imports.keys.map(
        (u) => Directive.import(u, as: '_i${_partOfAllocator._imports[u]}'),
      );
}
