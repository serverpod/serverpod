import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OTPWidget extends StatefulWidget {
  final TextEditingController otpController;
  final String? otpIssue;
  final void Function(String?)? updateIssue;
  const OTPWidget({
    required this.otpController,
    required this.otpIssue,
    required this.updateIssue,
    Key? key,
  }) : super(key: key);

  @override
  OTPWidgetState createState() => OTPWidgetState();
}

class OTPWidgetState extends State<OTPWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(6)
        ],
        controller: widget.otpController,
        decoration: InputDecoration(
          labelText: 'OTP',
          errorText: widget.otpIssue,
        ),
        onChanged: (_) {
          widget.updateIssue?.call(null);
        },
      ),
    );
  }
}
