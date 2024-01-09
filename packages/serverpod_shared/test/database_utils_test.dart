import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given an identifier that is shorter than max length when truncating then the identifier is returned.',
      () {
    var identifier = '123456789';

    var truncated = truncateIdentifier(identifier, 9);

    expect(truncated, identifier);
  });

  test(
      'Given an identifier that is longer than max length when truncating then identifier is truncated and hashed.',
      () {
    var identifier = '123456789';

    var truncated = truncateIdentifier(identifier, 8);

    expect(truncated, '123415e2');
  });

  test(
      'Given hash length longer than max length when truncating then an argument error is thrown.',
      () {
    var identifier = '123456789';
    var maxLength = 8;
    var hashLength = 9;

    expect(
      () => truncateIdentifier(identifier, maxLength, hashLength: hashLength),
      throwsArgumentError,
    );
  });

  test(
      'Given hash length equal to max length when truncating then full string is replaced with hash',
      () {
    var identifier = '0123456789';
    var maxLength = 8;
    var hashLength = 8;

    var truncated =
        truncateIdentifier(identifier, maxLength, hashLength: hashLength);

    expect(truncated, '84d89877');
  });

  test(
      'Given hash length longer than max length when truncating then an argument error is thrown.',
      () {
    var identifier =
        '0123456789012345678901234567890123456789012345678901234567890123456789';
    // The hash used in the algorithm is 64 chars
    var hashLength = 65;

    var truncated = truncateIdentifier(identifier, 66, hashLength: hashLength);

    expect(truncated,
        '01257445fa40b08c60cdcba7ca39c756de614d11482e3f15a925f548688c19e58f');
  });
}
