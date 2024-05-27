import 'dart:convert';

/// Base class for all Firebase exceptions.
class FirebaseException implements Exception {
  /// Error codes are strings using the following format:
  /// "service/string-code". Some examples include "auth/invalid-uid" and
  /// "messaging/invalid-recipient".
  ///
  /// While the message for a given error can change, the code will remain the
  /// same between backward-compatible versions of the Firebase SDK.
  final String code;

  /// An explanatory message for the error that just occurred.
  ///
  /// This message is designed to be helpful to you, the developer. Because it
  /// generally does not convey meaningful information to end users, this
  /// message should not be displayed in your application.
  final String message;

  FirebaseException({required this.code, required this.message});

  Map<String, dynamic> toJson() => {'code': code, 'message': message};

  @override
  String toString() => '$runtimeType($code): $message';
}

/// A FirebaseError with a prefix in front of the error code.
class _PrefixedFirebaseError extends FirebaseException {
  final String codePrefix;

  _PrefixedFirebaseError(this.codePrefix, String code, String message)
      : super(
          code: '$codePrefix/$code',
          message: message,
        );
}

class FirebaseAppError extends _PrefixedFirebaseError {
  FirebaseAppError(String code, String message) : super('app', code, message);

  FirebaseAppError.appDeleted(String message) : this('app-deleted', message);
  FirebaseAppError.duplicateApp(String message)
      : this('duplicate-app', message);
  FirebaseAppError.internalError(String message)
      : this('internal-error', message);
  FirebaseAppError.invalidAppName(String message)
      : this('invalid-app-name', message);
  FirebaseAppError.invalidAppOptions(String message)
      : this('invalid-app-options', message);
  FirebaseAppError.invalidCredential(String message)
      : this('invalid-credential', message);
  FirebaseAppError.networkError(String message)
      : this('network-error', message);
  FirebaseAppError.networkTimeout(String message)
      : this('network-timeout', message);
  FirebaseAppError.noApp(String message) : this('no-app', message);
  FirebaseAppError.unableToParseResponse(String message)
      : this('unable-to-parse-response', message);
}

