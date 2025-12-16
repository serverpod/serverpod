import 'dart:async';

import 'package:flutter/material.dart';

import '../gaps.dart';

/// A widget that displays a "didn't receive? Send a new code" button.
///
/// The button is disabled during the countdown timer and shows the remaining
/// time. After the timer expires, the button becomes enabled and can be pressed
/// to resend the verification code.
class ResendCodeButton extends StatefulWidget {
  /// The controller that manages authentication state and logic.
  final Future<void> Function() onResendPressed;

  /// The duration of the countdown timer. Defaults to 1 minute.
  final Duration countdownDuration;

  /// Creates a [ResendCodeButton] widget.
  const ResendCodeButton({
    required this.onResendPressed,
    this.countdownDuration = const Duration(minutes: 1),
    super.key,
  });

  @override
  State<ResendCodeButton> createState() => _ResendCodeButtonState();
}

class _ResendCodeButtonState extends State<ResendCodeButton> {
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = widget.countdownDuration.inSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _handleResend() async {
    if (_remainingSeconds > 0 || _isResending) return;

    setState(() {
      _isResending = true;
    });

    try {
      await widget.onResendPressed();
      _startTimer();
    } catch (e) {
      // Error is handled by the controller's error state
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    if (minutes > 0) {
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return seconds.toString();
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = _remainingSeconds == 0 && !_isResending;
    const label = "Didn't receive? Send a new code";

    return Column(
      children: [
        tinyGap,
        TextButton(
          onPressed: isEnabled ? _handleResend : null,
          child: _remainingSeconds > 0
              ? Text("$label (${_formatTime(_remainingSeconds)})")
              : const Text(label),
        ),
      ],
    );
  }
}
