import 'package:expect_error/expect_error.dart';

import 'package:test/test.dart';

void main() async {
  var library = await Library.parseFromStacktrace();

  group('Test serverOnly', () {
    test('Ensure DefaultServerOnlyClass is available', () async {
      await expectLater(library.withCode('''
import 'package:serverpod_test_server/src/generated/protocol.dart';

late DefaultServerOnlyClass test;
'''), compiles);
    });
    test('Ensure NotServerOnlyClass is available', () async {
      await expectLater(library.withCode('''
import 'package:serverpod_test_server/src/generated/protocol.dart';

late NotServerOnlyClass test;
'''), compiles);
    });
    test('Ensure ServerOnlyClass is available', () async {
      await expectLater(library.withCode('''
import 'package:serverpod_test_server/src/generated/protocol.dart';

late ServerOnlyClass test;
'''), compiles);
    });
    test('Ensure DefaultServerOnlyEnum is available', () async {
      await expectLater(library.withCode('''
import 'package:serverpod_test_server/src/generated/protocol.dart';

late DefaultServerOnlyEnum test;
'''), compiles);
    });
    test('Ensure NotServerOnlyEnum is available', () async {
      await expectLater(library.withCode('''
import 'package:serverpod_test_server/src/generated/protocol.dart';

late NotServerOnlyEnum test;
'''), compiles);
    });
    test('Ensure ServerOnlyEnum is available', () async {
      await expectLater(library.withCode('''
import 'package:serverpod_test_server/src/generated/protocol.dart';

late ServerOnlyEnum test;
'''), compiles);
    });
  });
}
