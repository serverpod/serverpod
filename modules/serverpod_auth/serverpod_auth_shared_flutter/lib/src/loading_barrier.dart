import 'package:flutter/material.dart';

class _LoadingBarrier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

/// Shows an non-dismissible barrier with a [CircularProgressIndicator]. Used
/// to show progress and block user input when signing in.
void showLoadingBarrier({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _LoadingBarrier();
    },
    barrierDismissible: false,
  );
}
