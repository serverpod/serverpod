import 'dart:async';

import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:storybook_toolkit/storybook_toolkit.dart';

import 'client.dart';
import 'notification.dart';
import 'story.dart';

/// The email of the mock account, and the one entered by the scenarios.
const storyEmail = 'user@serverpod.dev';

/// The password of the mock account.
const storyPassword = 'Password123!';

/// The one-time password sent by the mock server.
const storyOtpCode = '123456';

/// The registration and password reset verification code sent by the mock
/// server.
const storyVerificationCode = 'a1b2c3d4';

/// A state of an email flow screen, reached by running the steps of the flow
/// against the mock server.
class EmailFlowScenario<C extends EmailFlowController<Enum>> {
  /// Creates a scenario reaching a state with [run].
  const EmailFlowScenario(this.label, this.run);

  /// The name of the state, shown in the knob.
  final String label;

  /// Runs the flow on the controller until the state is reached.
  final Future<void> Function(C controller, EndpointAuthEmail server) run;
}

/// Builds a story showing the widget from [builder] in the state of the
/// scenario selected with a knob, out of [scenarios].
///
/// The flow is restarted with a new mock server whenever a knob changes.
/// [configureServer] sets up the mock server before the scenario runs.
Widget buildEmailFlowStory<C extends EmailFlowController<Enum>>(
  BuildContext context, {
  required List<EmailFlowScenario<C>> scenarios,
  required C Function(ServerpodClientShared client) createController,
  required Widget Function(
    C controller,
    VoidCallback? onTermsAndConditionsPressed,
    VoidCallback? onPrivacyPolicyPressed,
  )
  builder,
  void Function(EndpointAuthEmail server)? configureServer,
  List<Object?> restartWhenChanged = const [],
}) {
  final scenario = context.knobs.options<EmailFlowScenario<C>>(
    label: 'State',
    description: 'The state of the screen, reached by running the flow.',
    initial: scenarios.first,
    options: [
      for (final scenario in scenarios)
        Option(label: scenario.label, value: scenario),
    ],
  );

  final width = context.knobs.sliderInt(
    label: 'Column width',
    initial: 300,
    min: 270,
    max: 400,
  );

  final showTermsAndConditions = context.knobs.boolean(
    label: 'Show "Terms and Conditions" on checkbox notice.',
    initial: true,
  );

  final showPrivacyPolicy = context.knobs.boolean(
    label: 'Show "Privacy Policy" on checkbox notice.',
    initial: true,
  );

  final responseDelay = context.knobs.sliderInt(
    label: 'Server response delay (ms)',
    description: 'Slows down the mock server to explore the loading states.',
    initial: 0,
    max: 3000,
    divisions: 30,
  );

  return wrapWidgetInDefaultColumn([
    _EmailFlowStory<C>(
      key: ValueKey([scenario, responseDelay, ...restartWhenChanged]),
      scenario: scenario,
      responseDelay: Duration(milliseconds: responseDelay),
      createController: createController,
      configureServer: configureServer,
      builder: (controller) => builder(
        controller,
        showTermsAndConditions ? () {} : null,
        showPrivacyPolicy ? () {} : null,
      ),
    ),
  ], width: width.toDouble());
}

/// Callbacks for the controllers of the stories.
extension EmailFlowStoryCallbacks on BuildContext {
  /// Shows a snack bar when authenticated.
  void onStoryAuthenticated() {
    if (mounted) showSuccessSnackBar('Authenticated with email!');
  }

  /// Shows a snack bar for the [error].
  void onStoryError(Object error) {
    if (mounted) showErrorSnackBar(error.toString());
  }
}

/// Enters [email] and waits for the email validation of the controller.
Future<void> enterEmail(
  EmailFlowController<Enum> controller, [
  String email = storyEmail,
]) async {
  controller.emailController.text = email;
  await Future<void>.delayed(const Duration(milliseconds: 600));
}

/// Starts [action] with a server that does not respond, to show the loading
/// state.
void startPending(EndpointAuthEmail server, Future<void> Function() action) {
  final responseDelay = server.responseDelay;
  server.responseDelay = const Duration(days: 1);
  unawaited(action());
  server.responseDelay = responseDelay;
}

class _EmailFlowStory<C extends EmailFlowController<Enum>>
    extends StatefulWidget {
  const _EmailFlowStory({
    required this.scenario,
    required this.responseDelay,
    required this.createController,
    required this.builder,
    this.configureServer,
    super.key,
  });

  final EmailFlowScenario<C> scenario;
  final Duration responseDelay;
  final C Function(ServerpodClientShared client) createController;
  final Widget Function(C controller) builder;
  final void Function(EndpointAuthEmail server)? configureServer;

  @override
  State<_EmailFlowStory<C>> createState() => _EmailFlowStoryState<C>();
}

class _EmailFlowStoryState<C extends EmailFlowController<Enum>>
    extends State<_EmailFlowStory<C>> {
  // Each story has its own mock server, so that a scenario still running for
  // a previous story does not change the state of the next one.
  final _client = Client('http://localhost:8080/')
    ..authSessionManager = FlutterAuthSessionManager();
  late final C _controller;
  bool _isRunning = true;
  bool _isDisposed = false;

  EndpointAuthEmail get _server => _client.authEmail;

  @override
  void initState() {
    super.initState();
    widget.configureServer?.call(_server);
    _controller = widget.createController(_client);
    unawaited(_runScenario());
  }

  Future<void> _runScenario() async {
    try {
      // Scenarios submit codes before the verification screen is built, so
      // that the code input does not submit them again.
      await widget.scenario.run(_controller, _server);
    } finally {
      _isRunning = false;
      if (_isDisposed) {
        _controller.dispose();
      } else {
        _server.responseDelay = widget.responseDelay;
      }
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    // A running scenario still uses the controller, so it disposes it when
    // done.
    if (!_isRunning) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(_controller);
}
