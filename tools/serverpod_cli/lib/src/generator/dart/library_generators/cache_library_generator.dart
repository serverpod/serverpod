part of 'library_generator.dart';

extension CacheLibraryGenerator on LibraryGenerator {
  /// Generates the extension for accessing custom caches on the server side.
  Library generateServerCaches() {
    var library = LibraryBuilder();

    library.body.add(
      Code.scope((allocate) {
        final expandoDecls = protocolDefinition.customCaches
            .map((cacheDef) {
              final cacheType = allocate(
                refer(cacheDef.className, _cachePath(cacheDef)),
              );
              return 'final _${cacheDef.name}Expando = Expando<$cacheType>();';
            })
            .join('\n');

        final getters = protocolDefinition.customCaches
            .map((cacheDef) {
              final cacheType = allocate(
                refer(cacheDef.className, _cachePath(cacheDef)),
              );
              return '''
  $cacheType get ${cacheDef.name} {
    var cache = _${cacheDef.name}Expando[this];
    if (cache == null) {
      cache = $cacheType(serializationManager);
      _${cacheDef.name}Expando[this] = cache;
    }
    return cache;
  }''';
            })
            .join('\n\n');

        final cachesRef = allocate(refer('Caches', serverpodUrl(true)));

        return '''
$expandoDecls

extension CustomCaches on $cachesRef {
$getters
}
''';
      }),
    );

    return library.build();
  }

  String _cachePath(CacheDefinition cache) {
    if (cache.filePath.startsWith('package:')) return cache.filePath;

    var relativePath = p.relative(
      cache.filePath,
      from: _buildGeneratedDirectoryPath(),
    );

    return p.split(relativePath).join('/');
  }
}