class FirebaseAuthError extends _PrefixedFirebaseError {
  /// Creates the developer-facing error corresponding to the backend error code.
  factory FirebaseAuthError.fromServerError(
    String serverErrorCode, [
    String? message,
    dynamic rawServerResponse,
  ]) {
    // serverErrorCode could contain additional details:
    // ERROR_CODE : Detailed message which can also contain colons
    final colonSeparator = serverErrorCode.indexOf(':');
    String? customMessage;
    if (colonSeparator != -1) {
      customMessage = serverErrorCode.substring(colonSeparator + 1).trim();
      serverErrorCode = serverErrorCode.substring(0, colonSeparator).trim();
    }

    customMessage ??= message;
    // If not found, default to internal error.
    switch (serverErrorCode) {
      case 'CLAIMS_TOO_LARGE':
        // Claims payload is too large.
        return FirebaseAuthError.claimsTooLarge(customMessage);
      case 'CONFIGURATION_NOT_FOUND':
        // Project not found.
        return FirebaseAuthError.projectNotFound(customMessage);
      case 'INSUFFICIENT_PERMISSION':
        // Provided credential has insufficient permissions.
        return FirebaseAuthError.insufficientPermission(customMessage);
      case 'INVALID_CONTINUE_URI':
        // ActionCodeSettings missing continue URL.
        return FirebaseAuthError.invalidContinueUri(customMessage);
      case 'INVALID_DYNAMIC_LINK_DOMAIN':
        // Dynamic link domain in provided ActionCodeSettings is not authorized.
        return FirebaseAuthError.invalidDynamicLinkDomain(customMessage);
      case 'DUPLICATE_EMAIL':
        // uploadAccount provides an email that already exists.
        return FirebaseAuthError.emailAlreadyExists(customMessage);
      case 'DUPLICATE_LOCAL_ID':
        // uploadAccount provides a localId that already exists.
        return FirebaseAuthError.uidAlreadyExists(customMessage);
      case 'EMAIL_EXISTS':
        // setAccountInfo email already exists.
        return FirebaseAuthError.emailAlreadyExists(customMessage);
      case 'FORBIDDEN_CLAIM':
        // Reserved claim name.
        return FirebaseAuthError.forbiddenClaim(customMessage);
      case 'INVALID_CLAIMS':
        // Invalid claims provided.
        return FirebaseAuthError.invalidClaims(customMessage);
      case 'INVALID_DURATION':
        // Invalid session cookie duration.
        return FirebaseAuthError.invalidSessionCookieDuration(customMessage);
      case 'INVALID_EMAIL':
        // Invalid email provided.
        return FirebaseAuthError.invalidEmail(customMessage);
      case 'INVALID_ID_TOKEN':
        // Invalid ID token provided.
        return FirebaseAuthError.invalidIdToken(customMessage);
      case 'INVALID_PAGE_SELECTION':
        // Invalid page token.
        return FirebaseAuthError.invalidPageToken(customMessage);
      case 'INVALID_PHONE_NUMBER':
        // Invalid phone number.
        return FirebaseAuthError.invalidPhoneNumber(customMessage);
      case 'INVALID_SERVICE_ACCOUNT':
        // Invalid service account.
        return FirebaseAuthError.invalidServiceAccount(customMessage);
      case 'MISSING_ANDROID_PACKAGE_NAME':
        // Missing Android package name.
        return FirebaseAuthError.missingAndroidPackageName(customMessage);
      case 'MISSING_IOS_BUNDLE_ID':
        // Missing iOS bundle ID.
        return FirebaseAuthError.missingIosBundleId(customMessage);
      case 'MISSING_LOCAL_ID':
        // No localId provided (deleteAccount missing localId).
        return FirebaseAuthError.missingUid(customMessage);
      case 'MISSING_USER_ACCOUNT':
        // Empty user list in uploadAccount.
        return FirebaseAuthError.missingUid(customMessage);
      case 'OPERATION_NOT_ALLOWED':
        // Password auth disabled in console.
        return FirebaseAuthError.operationNotAllowed(customMessage);
      case 'PERMISSION_DENIED':
        // Provided credential has insufficient permissions.
        return FirebaseAuthError.insufficientPermission(customMessage);
      case 'PHONE_NUMBER_EXISTS':
        // Phone number already exists.
        return FirebaseAuthError.phoneNumberAlreadyExists(customMessage);
      case 'PROJECT_NOT_FOUND':
        // Project not found.
        return FirebaseAuthError.projectNotFound(customMessage);
      case 'TOKEN_EXPIRED':
        // Token expired error.
        return FirebaseAuthError.idTokenExpired(customMessage);
      case 'UNAUTHORIZED_DOMAIN':
        // Continue URL provided in ActionCodeSettings has a domain that is not whitelisted.
        return FirebaseAuthError.unauthorizedDomain(customMessage);
      case 'USER_NOT_FOUND':
        // User on which action is to be performed is not found.
        return FirebaseAuthError.userNotFound(customMessage);
      case 'WEAK_PASSWORD':
        // Password provided is too weak.
        return FirebaseAuthError.invalidPassword(customMessage);
    }

    return FirebaseAuthError.internalError(customMessage, rawServerResponse);
  }

  /// The claims payload provided to [setCustomUserClaims] exceeds the maximum
  /// allowed size of 1000 bytes.
  FirebaseAuthError.claimsTooLarge([String? message])
      : this('claims-too-large',
            message ?? 'Developer claims maximum payload size exceeded.');

  /// The provided email is already in use by an existing user. Each user must
  /// have a unique email.
  FirebaseAuthError.emailAlreadyExists([String? message])
      : this(
            'email-already-exists',
            message ??
                'The email address is already in use by another account.');

  /// The provided Firebase ID token is expired.
  FirebaseAuthError.idTokenExpired([String? message])
      : this('id-token-expired',
            message ?? 'The provided Firebase ID token is expired.');

  /// The Firebase ID token has been revoked.
  FirebaseAuthError.idTokenRevoked([String? message])
      : this('id-token-revoked',
            message ?? 'The Firebase ID token has been revoked.');

