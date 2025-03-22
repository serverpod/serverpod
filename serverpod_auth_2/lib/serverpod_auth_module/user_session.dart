// sealed class UserSession {}

// /// A user's session to be created post-login
// ///
// /// While we could image authentication mechanisms that would allow one to go into a user without such
// /// a database-backed session (e.g. a shared key or signed token), we use this in this demo to have a clear
// /// point from which on a user is counted as "logged in", meaning properly authenticated. It's important that
// /// there is such a common "end point" across all providers (with potentially 2FA added in the chain) to verify
// /// when they are done.
// class ActiveUserSession implements UserSession {
//   /// The session ID
//   late String id;

//   /// Database would reference into UserInfo/project UserInfo table
//   late int userId;

//   late DateTime createdAt;

//   late String authenticationProvider;

//   late bool secondFactor;
// }

// // Instead of storing this type in the database, we could also pass around a signed token that the client submits when logging in again
// // but since there is already a preliminary check at this point, it's probably fine and could not be abused to flood the DB.
// class UserSessionPendingSecondFactor implements UserSession {
//   late String id;

//   late String authenticationProvider;

//   late int userId;

//   late DateTime createdAt;
// }
