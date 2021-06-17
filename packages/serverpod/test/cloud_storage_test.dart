import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';

ByteData createByteData(int len) {
  var ints = Uint8List(len);
  for (var i = 0; i < len; i++) {
    ints[i] = i % len;
  }
  return ByteData.view(ints.buffer);
}

bool verifyByteData(ByteData byteData) {
  var ints = byteData.buffer.asUint8List();
  for (var i in ints) {
    if (ints[i] != i % byteData.lengthInBytes)
      return false;
  }
  return true;
}

void main() {
  var client = Client('http://localhost:8080/');

  setUp(() {
  });

  group('Database cloud storage', () {
    test('Store file 1', () async {
      await client.cloudStorage.storePublicFile('testdir/myfile1.bin', createByteData(256));
    });

    test('Store file 2', () async {
      await client.cloudStorage.storePublicFile('testdir/myfile2.bin', createByteData(256));
    });

    test('Replace file 1', () async {
      await client.cloudStorage.storePublicFile('testdir/myfile1.bin', createByteData(128));
    });

    test('Retrieve file 1', () async {
      var byteData = await client.cloudStorage.retrievePublicFile('testdir/myfile1.bin');
      expect(byteData!.lengthInBytes, equals(128));
      expect(verifyByteData(byteData), equals(true));
    });

    test('Retrieve file 2', () async {
      var byteData = await client.cloudStorage.retrievePublicFile('testdir/myfile2.bin');
      expect(byteData!.lengthInBytes, equals(256));
      expect(verifyByteData(byteData), equals(true));
    });

    test('Retrieve non existing file', () async {
      var byteData = await client.cloudStorage.retrievePublicFile('testdir/myfile3.bin');
      expect(byteData, isNull);
    });

    test('Exists file 1', () async {
      var exists = await client.cloudStorage.existsPublicFile('testdir/myfile1.bin');
      expect(exists, true);
    });

    test('Exists non existing file', () async {
      var exists = await client.cloudStorage.existsPublicFile('testdir/myfile3.bin');
      expect(exists, false);
    });

    test('Delete file 1', () async {
      await client.cloudStorage.deletePublicFile('testdir/myfile1.bin');
    });

    test('Exists file 1 after deletion', () async {
      var exists = await client.cloudStorage.existsPublicFile('testdir/myfile1.bin');
      expect(exists, false);
    });
  });
}