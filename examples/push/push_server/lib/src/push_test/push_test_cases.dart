import 'dart:async';
import 'dart:math';

// The matrix harness drives the live dispatcher the same way the package's
// integration tests do.
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_push_store_server/serverpod_push_store_server.dart';

import 'controllable_fcm_provider.dart';

/// Catalog of one-by-one matrix cases for the example harness.
const pushTestCaseCatalog = <String, String>{
  // Broadcast
  'broadcast.all':
      'One real notification per physical device (FCM preferred, else OneSignal).',
  'broadcast.fcm': 'Real FCM to every live FCM device.',
  'broadcast.onesignal': 'Real OneSignal to every live OneSignal device.',
  'broadcast.sns':
      'Real Amazon SNS to every live SNS device (Android FCM token).',
  'broadcast.delayed_ping':
      'Enqueue a real ping with notBefore=+15s; one row per physical device.',
  // Basic
  'basic.success': 'Enqueue + real FCM delivery to every live device.',
  'basic.invalid_recipient': 'sendToUsers with a user that has no devices.',
  'basic.invalid_token':
      'Register a dead token, send, expect invalidToken → device disabled.',
  // Lifecycle
  'lifecycle.register_status': 'Report current live device rows.',
  'lifecycle.unregister_self':
      'Unregister the calling installation (client also stops FCM).',
  'lifecycle.token_refresh':
      'Re-register same installationId with a new credential; one live row.',
  // Delivery
  'delivery.online': 'Same as basic.success (online recipient).',
  'delivery.offline_queue':
      'Enqueue while provider hangs; delivery stays pending/sending until released.',
  'delivery.provider_failure':
      'Script permanentFailure; delivery ends abandoned/discarded.',
  // Retry
  'retry.transient_then_success':
      'retryable once, then accepted; attempts grow, then accepted.',
  'retry.timeout':
      'Provider hang past sendTimeout; claimCount grows, attempts stay 0.',
  'retry.max_retries':
      'retryable until maxAttempts; delivery reaches abandoned.',
  // Concurrency
  'concurrency.two_workers':
      'Two dispatchers claim two deliveries with SKIP LOCKED (disjoint owners).',
  'concurrency.duplicate_claim':
      'Second claim of the same row is impossible under SKIP LOCKED.',
  // Idempotency
  'idempotency.duplicate_job':
      'Same dedupeKey twice → second returns deduped, zero new deliveries.',
  'idempotency.worker_crash_retry':
      'Timeout leaves attempts=0; reaper + retry can still accept.',
  // Payload
  'payload.notification': 'Title + body + data (real FCM).',
  'payload.data_only': 'Data-only / silent-style payload (real FCM).',
  'payload.malformed_large': 'Oversized payload rejected at enqueue.',
  // Multiple devices
  'multi.one_device': 'Fan-out to the single live device for a synthetic user.',
  'multi.two_devices': 'Fan-out to two synthetic devices for one user.',
  'multi.many_devices': 'Fan-out to many synthetic devices for one user.',
  // Provider
  'provider.success': 'Scripted accepted without calling FCM.',
  'provider.rejection': 'Scripted permanentFailure.',
  'provider.timeout': 'Same as retry.timeout.',
  'provider.auth_failure':
      'Scripted UNAUTHENTICATED retryable (circuit-breaker input).',
  // Queue
  'queue.empty': 'Report queue depths when nothing is pending.',
  'queue.normal': 'Enqueue a small burst (5) of scripted accepts.',
  'queue.high': 'Enqueue a larger burst (50) of scripted accepts.',
  // App state (server half — client must put app in the right state first)
  'app.foreground': 'Send notification; observe while app is open.',
  'app.background': 'Send notification; observe while app is backgrounded.',
  'app.terminated': 'Send notification; observe while app is killed.',
  // Security
  'security.unauthorized_send':
      'requireLogin send path rejects anonymous callers.',
  'security.invalid_recipient': 'Same as basic.invalid_recipient.',
};

/// Runs matrix cases against the live store + controllable FCM provider.
class PushTestCases {
  PushTestCases(this.provider);

  final ControllableFcmProvider provider;