  /// The credential used to initialize the Admin SDK has insufficient
  /// permission to access the requested Authentication resource.
  ///
  /// Refer to Set up a Firebase project for documentation on how to generate a
  /// credential with appropriate permissions and use it to authenticate the
  /// Admin SDKs.
  FirebaseAuthError.insufficientPermission([String? message])
      : this(
            'insufficient-permission',
            message ??
                'Credential implementation provided to initializeApp() via the '
                    '"credential" property has insufficient permission to '
                    'access the requested resource. See '
                    'https://firebase.google.com/docs/admin/setup for details '
                    'on how to authenticate this SDK with appropriate '
                    'permissions.');

  /// The Authentication server encountered an unexpected error while trying to
  /// process the request.
  ///
  /// The error message should contain the response from the Authentication
  /// server containing additional information. If the error persists, please
  /// report the problem to our Bug Report support channel.
  FirebaseAuthError.internalError([String? message, rawServerResponse])
      : this('internal-error',
            '${message ?? 'An internal error has occurred.'}Raw server response: "${json.encode(rawServerResponse)}"');

  /// An invalid argument was provided to an Authentication method.
  ///
  /// The error message should contain additional information.
  FirebaseAuthError.invalidArgument([String? message])
      : this('argument-error', message ?? 'Invalid argument provided.');

  /// The custom claim attributes provided to setCustomUserClaims() are invalid.
  FirebaseAuthError.invalidClaims([String? message])
      : this('invalid-claims',
            message ?? 'The provided custom claim attributes are invalid.');

  /// The continue URL must be a valid URL string.
  FirebaseAuthError.invalidContinueUri([String? message])
      : this('invalid-continue-uri',
            message ?? 'The continue URL must be a valid URL string.');

  /// The creation time must be a valid UTC date string.
  FirebaseAuthError.invalidCreationTime([String? message])
      : this('invalid-creation-time',
            message ?? 'The creation time must be a valid UTC date string.');

  /// The credential used to authenticate the Admin SDKs cannot be used to
  /// perform the desired action.
  ///
  /// Certain Authentication methods such as [createCustomToken] and
  /// [verifyIdToken] require the SDK to be initialized with a certificate
  /// credential as opposed to a refresh token or Application Default
  /// credential.
  ///
  /// See Initialize the SDK for documentation on how to authenticate the Admin
  /// SDKs with a certificate credential.
  FirebaseAuthError.invalidCredential([String? message])
      : this('invalid-credential',
            message ?? 'Invalid credential object provided.');

  /// The provided value for the disabled user property is invalid. It must be a
  /// boolean.
  FirebaseAuthError.invalidDisabledField([String? message])
      : this('invalid-disabled-field',
            message ?? 'The disabled field must be a boolean.');

  /// The provided value for the displayName user property is invalid. It must
  /// be a non-empty string.
  FirebaseAuthError.invalidDisplayName([String? message])
      : this('invalid-display-name',
            message ?? 'The displayName field must be a valid string.');

  /// The provided dynamic link domain is not configured or authorized for the
  /// current project.
  FirebaseAuthError.invalidDynamicLinkDomain([String? message])
      : this(
            'invalid-dynamic-link-domain',
            message ??
                'The provided dynamic link domain is not configured or authorized '
                    'for the current project.');

  /// The provided value for the email user property is invalid. It must be a
  /// string email address.
  FirebaseAuthError.invalidEmail([String? message])
      : this('invalid-email',
            message ?? 'The email address is improperly formatted.');

  /// The provided value for the emailVerified user property is invalid. It must
  /// be a boolean.
  FirebaseAuthError.invalidEmailVerified([String? message])
      : this('invalid-email-verified',
            message ?? 'The emailVerified field must be a boolean.');

  /// The hash algorithm must match one of the strings in the list of supported
  /// algorithms.
  FirebaseAuthError.invalidHashAlgorithm([String? message])
      : this(
            'invalid-hash-algorithm',
            message ??
                'The hash algorithm must match one of the strings in the list of '
                    'supported algorithms.');

  /// The hash block size must be a valid number.
  FirebaseAuthError.invalidHashBlockSize([String? message])
      : this('invalid-hash-block-size',
            message ?? 'The hash block size must be a valid number.');

  /// The hash derived key length must be a valid number.
  FirebaseAuthError.invalidHashDerivedKeyLength([String? message])
      : this('invalid-hash-derived-key-length',
            message ?? 'The hash derived key length must be a valid number.');

