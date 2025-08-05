import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:test/test.dart';

void main() {
  group('Given a `Bearer` authorization header,', () {
    const key =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTnFmyG3nMiGM6H9FNFUROf3wh7SmqJp-QV30';
    final header = wrapAsBearerTokenAuthHeaderValue(key);

    test(
        'when reading it via `unwrapAuthHeaderValue`, then the original key is returned.',
        () {
      final receivedAuthKey = unwrapAuthHeaderValue(header);

      expect(receivedAuthKey, key);
    });
  });
}
