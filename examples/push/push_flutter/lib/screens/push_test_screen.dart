import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:push_client/push_client.dart';
import 'package:serverpod_push_store_flutter/serverpod_push_store_flutter.dart';
import 'package:serverpod_push_store_flutter_firebase/serverpod_push_store_flutter_firebase.dart';
import 'package:serverpod_push_store_flutter_onesignal/serverpod_push_store_flutter_onesignal.dart';

import '../client.dart';
import '../firebase_bootstrap.dart';
import '../onesignal_service.dart';
import '../system_notification.dart';

/// Registers this device and sends one notification to every live device.
class PushTestScreen extends StatefulWidget {
  const PushTestScreen({super.key});

  @override
  State<PushTestScreen> createState() => _PushTestScreenState();
}

class _PushTestScreenState extends State<PushTestScreen> {
  FirebasePushRegistrar? _registrar;
  OneSignalPushRegistrar? _oneSignalRegistrar;
  void Function(String? id)? _oneSignalSubscriptionObserver;
  bool _oneSignalDialogShown = false;
  String? _token;
  String? _oneSignalSubscriptionId;
  bool _snsRegistered = false;
  String? _snsError;
  StreamSubscription<String>? _snsTokenSub;
  late final String _installationId;
  late final PushPlatform _platform;

