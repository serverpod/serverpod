import 'package:code_builder/code_builder.dart';
import 'package:path/path.dart' as p;

class ImportCollector {
  final Map<String, int> _imports = {};
  var _nextKey = 1;
  final String basePath;

  ImportCollector(this.basePath);

  String _normalizePath(String topNodePath, String currentPath) {
    if (topNodePath.startsWith('package:') || topNodePath.startsWith('dart:')) {
      return topNodePath;
    }

    var absolutePath = p.join(p.dirname(currentPath), topNodePath);
    var relativePath = p.relative(absolutePath, from: p.dirname(basePath));

    // If on Windows, top level paths could appear with backslashes and break
    // the import clause, such as `import '..\protocol.dart' as _i1;`.
    return p.split(relativePath).join('/');
  }

  int getOrCreateAlias(String topNodePath, String currentPath) {
    var normalizedPath = _normalizePath(topNodePath, currentPath);

    return _imports.putIfAbsent(normalizedPath, () => _nextKey++);
  }

  Iterable<MapEntry<String, int>> get imports => _imports.entries;
}

class PartOfAllocator implements Allocator {
  static final _doNotPrefix = ['dart:core'];

  final String _currentPath;
  final ImportCollector _importCollector;

  PartOfAllocator({
    List<String>? doNotPrefix,
    required String currentPath,
    required ImportCollector importCollector,
  })  : _currentPath = currentPath,
        _importCollector = importCollector {
    _doNotPrefix.addAll(doNotPrefix ?? []);
  }

  @override
  String allocate(Reference reference) {
    var symbol = reference.symbol;
    var url = reference.url;

    if (url == null || _doNotPrefix.contains(url)) {
      return symbol!;
    }

    var alias = _importCollector.getOrCreateAlias(url, _currentPath);
    return '_i$alias.$symbol';
  }

  @override
  Iterable<Directive> get imports => [];
}

class PartAllocator implements Allocator {
  final PartOfAllocator _partOfAllocator;

  PartAllocator({
    required PartOfAllocator partOfAllocator,
  }) : _partOfAllocator = partOfAllocator;

  @override
  String allocate(Reference reference) => _partOfAllocator.allocate(reference);

  @override
  Iterable<Directive> get imports =>
      _partOfAllocator._importCollector.imports.map(
        (u) => Directive.import(u.key, as: '_i${u.value}'),
      );
}