  Future<String> run(
    final Session session, {
    required final String caseId,
    final String? installationId,
    final String? credential,
  }) async {
    final id = caseId.trim();
    if (!pushTestCaseCatalog.containsKey(id)) {
      return 'Unknown case "$id". Known:\n'
          '${pushTestCaseCatalog.keys.join('\n')}';
    }

    return switch (id) {
      'broadcast.all' => _broadcastAll(session),
      'broadcast.fcm' => _broadcastProvider(session, 'fcm'),
      'broadcast.onesignal' => _broadcastProvider(session, 'onesignal'),
      'broadcast.sns' => _broadcastProvider(session, 'sns'),
      'broadcast.delayed_ping' => _delayedPing(session),
      'basic.success' ||
      'delivery.online' ||
      'payload.notification' ||
      'app.foreground' ||
      'app.background' ||
      'app.terminated' => _realFanOut(
        session,
        title: 'Matrix: $id',
        body: 'Real FCM notification for $id',
        data: {'case': id, 'kind': 'notification'},
        installationId: installationId,
      ),
      'payload.data_only' => _realFanOut(
        session,
        title: null,
        body: null,
        data: {'case': id, 'kind': 'data-only', 'silent': '1'},
        installationId: installationId,
      ),
      'basic.invalid_recipient' ||
      'security.invalid_recipient' => _invalidRecipient(session),
      'basic.invalid_token' => _invalidToken(session),
      'lifecycle.register_status' => _registerStatus(session),
      'lifecycle.unregister_self' => _unregisterSelf(
        session,
        credential: credential,
      ),
      'lifecycle.token_refresh' => _tokenRefresh(
        session,
        installationId: installationId,
        credential: credential,
      ),
      'delivery.offline_queue' => _offlineQueue(session),
      'delivery.provider_failure' || 'provider.rejection' => _scriptedOutcome(
        session,
        PushDeliveryOutcome.permanentFailure,
        label: id,
      ),
      'retry.transient_then_success' => _transientThenSuccess(session),
      'retry.timeout' || 'provider.timeout' => _timeout(session),
      'retry.max_retries' => _maxRetries(session),
      'concurrency.two_workers' => _twoWorkers(session),
      'concurrency.duplicate_claim' => _duplicateClaim(session),
      'idempotency.duplicate_job' => _duplicateJob(session),
      'idempotency.worker_crash_retry' => _workerCrashRetry(session),
      'payload.malformed_large' => _largePayload(session),
      'multi.one_device' => _multiDevices(session, count: 1),
      'multi.two_devices' => _multiDevices(session, count: 2),
      'multi.many_devices' => _multiDevices(session, count: 12),
      'provider.success' => _scriptedOutcome(
        session,
        PushDeliveryOutcome.accepted,
        label: id,
      ),
      'provider.auth_failure' => _scriptedOutcome(
        session,
        PushDeliveryOutcome.retryable,
        label: id,
        errorCode: 'UNAUTHENTICATED',
      ),
      'queue.empty' => _queueReport(session, label: 'empty check'),
      'queue.normal' => _queueBurst(session, count: 5),
      'queue.high' => _queueBurst(session, count: 50),
      'security.unauthorized_send' =>
        'This case is enforced by the requireLogin endpoint method '
            '`authorizedSend`. Call that from an anonymous client and expect '
            'a 401/not-authenticated error.',
      _ => 'Unhandled case "$id".',
    };
  }

  /// One real notification per phone/browser.
  ///
  /// FCM and OneSignal rows for the same install are collapsed so Android
  /// does not get an FCM tray, a OneSignal tray, and a local echo of the
  /// OneSignal-via-FCM payload.
  Future<String> _broadcastAll(final Session session) {
    return _broadcastDevices(
      session,
      caseId: 'broadcast.all',
      title: 'All devices',
      body: 'Broadcast from the push example',
      devices: _onePerPhysicalDevice,
    );
  }

  Future<String> _broadcastProvider(
    final Session session,
    final String providerId,
  ) {
    return _broadcastDevices(
      session,
      caseId: 'broadcast.$providerId',
      title: switch (providerId) {
        'onesignal' => 'OneSignal',
        'sns' => 'Amazon SNS',
        _ => 'FCM',
      },
      body: 'Broadcast via $providerId',
      devices: (final devices) => [
        for (final device in devices)
          if (device.provider == providerId) device,
      ],
    );
  }

