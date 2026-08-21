import 'package:serverpod_cli/src/util/command_line_tools.dart';
import 'package:test/test.dart';

void main() {
  group('Given the arguments for `flutter create`', () {
    test('when no org is provided, then --org is omitted', () {
      expect(
        CommandLineTools.flutterCreateArguments(),
        equals(['create', '.']),
      );
    });

    test('when an org is provided, then it is passed as --org', () {
      expect(
        CommandLineTools.flutterCreateArguments(org: 'com.example'),
        equals(['create', '--org', 'com.example', '.']),
      );
    });
  });
}
