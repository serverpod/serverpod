import 'package:serverpod/serverpod.dart';

class MethodSignaturePermutationsEndpoint extends Endpoint {
  Future<String> echoPositionalArg(
    Session session,
    String string,
  ) async {
    return string;
  }

  Future<String> echoNamedArg(
    Session session, {
    required String string,
  }) async {
    return string;
  }

  Future<String?> echoNullableNamedArg(
    Session session, {
    String? string,
  }) async {
    return string;
  }

  Future<String?> echoOptionalArg(
    Session session, [
    String? string,
  ]) async {
    return string;
  }

  Future<List<String?>> echoPositionalAndNamedArgs(
    Session session,
    String string1, {
    required String string2,
  }) async {
    return [string1, string2];
  }

  Future<List<String?>> echoPositionalAndNullableNamedArgs(
    Session session,
    String string1, {
    String? string2,
  }) async {
    return [string1, string2];
  }

  Future<List<String?>> echoPositionalAndOptionalArgs(
      Session session, String string1,
      [String? string2]) async {
    return [string1, string2];
  }

  Stream<String> echoNamedArgStream(
    Session session, {
    required Stream<String> strings,
  }) async* {
    await for (var string in strings) {
      yield string;
    }
  }

  Future<String> echoNamedArgStreamAsFuture(
    Session session, {
    required Stream<String> strings,
  }) async {
    return strings.first;
  }

  Stream<String> echoPositionalArgStream(
      Session session, Stream<String> strings) async* {
    await for (var string in strings) {
      yield string;
    }
  }

  Future<String> echoPositionalArgStreamAsFuture(
      Session session, Stream<String> strings) async {
    return strings.first;
  }
}