  Future<String> _broadcastDevices(
    final Session session, {
    required final String caseId,
    required final String title,
    required final String body,
    required final List<PushDevice> Function(List<PushDevice> devices) devices,
  }) async {
    provider.clear();
    final selected = devices(_realDevices(await _liveDevices(session)));
    if (selected.isEmpty) {
      return 'No live devices for $caseId. Open the app on Android and in '
          'Chrome and wait until each says Registered.';
    }
    final result = await PushNotifications.sendToDevices(
      session,
      message: PushMessage(
        title: title,
        body: body,
        data: {
          'case': caseId,
          'kind': 'notification',
        },
        priority: PushPriority.high,
      ),
      deviceIds: [for (final d in selected) d.id!],
    );
    await _waitForTerminal(session, result.notificationId);
    final rows = await _deliveriesFor(session, result.notificationId);
    final targets = selected
        .map(
          (final d) =>
              '${d.provider}/${d.platform.name}/${d.installationId ?? '-'}',
        )
        .join(', ');
    return 'targets (${selected.length}): $targets\n'
        '${_formatEnqueue(result, rows)}';
  }

  /// Schedules a real FCM ping for every live device about 15 seconds out.
  ///
  /// Returns as soon as rows are enqueued so the client can background or
  /// terminate the app before the dispatcher sends.
  Future<String> _delayedPing(final Session session) async {
    provider.clear();
    final devices = _onePerPhysicalDevice(
      _realDevices(await _liveDevices(session)),
    );
    if (devices.isEmpty) {
      return 'No live devices. Open the app on Android and in Chrome and '
          'wait until each says Registered.';
    }
    const delay = Duration(seconds: 15);
    final notBefore = DateTime.now().toUtc().add(delay);
    final result = await PushNotifications.sendToDevices(
      session,
      message: PushMessage(
        title: 'Delayed ping',
        body: 'Scheduled 15s ago — check foreground / background / terminated',
        data: const {
          'case': 'broadcast.delayed_ping',
          'kind': 'notification',
        },
        priority: PushPriority.high,
        timeToLive: const Duration(minutes: 5),
      ),
      deviceIds: [for (final d in devices) d.id!],
      notBefore: notBefore,
    );
    final targets = devices
        .map(
          (final d) => '${d.platform.name}/${d.installationId ?? '-'}',
        )
        .join(', ');
    return 'scheduled in ${delay.inSeconds}s '
        '(notBefore=${notBefore.toIso8601String()})\n'
        'targets (${devices.length}): $targets\n'
        'enqueued created=${result.deliveriesCreated} '
        'deduped=${result.deduped} id=${result.notificationId}\n'
        'Background or kill the app now — the tray ping arrives after the delay.';
  }

  Future<String> _realFanOut(
    final Session session, {
    required final String? title,
    required final String? body,
    required final Map<String, String> data,
    final String? installationId,
  }) async {
    provider.clear();
    var devices = await _liveDevices(session);
    // Prefer the calling app installation so auto-runs do not spam every
    // leftover synthetic device from earlier matrix cases.
    if (installationId != null && installationId.isNotEmpty) {
      final matched = devices
          .where((final d) => d.installationId == installationId)
          .toList();
      if (matched.isNotEmpty) {
        devices = matched;
      } else {
        devices = [
          for (final d in devices)
            if (d.credential.isNotEmpty &&
                !d.credential.startsWith('synthetic-') &&
                !d.credential.startsWith('matrix-') &&
                !d.credential.startsWith('dead-token-') &&
                !d.credential.startsWith('refreshed-'))
              d,
        ];
      }
    }
    if (devices.isEmpty) {
      return 'No live devices. Open the app and wait for FCM registration.';
    }
    final result = await PushNotifications.sendToDevices(
      session,
      message: PushMessage(
        title: title,
        body: body,
        data: data,
        priority: PushPriority.high,
      ),
      deviceIds: [for (final d in devices) d.id!],
    );
    await _waitForTerminal(session, result.notificationId);
    final rows = await _deliveriesFor(session, result.notificationId);
    return _formatEnqueue(result, rows);
  }

