import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:serverpod_auth_idp_flutter/src/email/email_otp_auth_controller.dart'
    show OtpLoginRejectedException;
import 'package:serverpod_auth_idp_flutter/src/common/exceptions.dart';
import 'package:serverpod_auth_idp_flutter/src/email/email_auth_exceptions.dart';

void main() {
  // Account request errors are also raised by the passwordless sign-in, so
  // their messages must not assume a registration.
  for (final reason in [
    EmailAccountRequestExceptionReason.tooManyAttempts,
    EmailAccountRequestExceptionReason.unknown,
  ]) {
    test(
      'Given an EmailAccountRequestException with reason "${reason.name}", '
      'when converting it to a user facing exception, '
      'then the message does not mention registration.',
      () {
        final userFacing = convertToUserFacingException(
          EmailAccountRequestException(reason: reason),
        );

        expect(userFacing.toString(), isNot(contains('registration')));
      },
    );
  }

  test(
    'Given an OtpLoginRejectedException, '
    'when converting it to a user facing exception, '
    'then the user is asked to request a new code.',
    () {
      final userFacing = convertToUserFacingException(
        OtpLoginRejectedException(
          EmailAccountRequestException(
            reason: EmailAccountRequestExceptionReason.invalid,
          ),
        ),
      );

      expect(userFacing, isA<UserFacingException>());
      expect(userFacing.toString(), contains('request a new code'));
    },
  );
}
