import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';

void main() {
  Client client = Client('http://localhost:8080/');

  setUp(() {
  });

  test('Simple calls', () async {
    await client.simple.setGlobalInt(10);
    await client.simple.addToGlobalInt();
    int value = await client.simple.getGlobalInt();
    expect(value, equals(11));
  });

  test('Type int', () async {
    int result = await client.basicTypes.testInt(10);
    expect(result, equals(10));
  });

  test('Type null int', () async {
    int result = await client.basicTypes.testInt(null);
    expect(result, isNull);
  });

  test('Type double', () async {
    double result = await client.basicTypes.testDouble(10.0);
    expect(result, equals(10.0));
  });

  test('Type null double', () async {
    double result = await client.basicTypes.testDouble(null);
    expect(result, isNull);
  });

  test('Type String', () async {
    String result = await client.basicTypes.testString('test');
    expect(result, 'test');
  });

  test('Type String with value \'null\'', () async {
    String result = await client.basicTypes.testString('null');
    expect(result, 'null');
  });

  test('Type null String', () async {
    String result = await client.basicTypes.testString(null);
    expect(result, isNull);
  });

//  test('Type List<int>', () async {
//    List<int> result = await client.basicTypes.testIntList([1, 2, 3]);
//    expect(result, equals([1, 2, 3]));
//  });
}