  Future<String> _invalidRecipient(final Session session) async {
    final result = await PushNotifications.sendToUsers(
      session,
      message: PushMessage(
        title: 'Nobody',
        data: const {'case': 'invalid_recipient'},
        priority: PushPriority.normal,
      ),
      userIdentifiers: const ['user-does-not-exist'],
    );
    return 'invalid recipient → notificationId=${result.notificationId}, '
        'deliveriesCreated=${result.deliveriesCreated} '
        '(expect null/0).';
  }

  Future<String> _invalidToken(final Session session) async {
    final user = 'matrix-invalid-token';
    final credential = 'dead-token-${Random().nextInt(1 << 32)}';
    await PushDevices.register(
      session,
      provider: 'fcm',
      credential: credential,
      platform: PushPlatform.android,
      installationId: 'matrix-invalid-token',
    );
    // Attach a synthetic owner so sendToUsers can find it.
    await _forceUser(session, credential: credential, user: user);

    provider.arm(
      const FcmScriptedOutcome(
        PushDeliveryOutcome.invalidToken,
        errorCode: 'UNREGISTERED',
      ),
    );

    final result = await PushNotifications.sendToUsers(
      session,
      message: PushMessage(
        title: 'Invalid token',
        data: const {'case': 'invalid_token'},
        priority: PushPriority.high,
      ),
      userIdentifiers: [user],
    );
    await _drainScripted(session);
    final device = await PushDevice.db.findFirstRow(
      session,
      where: (final t) => t.credential.equals(credential),
    );
    final rows = await _deliveriesFor(session, result.notificationId);
    return '${_formatEnqueue(result, rows)}\n'
        'device.disabledAt=${device?.disabledAt}, '
        'reason=${device?.disabledReason} '
        '(expect invalidToken).';
  }

  Future<String> _registerStatus(final Session session) async {
    final live = await _liveDevices(session);
    final all = await PushDevice.db.find(session);
    final buf = StringBuffer('live=${live.length} total=${all.length}\n');
    for (final d in live) {
      buf.writeln(
        '- ${d.platform.name} install=${d.installationId} '
        'user=${d.userIdentifier} token=${_short(d.credential)}',
      );
    }
    return buf.toString().trimRight();
  }

  Future<String> _unregisterSelf(
    final Session session, {
    required final String? credential,
  }) async {
    if (credential == null || credential.isEmpty) {
      return 'Client must pass its current FCM credential.';
    }
    await PushDevices.unregister(
      session,
      provider: 'fcm',
      credential: credential,
    );
    final device = await PushDevice.db.findFirstRow(
      session,
      where: (final t) => t.credential.equals(credential),
    );
    return 'unregistered. disabledAt=${device?.disabledAt}, '
        'reason=${device?.disabledReason}';
  }

  Future<String> _tokenRefresh(
    final Session session, {
    required final String? installationId,
    required final String? credential,
  }) async {
    if (installationId == null || installationId.isEmpty) {
      return 'Client must pass installationId.';
    }
    final newCredential = credential?.isNotEmpty == true
        ? '$credential-refreshed-${Random().nextInt(1 << 20)}'
        : 'refreshed-${Random().nextInt(1 << 32)}';
    await PushDevices.register(
      session,
      provider: 'fcm',
      credential: newCredential,
      platform: PushPlatform.android,
      installationId: installationId,
    );
    final live = await PushDevice.db.find(
      session,
      where: (final t) =>
          t.installationId.equals(installationId) & t.disabledAt.equals(null),
    );
    return 'token refresh for install=$installationId → '
        'liveRows=${live.length}, credential=${_short(newCredential)} '
        '(expect 1). Re-register the real FCM token from the app afterwards.';
  }

  Future<String> _offlineQueue(final Session session) async {
    provider.arm(const FcmHang(duration: Duration(seconds: 30)));
    final result = await _enqueueToLiveOrSynthetic(
      session,
      title: 'Offline/hang',
      data: const {'case': 'offline_queue'},
    );
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    final rows = await _deliveriesFor(session, result.notificationId);
    provider.clear();
    await _releaseSending(session);
    return '${_formatEnqueue(result, rows)}\n'
        'While provider hung, status should be sending/pending. '
        'Claims were released for cleanup.';
  }