  /// The hash key must a valid byte buffer.
  FirebaseAuthError.invalidHashKey([String? message])
      : this('invalid-hash-key',
            message ?? 'The hash key must a valid byte buffer.');

  /// The hash memory cost must be a valid number.
  FirebaseAuthError.invalidHashMemoryCost([String? message])
      : this('invalid-hash-memory-cost',
            message ?? 'The hash memory cost must be a valid number.');

  /// The hash parallelization must be a valid number.
  FirebaseAuthError.invalidHashParallelization([String? message])
      : this('invalid-hash-parallelization',
            message ?? 'The hash parallelization must be a valid number.');

  /// The hash rounds must be a valid number.
  FirebaseAuthError.invalidHashRounds([String? message])
      : this('invalid-hash-rounds',
            message ?? 'The hash rounds must be a valid number.');

  /// The hashing algorithm salt separator field must be a valid byte buffer.
  FirebaseAuthError.invalidHashSaltSeparator([String? message])
      : this(
            'invalid-hash-salt-separator',
            message ??
                'The hashing algorithm salt separator field must be a valid byte buffer.');

  /// The provided ID token is not a valid Firebase ID token.
  FirebaseAuthError.invalidIdToken([String? message])
      : this(
            'invalid-id-token',
            message ??
                'The provided ID token is not a valid Firebase ID token.');

  /// The last sign-in time must be a valid UTC date string.
  FirebaseAuthError.invalidLastSignInTime([String? message])
      : this(
            'invalid-last-sign-in-time',
            message ??
                'The last sign-in time must be a valid UTC date string.');

  /// The provided next page token in listUsers() is invalid. It must be a valid
  /// non-empty string.
  FirebaseAuthError.invalidPageToken([String? message])
      : this('invalid-page-token',
            message ?? 'The page token must be a valid non-empty string.');

  /// The provided value for the password user property is invalid. It must be a
  /// string with at least six characters.
  FirebaseAuthError.invalidPassword([String? message])
      : this(
            'invalid-password',
            message ??
                'The password must be a string with at least 6 characters.');

  /// The password hash must be a valid byte buffer.
  FirebaseAuthError.invalidPasswordHash([String? message])
      : this('invalid-password-hash',
            message ?? 'The password hash must be a valid byte buffer.');

  /// The password salt must be a valid byte buffer
  FirebaseAuthError.invalidPasswordSalt([String? message])
      : this('invalid-password-salt',
            message ?? 'The password salt must be a valid byte buffer.');

  /// The provided value for the phoneNumber is invalid. It must be a non-empty
  /// E.164 standard compliant identifier string.
  FirebaseAuthError.invalidPhoneNumber([String? message])
      : this(
            'invalid-phone-number',
            message ??
                'The phone number must be a non-empty E.164 standard compliant identifier '
                    'string.');

  /// Invalid service account.
  FirebaseAuthError.invalidServiceAccount([String? message])
      : this('invalid-service-account', message ?? 'Invalid service account.');

  /// The provided value for the photoURL user property is invalid. It must be a
  /// string URL.
  FirebaseAuthError.invalidPhotoUrl([String? message])
      : this('invalid-photo-url',
            message ?? 'The photoURL field must be a valid URL.');

  /// The providerData must be a valid array of UserInfo objects.
  FirebaseAuthError.invalidProviderData([String? message])
      : this(
            'invalid-provider-data',
            message ??
                'The providerData must be a valid array of UserInfo objects.');

  /// The providerId must be a valid supported provider identifier string.
  FirebaseAuthError.invalidProviderId([String? message])
      : this(
            'invalid-provider-id',
            message ??
                'The providerId must be a valid supported provider identifier string.');

  /// The session cookie duration must be a valid number in milliseconds between
  /// 5 minutes and 2 weeks.
  FirebaseAuthError.invalidSessionCookieDuration([String? message])
      : this(
            'invalid-session-cookie-duration',
            message ??
                'The session cookie duration must be a valid number in milliseconds '
                    'between 5 minutes and 2 weeks.');

