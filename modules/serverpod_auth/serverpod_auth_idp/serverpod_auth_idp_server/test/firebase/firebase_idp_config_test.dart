import 'package:serverpod_auth_idp_server/providers/firebase.dart';
import 'package:test/test.dart';

void main() {
  group('Given account details with an unverified email', () {
    late FirebaseAccountDetails accountDetails;

    setUp(() {
      accountDetails = _createAccountDetails(
        email: 'test@example.com',
        verifiedEmail: false,
      );
    });

    test(
      'when applying the default validation then the details are accepted',
      () {
        expect(
          () => FirebaseIdpConfig.validateFirebaseAccountDetails(
            accountDetails,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'when applying the requireVerifiedEmail validation then it throws a '
      'FirebaseEmailNotVerifiedException',
      () {
        expect(
          () => FirebaseIdpConfig.requireVerifiedEmail(accountDetails),
          throwsA(isA<FirebaseEmailNotVerifiedException>()),
        );
      },
    );
  });

  group('Given account details with an email whose verification status is '
      'unknown', () {
    late FirebaseAccountDetails accountDetails;

    setUp(() {
      accountDetails = _createAccountDetails(
        email: 'test@example.com',
        verifiedEmail: null,
      );
    });

    test(
      'when applying the default validation then the details are accepted',
      () {
        expect(
          () => FirebaseIdpConfig.validateFirebaseAccountDetails(
            accountDetails,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'when applying the requireVerifiedEmail validation then it throws a '
      'FirebaseEmailNotVerifiedException',
      () {
        expect(
          () => FirebaseIdpConfig.requireVerifiedEmail(accountDetails),
          throwsA(isA<FirebaseEmailNotVerifiedException>()),
        );
      },
    );
  });

  group('Given account details with a verified email', () {
    late FirebaseAccountDetails accountDetails;

    setUp(() {
      accountDetails = _createAccountDetails(
        email: 'test@example.com',
        verifiedEmail: true,
      );
    });

    test(
      'when applying the default validation then the details are accepted',
      () {
        expect(
          () => FirebaseIdpConfig.validateFirebaseAccountDetails(
            accountDetails,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'when applying the requireVerifiedEmail validation then the details '
      'are accepted',
      () {
        expect(
          () => FirebaseIdpConfig.requireVerifiedEmail(accountDetails),
          returnsNormally,
        );
      },
    );
  });

  group('Given account details without an email', () {
    late FirebaseAccountDetails accountDetails;

    setUp(() {
      accountDetails = _createAccountDetails(phone: '+1234567890');
    });

    test(
      'when applying the default validation then the details are accepted',
      () {
        expect(
          () => FirebaseIdpConfig.validateFirebaseAccountDetails(
            accountDetails,
          ),
          returnsNormally,
        );
      },
    );

    test(
      'when applying the requireVerifiedEmail validation then the details '
      'are accepted',
      () {
        expect(
          () => FirebaseIdpConfig.requireVerifiedEmail(accountDetails),
          returnsNormally,
        );
      },
    );
  });
}

FirebaseAccountDetails _createAccountDetails({
  final String? email,
  final bool? verifiedEmail,
  final String? phone,
}) {
  return (
    userIdentifier: 'firebase-uid',
    email: email,
    fullName: null,
    image: null,
    verifiedEmail: verifiedEmail,
    phone: phone,
  );
}