  Future<String> _scriptedOutcome(
    final Session session,
    final PushDeliveryOutcome outcome, {
    required final String label,
    final String? errorCode,
  }) async {
    provider.arm(
      FcmScriptedOutcome(outcome, errorCode: errorCode),
    );
    final result = await _enqueueToLiveOrSynthetic(
      session,
      title: label,
      data: {'case': label},
    );
    await _drainScripted(session);
    final rows = await _deliveriesFor(session, result.notificationId);
    return _formatEnqueue(result, rows);
  }

  Future<String> _transientThenSuccess(final Session session) async {
    provider.arm(const FcmScriptedOutcome(PushDeliveryOutcome.retryable));
    provider.arm(const FcmScriptedOutcome(PushDeliveryOutcome.accepted));
    final result = await _enqueueToLiveOrSynthetic(
      session,
      title: 'transient then success',
      data: const {'case': 'retry.transient_then_success'},
    );
    await _drainScripted(session);
    await _bumpDue(session, result.notificationId);
    await _drainScripted(session);
    final rows = await _deliveriesFor(session, result.notificationId);
    return _formatEnqueue(result, rows);
  }

  Future<String> _timeout(final Session session) async {
    provider.arm(const FcmHang());
    final result = await _enqueueToLiveOrSynthetic(
      session,
      title: 'timeout',
      data: const {'case': 'retry.timeout'},
    );
    await Future<void>.delayed(const Duration(seconds: 3));
    final mid = await _deliveriesFor(session, result.notificationId);
    await _ageClaims(session);
    await _forceMaintenance(session);
    final after = await _deliveriesFor(session, result.notificationId);
    provider.clear();
    return 'after hang+timeout:\n${_formatRows(mid)}\n'
        'after forced reaper:\n${_formatRows(after)}\n'
        'Expect attempts=0 and claimCount>=1 while sending; '
        'reaper releases or abandons by maxClaims.';
  }

  Future<String> _maxRetries(final Session session) async {
    final maxAttempts = PushStore.instance.config.maxAttempts;
    provider.arm(
      FcmScriptedOutcome(
        PushDeliveryOutcome.retryable,
        count: maxAttempts + 1,
      ),
    );
    final result = await _enqueueToLiveOrSynthetic(
      session,
      title: 'max retries',
      data: const {'case': 'retry.max_retries'},
    );
    for (var i = 0; i < maxAttempts + 2; i++) {
      await _drainScripted(session);
      await _bumpDue(session, result.notificationId);
    }
    final rows = await _deliveriesFor(session, result.notificationId);
    provider.clear();
    return '${_formatEnqueue(result, rows)}\n'
        'Expect status=abandoned after maxAttempts=$maxAttempts.';
  }

  Future<String> _twoWorkers(final Session session) async {
    final user = 'matrix-two-workers';
    await _ensureSyntheticDevices(session, user: user, count: 2);
    provider.arm(const FcmHang(count: 2));

    final result = await PushNotifications.sendToUsers(
      session,
      message: PushMessage(
        title: 'two workers',
        data: const {'case': 'concurrency.two_workers'},
        priority: PushPriority.high,
      ),
      userIdentifiers: [user],
    );

    final primary = PushStore.instance.dispatcher;
    final secondary = PushDispatcher(
      serverpod: session.serverpod,
      config: PushStore.instance.config,
    );
    await secondary.attachSessionForTest();

    if (primary != null) {
      unawaited(primary.runCycleForTest());
    }
    unawaited(secondary.runCycleForTest());

    final sending = await _waitUntil(
      () => PushDelivery.db.find(
        session,
        where: (final t) =>
            t.notificationId.equals(result.notificationId) &
            t.status.equals(PushDeliveryStatus.sending),
      ),
      (final rows) => rows.length >= 2,
    );

    final owners = sending.map((final d) => d.claimedBy).toSet();
    provider.clear();
    await secondary.stopAndReleaseClaims();
    await _releaseSending(session);

    return 'claimed ${sending.length} rows with owners=$owners '
        '(expect 2 distinct claimedBy values).\n'
        '${_formatRows(sending)}';
  }

