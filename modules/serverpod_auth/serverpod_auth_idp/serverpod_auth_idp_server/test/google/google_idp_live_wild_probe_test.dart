import 'dart:convert';
import 'dart:io';

import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

/// In-the-wild probe: drives the REAL, unmodified [GoogleIdpUtils.fetchAccountDetails]
/// against LIVE Google - real JWKS verification and a real `/oauth2/v3/userinfo`
/// call, no `MockClient` anywhere. The ID token is minted with the `gcloud` CLI;
/// the victim's access token is supplied directly, exactly as an attacker would
/// hand over a token their own OAuth app obtained. Tokens are held in memory only
/// and never printed (only masked identifiers reach stdout).
///
/// This is a probe, not part of the suite. It is inert unless run explicitly:
///
///   GOOGLE_LIVE_PROBE=1 dart test \
///     test/google/google_idp_live_wild_probe_test.dart -r expanded
///
/// Two modes:
///
///  * Mechanism (default): with no victim token supplied, the probe mints its own
///    access token via gcloud, so the ID token and the access token name the same
///    person. It proves the whole product pipeline runs against live Google and
///    that the identity it returns is the one carried by the ACCESS TOKEN's
///    userinfo response - the mechanism, not yet a cross-account takeover.
///
///  * Takeover (set GOOGLE_VICTIM_ACCESS_TOKEN to a victim's access token): the
///    attacker presents their OWN genuine ID token while the access token belongs
///    to the victim. A pre-fix server returns the VICTIM's account - the login is
///    taken over. This is the full advisory scenario. The token needs only the
///    `openid` and `email` scopes an ordinary "Sign in with Google" consent grants.
///
/// The test asserts the secure invariant, so its colour tells the story: run it
/// against the pre-fix code (revert the working-tree fix) with a victim token
/// and it FAILS - the red assertion is the takeover. Run it with the fix in
/// place and it PASSES, the mismatched pair rejected with
/// [GoogleIdTokenVerificationException].
void main() {
  if (Platform.environment['GOOGLE_LIVE_PROBE'] != '1') {
    test(
      'live Google probe',
      () {},
      skip: 'Set GOOGLE_LIVE_PROBE=1 to run this probe against live Google.',
    );
    return;
  }

  // The gcloud account that plays the signing-in user (its ID token is the one
  // this application verifies). Defaults to the active account.
  final attackerAccount = Platform.environment['GOOGLE_ATTACKER_ACCOUNT'];

  // The victim's access token, obtained by the attacker through their own OAuth
  // app (any client, any scope that yields `openid`+`email`). Supplying it
  // directly - rather than minting it here - mirrors the real attack, where the
  // server never sees how the token was acquired. When set against pre-fix code
  // it drives the takeover, which the secure invariant below turns into a
  // failing test.
  final victimAccessToken = Platform.environment['GOOGLE_VICTIM_ACCESS_TOKEN'];

  withServerpod('Given the real Google endpoints,', (
    final sessionBuilder,
    final endpoints,
  ) {
    test(
      'the login resolves only to the account named by the verified ID token, '
      'or is rejected - a supplied access token must never redirect it onto '
      'another account (checked live against Google).',
      () async {
        final session = sessionBuilder.build();

        // 1. A genuine, Google-signed ID token for the signing-in account. Its
        //    audience is whichever OAuth client gcloud belongs to; we pin the
        //    app's client_id to exactly that so real verification passes.
        final idToken = await _gcloud([
          'auth',
          'print-identity-token',
          ...?_accountArg(attackerAccount),
        ]);
        final idClaims = _jwtPayload(idToken);
        final clientId = idClaims['aud'] as String;
        final idTokenSub = idClaims['sub'] as String;

        // 2. The access token that rides alongside it. In takeover mode this is
        //    the victim's, supplied verbatim; otherwise the signing-in account's
        //    own token, minted here so the mechanism can run with one identity.
        final accessToken =
            victimAccessToken ??
            await _gcloud([
              'auth',
              'print-access-token',
              ...?_accountArg(attackerAccount),
            ]);

        final utils = GoogleIdpUtils(
          config: GoogleIdpConfig(
            clientSecret: GoogleClientSecret.fromJson({
              'web': {
                'client_id': clientId,
                'client_secret': 'unused-by-fetchAccountDetails',
                'redirect_uris': ['https://example.com/unused'],
              },
            }),
            googleAccountDetailsValidation: (final _) {},
          ),
          authUsers: const AuthUsers(),
        );

        // 3. The real product code, talking to real Google. No stubbed client.
        //    A patched server either resolves the login to the ID token's
        //    account or rejects the request; only a vulnerable server lets the
        //    access token redirect it onto another account.
        GoogleAccountDetails? details;
        GoogleIdTokenVerificationException? rejected;
        try {
          details = await utils.fetchAccountDetails(
            session,
            idToken: idToken,
            accessToken: accessToken,
          );
        } on GoogleIdTokenVerificationException catch (e) {
          rejected = e;
        }

        stdout.writeln('');
        stdout.writeln('=== live Google probe result ===');
        stdout.writeln('  verified ID token names : ${_mask(idTokenSub)}');
        stdout.writeln(
          '  login resolved to       : '
          '${rejected != null ? "<rejected>" : _mask(details!.userIdentifier)}',
        );
        if (details != null) {
          stdout.writeln('  email on resolved acct  : ${_mask(details.email)}');
        }
        stdout.writeln(
          '  mode                    : '
          '${victimAccessToken != null ? "takeover attempt (supplied victim access token)" : "mechanism (own access token)"}',
        );
        stdout.writeln('================================');

        // The login may resolve only to the account the verified ID token
        // names, or be rejected outright.
        if (rejected == null) {
          final matchesIdToken = details!.userIdentifier == idTokenSub;
          expect(
            matchesIdToken,
            isTrue,
            reason:
                'ACCOUNT TAKEOVER: the login resolved to '
                '${_mask(details.userIdentifier)}, which the verified ID token '
                '(${_mask(idTokenSub)}) does not name.',
          );
        }
      },
      timeout: const Timeout(Duration(minutes: 2)),
    );
  });
}

/// Runs `gcloud` and returns trimmed stdout, never surfacing the token on error.
Future<String> _gcloud(final List<String> args) async {
  for (final exe in const ['gcloud', '/usr/local/bin/gcloud']) {
    try {
      final result = await Process.run(exe, args);
      if (result.exitCode == 0) {
        return (result.stdout as String).trim();
      }
      throw StateError(
        'gcloud ${args.join(' ')} failed (${result.exitCode}): '
        '${(result.stderr as String).trim()}',
      );
    } on ProcessException {
      continue; // Try the next candidate path.
    }
  }
  throw StateError('gcloud executable not found on PATH.');
}

List<String>? _accountArg(final String? account) =>
    account == null ? null : ['--account', account];

/// Decodes a JWT payload without verifying it - used only to read `aud`/`sub`
/// for configuration and display. Never trust values read this way.
Map<String, dynamic> _jwtPayload(final String jwt) {
  final payload = jwt.split('.')[1];
  return jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(payload))))
      as Map<String, dynamic>;
}

/// Masks an identifier so nothing sensitive lands in test output.
String _mask(final String? value) {
  if (value == null) return 'null';
  if (value.contains('@')) {
    final parts = value.split('@');
    final local = parts.first;
    return '${local.substring(0, local.length.clamp(0, 2))}***@${parts.last}';
  }
  if (value.length <= 8) return value;
  return '${value.substring(0, 4)}...${value.substring(value.length - 2)} '
      '(len ${value.length})';
}
