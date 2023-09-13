import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//ignore: must_be_immutable
class OTPWidget extends StatefulWidget {
  final TextEditingController otpController;
  String? otpIssue;
  OTPWidget({
    required this.otpController,
    this.otpIssue,
    Key? key,
  }) : super(key: key);

  @override
  _OTPWidgetState createState() => _OTPWidgetState();
}

class _OTPWidgetState extends State<OTPWidget> {
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
          setState(() {
            widget.otpIssue = null;
          });
        },
      ),
    );
  }
}
