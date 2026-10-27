import 'package:serverpod_auth_idp_server/providers/email.dart';

/// By extending [EmailOtpIdpBaseEndpoint], the email identity provider
/// endpoints, including the passwordless sign-in with one-time passwords, are
/// made available on the server and enable the corresponding sign-in widget on
/// the client.
///
/// Extend [EmailIdpBaseEndpoint] instead for the password based sign-in only.
class EmailIdpEndpoint extends EmailOtpIdpBaseEndpoint {}