  Future<String> _duplicateClaim(final Session session) async {
    final user = 'matrix-dup-claim';
    await _ensureSyntheticDevices(session, user: user, count: 1);
    provider.arm(const FcmHang());

    final result = await PushNotifications.sendToUsers(
      session,
      message: PushMessage(
        title: 'dup claim',
        data: const {'case': 'concurrency.duplicate_claim'},
        priority: PushPriority.high,
      ),
      userIdentifiers: [user],
    );

    final primary = PushStore.instance.dispatcher;
    final secondary = PushDispatcher(
      serverpod: session.serverpod,
      config: PushStore.instance.config,
    );
    await secondary.attachSessionForTest();

    if (primary != null) {
      await primary.runCycleForTest();
    }
    await secondary.runCycleForTest();

    final rows = await _deliveriesFor(session, result.notificationId);
    final owners = rows.map((final d) => d.claimedBy).toSet();
    provider.clear();
    await secondary.stopAndReleaseClaims();
    await _releaseSending(session);

    return 'single delivery claimedBy set=$owners '
        '(expect exactly one non-null owner; second worker got 0 rows).\n'
        '${_formatRows(rows)}';
  }

  Future<String> _duplicateJob(final Session session) async {
    final devices = await _liveDevices(session);
    if (devices.isEmpty) {
      await _ensureSyntheticDevices(
        session,
        user: 'matrix-dedupe',
        count: 1,
      );
    }
    final key = 'dedupe-${DateTime.now().toUtc().millisecondsSinceEpoch}';
    final targets = await _liveDevices(session);
    final ids = [for (final d in targets) d.id!];

    Future<PushEnqueueResult> once() => PushNotifications.sendToDevices(
      session,
      message: PushMessage(
        title: 'dedupe',
        data: const {'case': 'idempotency.duplicate_job'},
        priority: PushPriority.normal,
      ),
      deviceIds: ids,
      dedupeKey: key,
    );

    final first = await once();
    final second = await once();
    return 'first: deduped=${first.deduped}, created=${first.deliveriesCreated}, '
        'id=${first.notificationId}\n'
        'second: deduped=${second.deduped}, created=${second.deliveriesCreated}, '
        'id=${second.notificationId} '
        '(expect second.deduped=true, created=0, same id).';
  }

  Future<String> _workerCrashRetry(final Session session) async {
    provider.arm(const FcmHang());
    final result = await _enqueueToLiveOrSynthetic(
      session,
      title: 'crash retry',
      data: const {'case': 'idempotency.worker_crash_retry'},
    );
    await Future<void>.delayed(const Duration(seconds: 3));
    final mid = await _deliveriesFor(session, result.notificationId);
    await _ageClaims(session);
    await _forceMaintenance(session);
    provider.arm(const FcmScriptedOutcome(PushDeliveryOutcome.accepted));
    await _bumpDue(session, result.notificationId);
    await _drainScripted(session);
    final after = await _deliveriesFor(session, result.notificationId);
    provider.clear();
    return 'after crash/timeout:\n${_formatRows(mid)}\n'
        'after retry success:\n${_formatRows(after)}\n'
        'Expect attempts unchanged by the hang, then accepted on retry.';
  }

  Future<String> _largePayload(final Session session) async {
    final devices = await _liveDevices(session);
    if (devices.isEmpty) {
      return 'Register at least one device first.';
    }
    final huge = 'x' * 5000;
    try {
      await PushNotifications.sendToDevices(
        session,
        message: PushMessage(
          title: 'too big',
          body: huge,
          data: {'blob': huge},
          priority: PushPriority.normal,
        ),
        deviceIds: [devices.first.id!],
      );
      return 'ERROR: oversized payload was accepted (should have thrown).';
    } on PushPayloadTooLargeException catch (e) {
      return 'rejected as expected: $e';
    }
  }

  Future<String> _multiDevices(
    final Session session, {
    required final int count,
  }) async {
    final user = 'matrix-multi-$count';
    await _ensureSyntheticDevices(session, user: user, count: count);
    provider.arm(
      FcmScriptedOutcome(PushDeliveryOutcome.accepted, count: count),
    );
    final result = await PushNotifications.sendToUsers(
      session,
      message: PushMessage(
        title: 'multi $count',
        data: {'case': 'multi', 'count': '$count'},
        priority: PushPriority.high,
      ),
      userIdentifiers: [user],
    );
    await _drainScripted(session);
    final rows = await _deliveriesFor(session, result.notificationId);
    provider.clear();
    return '${_formatEnqueue(result, rows)}\n'
        'Expect deliveriesCreated=$count.';
  }

