import 'package:serverpod_auth_2/providers/google/google_account_repository.dart';
import 'package:serverpod_auth_2/serverpod/serverpod.dart';

class GoogleSsoEndpoint {
  GoogleSsoEndpoint(Serverpod serverpod)
      : googleAccountRepository = GoogleAccountRepository(serverpod: serverpod);

  final GoogleAccountRepository googleAccountRepository;

  Uri getSignInEntryUri() {
    return googleAccountRepository.getSignInEntryUri();
  }

  String createSessionFromToken(String googleToken) {
    // This would be the place to modify the behavior, e.g. look up existing users (by email) and then link the Google account to the existing one
    // For that the `GoogleAccountRepository` might just create an internal entry for storing the Google Account ID <> User ID link, and leave the
    // user and session creation to the higher level / developer-written endpoint

    return googleAccountRepository.createSessionFromToken(googleToken);
  }
}
