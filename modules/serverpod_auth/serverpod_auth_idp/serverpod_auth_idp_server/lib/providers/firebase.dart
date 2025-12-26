/// This library contains the Firebase authentication provider for the
/// Serverpod Idp module.
library;

export 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;

export '../src/generated/protocol.dart'
    show FirebaseAccount, FirebaseIdTokenVerificationException;
export '../src/providers/firebase/business/firebase_idp.dart';
export '../src/providers/firebase/business/firebase_idp_admin.dart';
export '../src/providers/firebase/business/firebase_idp_config.dart';
export '../src/providers/firebase/business/firebase_idp_token_verifier.dart'
    show FirebaseIdTokenValidationServerException;
export '../src/providers/firebase/business/firebase_idp_utils.dart';
export '../src/providers/firebase/business/firebase_service_account_credentials.dart';
export '../src/providers/firebase/endpoints/firebase_idp_base_endpoint.dart';
