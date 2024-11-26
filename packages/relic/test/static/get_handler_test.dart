import 'package:path/path.dart' as p;
import 'package:relic/relic.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

void main() {
  setUp(() async {
    await d.file('root.txt', 'root txt').create();
    await d.dir('files', [
      d.file('test.txt', 'test txt content'),
      d.file('with space.txt', 'with space content')
    ]).create();
  });

  test(
      'Given a non-existent relative path when creating a static handler then it throws an ArgumentError',
      () async {
    expect(() => createStaticHandler('random/relative'), throwsArgumentError);
  });

  test(
      'Given an existing relative path when creating a static handler then it returns normally',
      () async {
    final existingRelative = p.relative(d.sandbox);
    expect(() => createStaticHandler(existingRelative), returnsNormally);
  });

  test(
      'Given a non-existent absolute path when creating a static handler then it throws an ArgumentError',
      () {
    final nonExistingAbsolute = p.join(d.sandbox, 'not_here');
    expect(() => createStaticHandler(nonExistingAbsolute), throwsArgumentError);
  });

  test(
      'Given an existing absolute path when creating a static handler then it returns normally',
      () {
    expect(() => createStaticHandler(d.sandbox), returnsNormally);
  });
}
