import 'package:flutter/material.dart';

class _LoadingBarrier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

void showLoadingBarrier({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _LoadingBarrier();
    },
    barrierDismissible: false,
  );
}