  String _status = 'Starting…';
  String? _foregroundMessage;
  String? _banner;
  bool _busy = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _platform = kIsWeb ? PushPlatform.web : PushPlatform.android;
    _installationId = kIsWeb ? 'web-chrome' : 'android-device';
    unawaited(_start());
  }

  @override
  void dispose() {
    OneSignalService.instance.removePushSubscriptionObserver();
    unawaited(_snsTokenSub?.cancel() ?? Future<void>.value());
    unawaited(_registrar?.stop() ?? Future<void>.value());
    unawaited(_oneSignalRegistrar?.stop() ?? Future<void>.value());
    super.dispose();
  }

  Future<void> _start() async {
    setState(() {
      _status = 'Connecting…';
      _ready = false;
      _busy = false;
      _banner = null;
      _foregroundMessage = null;
      _snsRegistered = false;
      _snsError = null;
    });
    try {
      final useFirebase = !kIsWeb || FirebaseBootstrap.isWebConfigured;
      if (useFirebase) {
        final messaging = FirebaseMessaging.instance;
        final settings = await messaging.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        if (settings.authorizationStatus == AuthorizationStatus.denied) {
          if (!mounted) return;
          setState(() {
            _ready = false;
            _status =
                'Notifications are denied. Enable them in system settings, '
                'then tap Retry.';
          });
          return;
        }

        final registrar = FirebasePushRegistrar(
          caller: client.modules.pushStore,
          platform: _platform,
          installationId: _installationId,
          appVersion: '1.0.0',
          vapidKey: kIsWeb ? FirebaseBootstrap.vapidKey : null,
        );

        await SystemNotification.ensureInitialized();
        await registrar.start();
        _registrar = registrar;
        _token = await messaging.getToken(
          vapidKey: kIsWeb ? FirebaseBootstrap.vapidKey : null,
        );

        FirebaseMessaging.onMessage.listen((final message) {
          if (_isOneSignalFcmMessage(message)) return;
          final title = message.notification?.title ?? 'Serverpod Push';
          final body =
              message.notification?.body ??
              message.data['case'] ??
              'Notification';
          unawaited(_showSystemNotification(title, body));
        });
      }

      if (oneSignalAppId.isNotEmpty) {
        try {
          await _startOneSignal();
        } catch (e) {
          _foregroundMessage = _oneSignalErrorMessage(e);
        }
      }

      if (!kIsWeb && _token != null) {
        try {
          await _registerSns(_token!);
          await _snsTokenSub?.cancel();
          _snsTokenSub = FirebaseMessaging.instance.onTokenRefresh.listen((
            final token,
          ) {
            unawaited(_registerSns(token));
          });
        } catch (e) {
          _snsError = '$e';
        }
      }

      if (!mounted) return;
      final oneSignalReady = OneSignalService.instance.isRegistered(
        _oneSignalSubscriptionId ??
            OneSignalService.instance.pushSubscriptionId,
      );
      setState(() {
        _ready = _token != null || oneSignalReady;
        _status = _token == null && !oneSignalReady
            ? 'No FCM token or OneSignal subscription on ${_platform.name}.'
            : 'Registered on ${_platform.name}.\n'
                  'install=$_installationId\n'
                  '${_token == null ? 'FCM: waiting for token…' : 'token=${_token!.substring(0, 16)}…'}'
                  '${_oneSignalStatusLine()}'
                  '${_snsStatusLine()}';
      });
    } catch (e) {
      if (!mounted) return;
      final refused =
          '$e'.contains('errno = 111') ||
          '$e'.toLowerCase().contains('connection refused');
      setState(() {
        _ready = false;
        _status = refused
            ? 'Cannot reach the server at $serverUrl\n'
                  'OS error 111 = connection refused.\n'
                  'Start the server, then tap Retry.'
            : 'Startup failed: $e';
      });
    }
  }

  String _oneSignalErrorMessage(final Object error) {
    final text = '$error';
    if (text.toLowerCase().contains('not configured for web push')) {
      return 'OneSignal: this app has no Web platform. '
          'In the OneSignal dashboard add Platforms → Web '
          '(Typical Site) for http://localhost, then tap Retry.';
    }
    return 'OneSignal startup failed: $error';
  }

  String _oneSignalStatusLine() {
    final id = _oneSignalSubscriptionId;
    if (id == null || id.isEmpty) {
      return '\nOneSignal: waiting for subscription id…';
    }
    final preview = id.length > 16 ? '${id.substring(0, 16)}…' : id;
    return '\nOneSignal=$preview';
  }

  String _snsStatusLine() {
    if (kIsWeb) {
      return '\nAmazon SNS: tap to send to Android (SNS has no Web Push).';
    }
    if (_snsError != null) {
      return '\nAmazon SNS: registration failed ($_snsError)';
    }
    if (!_snsRegistered) {
      return '\nAmazon SNS: waiting for the FCM token…';
    }
    return '\nAmazon SNS: FCM token registered as sns device.';
  }

  Future<void> _registerSns(final String token) async {
    await PushDeviceRegistrar(client.modules.pushStore).register(
      provider: 'sns',
      credential: token,
      platform: _platform,
      installationId: '$_installationId-sns',
      appVersion: '1.0.0',
    );
    _token = token;
    _snsRegistered = true;
    _snsError = null;
    if (mounted) setState(() {});
  }

  Future<void> _startOneSignal() async {
    if (oneSignalAppId.isEmpty) return;
    final oneSignal = OneSignalService.instance;
    await oneSignal.initialize(oneSignalAppId);
    final registrar = OneSignalPushRegistrar(
      caller: client.modules.pushStore,
      appId: oneSignalAppId,
      platform: _platform,
      installationId: '$_installationId-onesignal',
      appVersion: '1.0.0',
      initializeSdk: false,
    );
    await registrar.start();
    _oneSignalRegistrar = registrar;

    _oneSignalSubscriptionObserver = _maybeShowIntegrationCompleteDialog;
    oneSignal.addPushSubscriptionObserver(_oneSignalSubscriptionObserver!);
    _maybeShowIntegrationCompleteDialog(oneSignal.pushSubscriptionId);
  }

  void _maybeShowIntegrationCompleteDialog(final String? subscriptionId) {
    if (!OneSignalService.instance.isRegistered(subscriptionId)) return;
    _oneSignalSubscriptionId = subscriptionId;
    if (mounted) {
      setState(() {});
    }
    if (_oneSignalDialogShown || !mounted) return;
    _oneSignalDialogShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (final dialogContext) => AlertDialog(
          title: const Text('Your OneSignal SDK integration is complete!'),
          content: const Text(
            'You can now send Push Notifications & In-App Messages through '
            'OneSignal. Tap below to enable push notifications.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                unawaited(OneSignalService.instance.requestPermission());
              },
              child: const Text('Got it'),
            ),
          ],
        ),
      );
    });
  }

  /// OneSignal delivers Android/web push through FCM. Those messages must not
  /// also be drawn by the FCM foreground handler, or the same send appears twice.
  bool _isOneSignalFcmMessage(final RemoteMessage message) {
    final data = message.data;
    return data.containsKey('custom') ||
        data.containsKey('onesignal_id') ||
        data.containsKey('o');
  }

  Future<void> _showSystemNotification(
    final String title,
    final String body,
  ) async {
    try {
      await SystemNotification.show(title: title, body: body);
      if (!mounted) return;
      setState(() => _foregroundMessage = null);
    } catch (e) {
      if (!mounted) return;
      setState(() => _foregroundMessage = 'Notification failed: $e');
    }
  }

  Future<void> _broadcast() => _runCase(
    caseId: 'broadcast.all',
    pending: 'Sending one notification per phone/browser…',
  );

  Future<void> _broadcastFcm() => _runCase(
    caseId: 'broadcast.fcm',
    pending: 'Sending via FCM only…',
  );

  Future<void> _broadcastOneSignal() => _runCase(
    caseId: 'broadcast.onesignal',
    pending: 'Sending via OneSignal only…',
  );

  Future<void> _broadcastSns() => _runCase(
    caseId: 'broadcast.sns',
    pending: 'Sending via Amazon SNS…',
  );

  Future<void> _runCase({
    required final String caseId,
    required final String pending,
  }) async {
    if (_busy || !_ready) return;
    setState(() {
      _busy = true;
      _banner = pending;
      _foregroundMessage = null;
    });
    try {
      final report = await client.pushTest.runCase(caseId: caseId);
      if (!mounted) return;
      setState(() {
        _banner = report;
        _busy = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _banner = 'Broadcast failed: $e';
        _busy = false;
      });
    }
  }

  Future<void> _scheduleDelayedPing() async {
    if (_busy || !_ready) return;
    setState(() {
      _busy = true;
      _banner = 'Scheduling ping in 15s…';
      _foregroundMessage = null;
    });
    try {
      final report = await client.pushTest.scheduleDelayedPing();
      if (!mounted) return;
      setState(() {
        _banner = report;
        _busy = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _banner = 'Delayed ping failed: $e';
        _busy = false;
      });
    }
  }

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Push (${_platform.name})'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Text(_status, style: theme.textTheme.bodyMedium),
          if (_banner != null) ...[
            const SizedBox(height: 8),
            Material(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SelectableText(
                  _banner!,
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
          if (_foregroundMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _foregroundMessage!,
              style: TextStyle(color: theme.colorScheme.tertiary),
            ),
          ],
          const SizedBox(height: 16),
          if (!_ready)
            FilledButton.tonalIcon(
              onPressed: _busy ? null : () => unawaited(_start()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry connect'),
            )
          else ...[
            FilledButton.icon(
              onPressed: _busy ? null : _broadcast,
              icon: const Icon(Icons.campaign_outlined),
              label: Text(
                _busy ? 'Sending…' : 'Notify all devices',
              ),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: _busy ? null : _broadcastFcm,
              icon: const Icon(Icons.local_fire_department_outlined),
              label: const Text('Notify FCM only'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: _busy ? null : _broadcastOneSignal,
              icon: const Icon(Icons.notifications_outlined),
              label: const Text('Notify OneSignal only'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: _busy ? null : _broadcastSns,
              icon: const Icon(Icons.cloud_outlined),
              label: const Text('Notify Amazon SNS'),
            ),
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: _busy ? null : _scheduleDelayedPing,
              icon: const Icon(Icons.schedule),
              label: const Text('Schedule ping in 15s'),
            ),
          ],
          const SizedBox(height: 16),
          Text(
            'Delayed ping — test app states',
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap Schedule ping in 15s, then put this app into the state you '
            'want to verify before the tray notification arrives.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          const _StateHint(
            label: 'Foreground',
            detail:
                'Keep this screen open. After ~15s you should see a system '
                'tray notification while the app is in front.',
          ),
          const _StateHint(
            label: 'Background',
            detail:
                'Tap the button, then press Home immediately. The ping should '
                'appear in the tray while the app is backgrounded.',
          ),
          const _StateHint(
            label: 'Terminated',
            detail:
                'Tap the button, then force-stop / swipe away the app. The '
                'tray notification should still appear after the delay.',
          ),
        ],
      ),
    );
  }
}

class _StateHint extends StatelessWidget {
  const _StateHint({
    required this.label,
    required this.detail,
  });

  final String label;
  final String detail;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 96,
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(detail, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}
