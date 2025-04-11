typedef UserInfoData = ({
  String? userName,
  String? fullName,
  String? email,
  String? imageUrl,
});

// // shared with type in `serverpod_auth_profile` (could even use symlinks or similar for the import functions)
// typedef ExistingUserImportFunction = Future<UuidValue?> Function(
//   Session session, {
//   required String email,
//   required String password,
// });
