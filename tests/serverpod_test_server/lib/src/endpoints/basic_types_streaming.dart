import 'dart:typed_data';

import 'package:serverpod/serverpod.dart';

class BasicTypesStreamingEndpoint extends Endpoint {
  Stream<int?> testInt(Session session, Stream<int?> value) async* {
    await for (var v in value) {
      yield v;
    }
  }

  Stream<double?> testDouble(Session session, Stream<double?> value) async* {
    await for (var v in value) {
      yield v;
    }
  }

  Stream<bool?> testBool(Session session, Stream<bool?> value) async* {
    await for (var v in value) {
      yield v;
    }
  }

  Stream<DateTime?> testDateTime(
      Session session, Stream<DateTime?> value) async* {
    await for (var v in value) {
      yield v;
    }
  }

  Stream<String?> testString(Session session, Stream<String?> value) async* {
    await for (var v in value) {
      yield v;
    }
  }

  Stream<ByteData?> testByteData(
      Session session, Stream<ByteData?> value) async* {
    await for (var v in value) {
      yield v;
    }
  }

  Stream<Duration?> testDuration(
      Session session, Stream<Duration?> value) async* {
    await for (var v in value) {
      yield v;
    }
  }

  Stream<UuidValue?> testUuid(
      Session session, Stream<UuidValue?> value) async* {
    await for (var v in value) {
      yield v;
    }
  }

  Stream<Uri?> testUri(Session session, Stream<Uri?> value) async* {
    await for (var v in value) {
      yield v;
    }
  }

  Stream<BigInt?> testBigInt(Session session, Stream<BigInt?> value) async* {
    await for (var v in value) {
      yield v;
    }
  }
}
