import 'package:passkeys_server/passkeys_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_passkey_account_server/serverpod_auth_passkey_account_server.dart';

/// Passkey account management functions
abstract final class PasskeyAccounts {
  /// Administrative methods for working with Passkey-backed accounts.
  // static late PasskeyAccountsAdmin admin;

  static late PasskeyAccountConfig _config;
  static late Passkeys _passkeys;

  /// Sets the configuration and configures the underlying utilities.
  ///
  /// This must be set before any methods on this class are invoked.
  set config(final PasskeyAccountConfig config) {
    _config = config;

    _passkeys = Passkeys(
      config: PasskeysConfig(
        relyingPartyId: config.hostname,
      ),
      storage: InMemoryPasskeyStorage(),
    );

    // admin = PasskeyAccountsAdmin(_config, _passkeys);
  }

  /// Returns the current configuration.
  PasskeyAccountConfig get config => _config;

  // TODO return AuthSuccess
  static Future<void> registerPasskey(Session session) async {
    // _passkeys.verifyRegistration(
    //   userId: userId,
    //   keyId: keyId,
    //   clientDataJSON: clientDataJSON,
    //   publicKey: publicKey,
    //   publicKeyAlgorithm: publicKeyAlgorithm,
    //   attestationObject: attestationObject,
    //   authenticatorData: authenticatorData,
    // );
    //   originalChallenge:
  }
}
