import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart' as auth;

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Configures sign in with email to print out the validation codes on the
  // console.
  auth.AuthConfig.set(auth.AuthConfig(
    sendValidationEmail: (session, email, validationCode) async {
      print('Validation code: $validationCode');
      session.log('Code for $email is $validationCode');
      return true;
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      print('Validation code: $validationCode');
      session.log('Code for ${userInfo.userName} is $validationCode');
      return true;
    },
  ));

  // Create an initial set of entries in the database, if they do not exist
  // already.
  await _populateDatabase(pod);

  // Start the server.
  await pod.start();
}

Future<void> _populateDatabase(Serverpod pod) async {
  // Create a session so that we can access the database.
  var session = await pod.createSession();

  var numChannels = await Channel.count(session);
  if (numChannels != 0) {
    // There are already entries in the database, whe shouldn't add them again.
    await session.close();
    return;
  }

  // Insert an initial set of channels.
  await Channel.insert(
    session,
    Channel(name: 'General', channel: 'general'),
  );
  await Channel.insert(
    session,
    Channel(name: 'Serverpod', channel: 'serverpod'),
  );
  await Channel.insert(
    session,
    Channel(name: 'Introductions', channel: 'intros'),
  );

  // Make sure to close the session when we are done, or it will hold up
  // resources.
  await session.close();
}