  Future<String> _queueBurst(
    final Session session, {
    required final int count,
  }) async {
    final user = 'matrix-queue-$count';
    await _ensureSyntheticDevices(session, user: user, count: 1);
    provider.arm(
      FcmScriptedOutcome(PushDeliveryOutcome.accepted, count: count),
    );
    final created = <UuidValue?>[];
    for (var i = 0; i < count; i++) {
      final result = await PushNotifications.sendToUsers(
        session,
        message: PushMessage(
          title: 'burst $i',
          data: {'case': 'queue', 'i': '$i'},
          priority: PushPriority.normal,
        ),
        userIdentifiers: [user],
      );
      created.add(result.notificationId);
    }
    await _drainScripted(session);
    provider.clear();
    final report = await _queueReport(session, label: 'after burst=$count');
    return 'enqueued $count notifications '
        '(first=${created.first}, last=${created.last}).\n$report';
  }

  Future<String> _queueReport(
    final Session session, {
    required final String label,
  }) async {
    final all = await PushDelivery.db.find(session);
    final counts = <String, int>{};
    for (final row in all) {
      counts.update(
        row.status.name,
        (final v) => v + 1,
        ifAbsent: () => 1,
      );
    }
    final sorted = counts.entries.toList()
      ..sort((final a, final b) => a.key.compareTo(b.key));
    final body = sorted.map((final e) => '${e.key}=${e.value}').join(', ');
    return 'queue ($label): total=${all.length}${body.isEmpty ? '' : ', $body'}';
  }

  // --- helpers -------------------------------------------------------------

  /// Collapses `android-device` + `android-device-onesignal` (and the web pair)
  /// to one row.
  /// Prefers FCM when both providers are registered for the same install.
  List<PushDevice> _onePerPhysicalDevice(final List<PushDevice> devices) {
    final byKey = <String, PushDevice>{};
    for (final device in devices) {
      final key = _physicalKey(device);
      final existing = byKey[key];
      if (existing == null ||
          (existing.provider != 'fcm' && device.provider == 'fcm')) {
        byKey[key] = device;
      }
    }
    return byKey.values.toList();
  }

  String _physicalKey(final PushDevice device) {
    final install = device.installationId;
    if (install == null || install.isEmpty) {
      return '${device.provider}:${device.identityHash}';
    }
    for (final suffix in const ['-onesignal', '-sns']) {
      if (install.endsWith(suffix)) {
        return install.substring(0, install.length - suffix.length);
      }
    }
    return install;
  }

  List<PushDevice> _realDevices(final List<PushDevice> devices) {
    return [
      for (final device in devices)
        if (_isRealCredential(device.credential)) device,
    ];
  }

  bool _isRealCredential(final String credential) {
    if (credential.isEmpty) return false;
    const prefixes = [
      'synthetic-',
      'matrix-',
      'dead-token-',
      'refreshed-',
    ];
    for (final prefix in prefixes) {
      if (credential.startsWith(prefix)) return false;
    }
    return true;
  }

  Future<List<PushDevice>> _liveDevices(final Session session) {
    return PushDevice.db.find(
      session,
      where: (final t) => t.disabledAt.equals(null),
    );
  }

  Future<PushEnqueueResult> _enqueueToLiveOrSynthetic(
    final Session session, {
    required final String title,
    required final Map<String, String> data,
  }) async {
    var devices = await _liveDevices(session);
    if (devices.isEmpty) {
      await _ensureSyntheticDevices(
        session,
        user: 'matrix-fallback',
        count: 1,
      );
      devices = await _liveDevices(session);
    }
    return PushNotifications.sendToDevices(
      session,
      message: PushMessage(
        title: title,
        body: title,
        data: data,
        priority: PushPriority.high,
      ),
      deviceIds: [for (final d in devices.take(1)) d.id!],
    );
  }

  Future<void> _ensureSyntheticDevices(
    final Session session, {
    required final String user,
    required final int count,
  }) async {
    for (var i = 0; i < count; i++) {
      final credential = 'synthetic-$user-$i';
      await PushDevices.register(
        session,
        provider: 'fcm',
        credential: credential,
        platform: PushPlatform.android,
        installationId: 'install-$user-$i',
      );
      await _forceUser(session, credential: credential, user: user);
    }
  }

