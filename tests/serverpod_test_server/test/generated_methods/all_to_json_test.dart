import 'package:serverpod_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class with only nullable fields without any of them defined when calling toJson then an empty map is returned.',
      () {
    var types = Types();

    var jsonMap = types.allToJson();

    expect(jsonMap, {});
  });

  test(
      'Given a class with only nullable fields with an int defined when calling toJson then the key and value is set.',
      () {
    var types = Types(anInt: 1);

    var jsonMap = types.allToJson();

    expect(jsonMap, {'anInt': 1});
  });
}
