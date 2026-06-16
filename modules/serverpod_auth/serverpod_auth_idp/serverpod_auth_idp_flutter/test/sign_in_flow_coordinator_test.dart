import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/src/common/sign_in_flow_coordinator.dart';

Finder blockingAbsorbPointerFinder() {
  return find.byWidgetPredicate(
    (widget) => widget is AbsorbPointer && widget.absorbing,
  );
}

void main() {
  group('SignInFlowCoordinator', () {
    testWidgets(
      'Given SignInFlowCoordinatorWidget, '
      'when lockUI is called, '
      'then the UI is marked authenticating and a blocking overlay is shown.',
      (tester) async {
        SignInFlowCoordinatorState? coordinator;

        await tester.pumpWidget(
          MaterialApp(
            home: SignInFlowCoordinatorWidget(
              child: Builder(
                builder: (context) {
                  coordinator = SignInFlowCoordinatorWidget.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        coordinator!.lockUI();
        await tester.pump();

        expect(coordinator!.isAuthenticating, isTrue);
        expect(blockingAbsorbPointerFinder(), findsOneWidget);
      },
    );

    testWidgets(
      'Given a locked SignInFlowCoordinatorWidget, '
      'when unlockUI is called, '
      'then authentication state is cleared and the overlay is removed.',
      (tester) async {
        SignInFlowCoordinatorState? coordinator;

        await tester.pumpWidget(
          MaterialApp(
            home: SignInFlowCoordinatorWidget(
              child: Builder(
                builder: (context) {
                  coordinator = SignInFlowCoordinatorWidget.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        coordinator!.lockUI();
        await tester.pump();

        coordinator!.unlockUI();
        await tester.pump();

        expect(coordinator!.isAuthenticating, isFalse);
        expect(blockingAbsorbPointerFinder(), findsNothing);
      },
    );

    testWidgets(
      'Given a locked SignInFlowCoordinatorWidget, '
      'when lockUI is called again, '
      'then the coordinator stays locked and only one overlay is shown.',
      (tester) async {
        SignInFlowCoordinatorState? coordinator;

        await tester.pumpWidget(
          MaterialApp(
            home: SignInFlowCoordinatorWidget(
              child: Builder(
                builder: (context) {
                  coordinator = SignInFlowCoordinatorWidget.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        coordinator!.lockUI();
        await tester.pump();

        coordinator!.lockUI();
        await tester.pump();

        expect(coordinator!.isAuthenticating, isTrue);
        expect(blockingAbsorbPointerFinder(), findsOneWidget);
      },
    );

    testWidgets(
      'Given two sign-in actions under SignInFlowCoordinatorWidget, '
      'when the first sign-in is still in progress, '
      'then a second sign-in tap does not start another flow.',
      (tester) async {
        final signInStarted = Completer<void>();
        var signInCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SignInFlowCoordinatorWidget(
                child: Column(
                  children: [
                    _SignInProbe(
                      label: 'Primary sign-in',
                      onSignIn: () async {
                        signInCount += 1;
                        signInStarted.complete();
                        await Future<void>.delayed(
                          const Duration(milliseconds: 100),
                        );
                      },
                    ),
                    _SignInProbe(
                      label: 'Secondary sign-in',
                      onSignIn: () async {
                        signInCount += 1;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Primary sign-in'));
        await tester.pump();
        await signInStarted.future;

        await tester.tap(find.text('Secondary sign-in'), warnIfMissed: false);
        await tester.pump();

        expect(signInCount, 1);

        await tester.pumpAndSettle();
        expect(signInCount, 1);
      },
    );

    testWidgets(
      'Given a locked SignInFlowCoordinatorWidget, '
      'when the lock timeout elapses, '
      'then the UI is unlocked without cancelling authentication.',
      (tester) async {
        SignInFlowCoordinatorState? coordinator;

        await tester.pumpWidget(
          MaterialApp(
            home: SignInFlowCoordinatorWidget(
              child: Builder(
                builder: (context) {
                  coordinator = SignInFlowCoordinatorWidget.of(context);
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        coordinator!.lockUI();
        await tester.pump();

        expect(coordinator!.isAuthenticating, isTrue);
        expect(blockingAbsorbPointerFinder(), findsOneWidget);

        await tester.pump(SignInFlowCoordinatorWidget.lockTimeout);
        await tester.pump();

        expect(coordinator!.isAuthenticating, isFalse);
        expect(blockingAbsorbPointerFinder(), findsNothing);
      },
    );
  });
}

class _SignInProbe extends StatefulWidget {
  const _SignInProbe({
    required this.label,
    required this.onSignIn,
  });

  final String label;
  final Future<void> Function() onSignIn;

  @override
  State<_SignInProbe> createState() => _SignInProbeState();
}

class _SignInProbeState extends State<_SignInProbe> {
  Future<void> _signIn() async {
    final coordinator = SignInFlowCoordinatorWidget.of(context);
    if (coordinator?.isAuthenticating == true) return;

    coordinator?.lockUI();
    try {
      await widget.onSignIn();
    } finally {
      if (mounted) {
        coordinator?.unlockUI();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _signIn,
      child: Text(widget.label),
    );
  }
}