  Future<void> _forceUser(
    final Session session, {
    required final String credential,
    required final String user,
  }) async {
    final device = await PushDevice.db.findFirstRow(
      session,
      where: (final t) => t.credential.equals(credential),
    );
    if (device == null) return;
    await PushDevice.db.updateRow(
      session,
      device.copyWith(userIdentifier: user),
      columns: (final t) => [t.userIdentifier],
    );
  }

  Future<List<PushDelivery>> _deliveriesFor(
    final Session session,
    final UuidValue? notificationId,
  ) async {
    if (notificationId == null) return const [];
    return PushDelivery.db.find(
      session,
      where: (final t) => t.notificationId.equals(notificationId),
    );
  }

  Future<void> _drainScripted(final Session session) async {
    final dispatcher = PushStore.instance.dispatcher;
    if (dispatcher == null) return;
    await dispatcher.runCycleForTest();
    await Future<void>.delayed(const Duration(milliseconds: 50));
  }

  Future<void> _forceMaintenance(final Session session) async {
    final dispatcher = PushStore.instance.dispatcher;
    if (dispatcher == null) return;
    await dispatcher.runCycleForTest(forceMaintenance: true);
  }

  Future<void> _bumpDue(
    final Session session,
    final UuidValue? notificationId,
  ) async {
    if (notificationId == null) return;
    await PushDelivery.db.updateWhere(
      session,
      columnValues: (final t) => [
        t.nextAttemptAt(DateTime.utc(2020)),
      ],
      where: (final t) =>
          t.notificationId.equals(notificationId) &
          t.status.equals(PushDeliveryStatus.failed),
    );
  }

  Future<void> _ageClaims(final Session session) async {
    await PushDelivery.db.updateWhere(
      session,
      columnValues: (final t) => [
        t.claimedAt(
          DateTime.now().toUtc().subtract(const Duration(minutes: 10)),
        ),
      ],
      where: (final t) => t.status.equals(PushDeliveryStatus.sending),
    );
  }

  Future<void> _releaseSending(final Session session) async {
    await PushDelivery.db.updateWhere(
      session,
      columnValues: (final t) => [
        t.status(PushDeliveryStatus.pending),
        t.claimedBy(null),
        t.claimedAt(null),
        t.nextAttemptAt(DateTime.now().toUtc()),
      ],
      where: (final t) => t.status.equals(PushDeliveryStatus.sending),
    );
  }

  Future<void> _waitForTerminal(
    final Session session,
    final UuidValue? notificationId,
  ) async {
    if (notificationId == null) return;
    await _waitUntil(
      () => _deliveriesFor(session, notificationId),
      (final rows) =>
          rows.isNotEmpty &&
          rows.every(
            (final r) =>
                r.status != PushDeliveryStatus.pending &&
                r.status != PushDeliveryStatus.sending &&
                r.status != PushDeliveryStatus.failed,
          ),
      timeout: const Duration(seconds: 20),
    );
  }

  Future<T> _waitUntil<T>(
    final Future<T> Function() read,
    final bool Function(T value) ok, {
    final Duration timeout = const Duration(seconds: 8),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (true) {
      final value = await read();
      if (ok(value)) return value;
      if (DateTime.now().isAfter(deadline)) return value;
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
  }

  String _formatEnqueue(
    final PushEnqueueResult result,
    final List<PushDelivery> rows,
  ) {
    return 'enqueued created=${result.deliveriesCreated} '
        'deduped=${result.deduped} id=${result.notificationId}\n'
        '${_formatRows(rows)}';
  }

  String _formatRows(final List<PushDelivery> rows) {
    if (rows.isEmpty) return '(no delivery rows)';
    return rows
        .map(
          (final r) =>
              '- ${r.id}: status=${r.status.name} attempts=${r.attempts} '
              'claims=${r.claimCount} backoff=${r.backoffExponent} '
              'by=${r.claimedBy}',
        )
        .join('\n');
  }

  String _short(final String value) {
    if (value.length <= 18) return value;
    return '${value.substring(0, 16)}…';
  }
}