  /// The provided uid must be a non-empty string with at most 128 characters.
  FirebaseAuthError.invalidUid([String? message])
      : this(
            'invalid-uid',
            message ??
                'The uid must be a non-empty string with at most 128 characters.');

  /// The user record to import is invalid.
  FirebaseAuthError.invalidUserImport([String? message])
      : this('invalid-user-import',
            message ?? 'The user record to import is invalid.');

  /// The maximum allowed number of users to import has been exceeded.
  FirebaseAuthError.maximumUserCountExceeded([String? message])
      : this(
            'maximum-user-count-exceeded',
            message ??
                'The maximum allowed number of users to import has been exceeded.');

  /// An Android Package Name must be provided if the Android App is required to
  /// be installed.
  FirebaseAuthError.missingAndroidPackageName([String? message])
      : this(
            'missing-android-pkg-name',
            message ??
                'An Android Package Name must be provided if the Android App is '
                    'required to be installed.');

  /// A valid continue URL must be provided in the request.
  FirebaseAuthError.missingContinueUri([String? message])
      : this('missing-continue-uri',
            message ?? 'A valid continue URL must be provided in the request.');

  /// Importing users with password hashes requires that the hashing algorithm
  /// and its parameters be provided.
  FirebaseAuthError.missingHashAlgorithm([String? message])
      : this(
            'missing-hash-algorithm',
            message ??
                'Importing users with password hashes requires that the hashing '
                    'algorithm and its parameters be provided.');

  /// The request is missing an iOS Bundle ID.
  FirebaseAuthError.missingIosBundleId([String? message])
      : this('missing-ios-bundle-id',
            message ?? 'The request is missing an iOS Bundle ID.');

  /// A uid identifier is required for the current operation.
  FirebaseAuthError.missingUid([String? message])
      : this(
            'missing-uid',
            message ??
                'A uid identifier is required for the current operation.');

  /// The provided sign-in provider is disabled for your Firebase project.
  ///
  /// Enable it from the Sign-in Method section of the Firebase console.
  FirebaseAuthError.operationNotAllowed([String? message])
      : this(
            'operation-not-allowed',
            message ??
                'The given sign-in provider is disabled for this Firebase project. '
                    'Enable it in the Firebase console, under the sign-in method tab of the '
                    'Auth section.');

  /// The provided phoneNumber is already in use by an existing user. Each user
  /// must have a unique phoneNumber.
  FirebaseAuthError.phoneNumberAlreadyExists([String? message])
      : this(
            'phone-number-already-exists',
            message ??
                'The user with the provided phone number already exists.');

  /// No Firebase project was found for the credential used to initialize the
  /// Admin SDKs.
  ///
  /// Refer to Set up a Firebase project for documentation on how to generate a
  /// credential for your project and use it to authenticate the Admin SDKs.
  FirebaseAuthError.projectNotFound([String? message])
      : this(
            'project-not-found',
            message ??
                'No Firebase project was found for the provided credential.');

  /// One or more custom user claims provided to setCustomUserClaims() are
  /// reserved.
  ///
  /// For example, OIDC specific claims such as (sub, iat, iss, exp, aud,
  /// auth_time, etc) should not be used as keys for custom claims.
  FirebaseAuthError.forbiddenClaim([String? message])
      : this(
            'reserved-claim',
            message ??
                'The specified developer claim is reserved and cannot be specified.');

  /// The provided Firebase session cookie is expired.
  FirebaseAuthError.sessionCookieExpired([String? message])
      : this('session-cookie-expired',
            message ?? 'The Firebase session cookie is expired.');

  /// The Firebase session cookie has been revoked.
  FirebaseAuthError.sessionCookieRevoked([String? message])
      : this('session-cookie-revoked',
            message ?? 'The Firebase session cookie has been revoked.');

  /// The provided uid is already in use by an existing user. Each user must
  /// have a unique uid.
  FirebaseAuthError.uidAlreadyExists([String? message])
      : this('uid-already-exists',
            message ?? 'The user with the provided uid already exists.');

  /// The domain of the continue URL is not whitelisted. Whitelist the domain in
  /// the Firebase Console.
  FirebaseAuthError.unauthorizedDomain([String? message])
      : this(
            'unauthorized-continue-uri',
            message ??
                'The domain of the continue URL is not whitelisted. Whitelist the domain in the '
                    'Firebase console.');

