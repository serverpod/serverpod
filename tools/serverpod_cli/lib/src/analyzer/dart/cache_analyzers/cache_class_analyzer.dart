import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';

/// Analyzes dart classes to see if they extend [Cache].
class CacheClassAnalyzer {
  /// Parses a [ClassElement] into a [CacheDefinition].
  static void parse(
    ClassElement classElement,
    String filePath,
    List<CacheDefinition> customCaches,
  ) {
    if (!isCacheClass(classElement)) {
      return;
    }

    var className = classElement.name;
    if (className == null) return;
    var name = className.camelCase;

    customCaches.add(
      CacheDefinition(
        name: name,
        className: className,
        filePath: filePath,
      ),
    );
  }

  /// Returns true if the [ClassElement] is a class that extends [Cache].
  static bool isCacheClass(ClassElement classElement) {
    if (classElement.isAbstract) {
      return false;
    }

    // Skip built-in caches.
    if (classElement.name == 'Cache' ||
        classElement.name == 'LocalCache' ||
        classElement.name == 'DistributedCache' ||
        classElement.name == 'RedisCache' ||
        classElement.name == 'GlobalCache') {
      return false;
    }

    return _implementsCacheType(classElement.thisType);
  }

  static bool _implementsCacheType(InterfaceType type) {
    if (type.element.name == 'Cache' &&
        type.element.library.identifier ==
            'package:serverpod/src/cache/cache.dart') {
      return true;
    }
    if (type.element.name == 'DistributedCache' ||
        type.element.name == 'LocalCache') {
      if (type.element.library.identifier.startsWith('package:serverpod/')) {
        return true;
      }
    }

    for (var interface in type.interfaces) {
      if (_implementsCacheType(interface)) {
        return true;
      }
    }

    if (type.superclass != null) {
      if (_implementsCacheType(type.superclass!)) {
        return true;
      }
    }

    return false;
  }
}
