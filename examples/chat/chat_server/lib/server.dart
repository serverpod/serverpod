import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;
import 'package:serverpod_chat_server/serverpod_chat_server.dart' as chat;

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
  );

  // Configures sign in with email to print out the validation codes on the
  // console. In a real-world application, these methods would send emails to
  // the users to validate their email.
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

  // Configure the chat module. By default, chat messages are posted internally
  // on a single server. If you are running the chat in a cluster of servers
  // the postMessagesGlobally needs to be enabled. You will also need to enable
  // Redis in the config files.
  chat.ChatConfig.set(chat.ChatConfig(
    postMessagesGlobally: false,
  ));

  // Start the server.
  await pod.start();

  // Create an initial set of entries in the database, if they do not exist
  // already.
  await _populateDatabase(pod);
}

Future<void> _populateDatabase(Serverpod pod) async {
  // Create a session so that we can access the database.
  var session = await pod.createSession();

  var numChannels = await Channel.db.count(session);
  if (numChannels != 0) {
    // There are already entries in the database, whe shouldn't add them again.
    await session.close();
    return;
  }

  // Insert an initial set of channels.
  await Channel.db.insertRow(
    session,
    Channel(name: 'General', channel: 'general'),
  );
  await Channel.db.insertRow(
    session,
    Channel(name: 'Serverpod', channel: 'serverpod'),
  );
  await Channel.db.insertRow(
    session,
    Channel(name: 'Introductions', channel: 'intros'),
  );

  // Make sure to close the session when we are done, or it will hold up
  // resources.
  await session.close();
}