  /// There is no existing user record corresponding to the provided identifier.
  FirebaseAuthError.userNotFound([String? message])
      : this(
            'user-not-found',
            message ??
                'There is no user record corresponding to the provided identifier.');

  //

  FirebaseAuthError.quotaExceeded([String? message])
      : this(
            'quota-exceeded',
            message ??
                'The project quota for the specified operation has been exceeded.');
  FirebaseAuthError.tenantNotFound([String? message])
      : this(
            'tenant-not-found',
            message ??
                'There is no tenant corresponding to the provided identifier.');
  FirebaseAuthError.unsupportedTenantOperation([String? message])
      : this(
            'unsupported-tenant-operation',
            message ??
                'This operation is not supported in a multi-tenant context.');
  FirebaseAuthError.missingDisplayName([String? message])
      : this(
            'missing-display-name',
            message ??
                'The resource being created or edited is missing a valid display name.');
  FirebaseAuthError.missingIssuer([String? message])
      : this(
            'missing-issuer',
            message ??
                'The OAuth/OIDC configuration issuer must not be empty.');
  FirebaseAuthError.missingOAuthClientId([String? message])
      : this(
            'missing-oauth-client-id',
            message ??
                'The OAuth/OIDC configuration client ID must not be empty.');
  FirebaseAuthError.missingProviderId([String? message])
      : this('missing-provider-id',
            message ?? 'A valid provider ID must be provided in the request.');
  FirebaseAuthError.missingSamlRelyingPartyConfig([String? message])
      : this(
            'missing-saml-relying-party-config',
            message ??
                'The SAML configuration provided is missing a relying party configuration.');
  //
  ///
  FirebaseAuthError.missingConfig([String? message])
      : this(
            'missing-config',
            message ??
                'The provided configuration is missing required attributes.');
  FirebaseAuthError.invalidTokensValidAfterTime([String? message])
      : this(
            'invalid-tokens-valid-after-time',
            message ??
                'The tokensValidAfterTime must be a valid UTC number in seconds.');

  FirebaseAuthError.invalidTenantId([String? message])
      : this('invalid-tenant-id',
            message ?? 'The tenant ID must be a valid non-empty string.');
  FirebaseAuthError.invalidTenantType([String? message])
      : this(
            'invalid-tenant-type',
            message ??
                'Tenant type must be either "full_service" or "lightweight".');

  FirebaseAuthError.invalidProjectId([String? message])
      : this(
            'invalid-project-id',
            message ??
                'Invalid parent project. Either parent project doesn\'t exist or didn\'t enable multi-tenancy.');
  FirebaseAuthError.invalidName([String? message])
      : this('invalid-name',
            message ?? 'The resource name provided is invalid.');
  FirebaseAuthError.invalidOAuthClientId([String? message])
      : this('invalid-oauth-client-id',
            message ?? 'The provided OAuth client ID is invalid.');
  //

  FirebaseAuthError.billingNotEnabled([String? message])
      : this('billing-not-enabled',
            message ?? 'Feature requires billing to be enabled.');

  FirebaseAuthError.configurationExists([String? message])
      : this(
            'configuration-exists',
            message ??
                'A configuration already exists with the provided identifier.');
  FirebaseAuthError.configurationNotFound([String? message])
      : this(
            'configuration-not-found',
            message ??
                'There is no configuration corresponding to the provided identifier.');

  FirebaseAuthError.invalidConfigs([String? message])
      : this('invalid-config',
            message ?? 'The provided configuration is invalid.');
  FirebaseAuthError.mismatchingTenantId([String? message])
      : this(
            'mismatching-tenant-id',
            message ??
                'User tenant ID does not match with the current TenantAwareAuth tenant ID.');
  FirebaseAuthError.notFound([String? message])
      : this('not-found', message ?? 'The requested resource was not found.');

  FirebaseAuthError(String code, String message) : super('auth', code, message);
}

class FirebaseStorageError extends _PrefixedFirebaseError {
  FirebaseStorageError(String code, String message)
      : super('storage', code, message);

  FirebaseStorageError.invalidArgument(String message)
      : this('invalid-argument', message);
}
