/// SMS authentication provider for Serverpod.
///
/// This library provides SMS-based authentication with support for:
/// - Phone number + verification code registration
/// - Phone number + verification code login (with optional auto-registration)
/// - Phone binding for existing users
/// - Two phone storage strategies: hash-only (maximum privacy) or encrypted (retrievable)
library;

// Business logic
export 'business/sms_idp.dart';
export 'business/sms_idp_config.dart';
export 'business/sms_idp_server_exceptions.dart';
export 'business/sms_idp_utils.dart';

// Endpoints
export 'endpoints/sms_idp_base_endpoint.dart';

// Storage
export 'storage/phone_id_crypto_store.dart';
export 'storage/phone_id_hash_store.dart';
export 'storage/phone_id_store.dart';

// Utilities
export 'util/default_code_generators.dart';
export 'util/phone_normalizer.dart';
export 'util/registration_password_policy.dart';
