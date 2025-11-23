import 'package:test_descriptor/test_descriptor.dart' as d;

/// Creates a mock Serverpod server directory descriptor
d.DirectoryDescriptor serverDir(String name) {
  return d.dir(name, [
    d.file('pubspec.yaml', '''
name: $name
dependencies:
  serverpod: ^2.0.0
'''),
  ]);
}

/// Creates a mock non-server directory descriptor
d.DirectoryDescriptor nonServerDir(String name) {
  return d.dir(name, [
    d.file('pubspec.yaml', '''
name: $name
dependencies:
  http: ^1.0.0
'''),
  ]);
}
