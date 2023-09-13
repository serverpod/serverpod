import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:serverpod_auth_sms_flutter/serverpod_auth_sms_flutter.dart';

import 'res/country_model.dart';
import 'res/country_name.dart';
import 'res/get_country.dart';
import 'widgets/otp_widget.dart';
import 'widgets/phone_number_widget.dart';

enum _Page {
  signIn,
  verify,
}

/// A dialog that allows the user to sign in with SMS.
// ignore: must_be_immutable
class SignInWithSMSDialog extends StatefulWidget {
  /// A reference to the auth module as retrieved from the client object.
  final Caller caller;

  /// Callback that is called when the user has successfully signed in.
  final VoidCallback onSignedIn;

  /// Country code. Defaults to India.
  CountryName defaultCountry;

  SignInWithSMSDialog({
    Key? key,
    required this.caller,
    required this.onSignedIn,
    required this.defaultCountry,
  }) : super(key: key);

  @override
  SignInWithSMSDialogState createState() => SignInWithSMSDialogState();
}

class SignInWithSMSDialogState extends State<SignInWithSMSDialog> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  late CountryModel _selectedCountry;
  String? _phoneNumberIssue;
  String? _otpIssue;

  late String _phoneNumberWithCountryCode;

  late final SMSAuthController _smsAuth;

  _Page _page = _Page.signIn;

  bool _enabled = true;
  late String _storedHash;

  @override
  void initState() {
    super.initState();
    _smsAuth = SMSAuthController(widget.caller);
    _selectedCountry = getCountryDisplayName(widget.defaultCountry);
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _phoneNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;
    if (_page == _Page.signIn) {
      widgets = [
        PhoneNumberWidget(
          defaultCountry: CountryName.India,
          onCountryChanged: (country) {
            setState(() {
              _selectedCountry = country;
            });
          },
          phoneNumberController: _phoneNumberController,
          phoneNumberIssue: _phoneNumberIssue,
        ),
        ElevatedButton(
          onPressed: _enabled ? _startAuthentication : null,
          child: const Text('Sign in'),
        )
      ];
    } else if (_page == _Page.verify) {
      widgets = [
        OTPWidget(otpController: _otpController, otpIssue: _otpIssue),
        ElevatedButton(
          onPressed: _enabled ? _verifyAuthentication : null,
          child: const Text('Verify'),
        )
      ];
    } else {
      throw UnimplementedError("Unknown page: $_page");
    }
    return Dialog(
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
        width: 280,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widgets,
        ),
      ),
    );
  }

  /// Starts the authentication process with SMS.
  Future<void> _startAuthentication() async {
    _resetIssues();
    var phoneNumber = _phoneNumberController.text.trim();
    if (phoneNumber.isEmpty) {
      setState(() {
        _phoneNumberIssue = 'Please enter a phone number';
      });
      return;
    }
    if (phoneNumber.length < 10) {
      setState(() {
        _phoneNumberIssue = 'Please enter a valid phone number';
      });
      return;
    }

    setState(() {
      _phoneNumberWithCountryCode =
          '+${_selectedCountry.e164Cc} ${_phoneNumberController.text.trim()}';
      _enabled = false;
    });

    var result =
        await _smsAuth.signInWithSMS(phoneNumber: _phoneNumberWithCountryCode);

    if (result.success == false) {
      switch (result.failReason) {
        case AuthenticationFailReason.internalError:
          setState(() {
            _phoneNumberIssue = 'Internal error';
            _enabled = true;
          });
          return;
        case AuthenticationFailReason.tooManyFailedAttempts:
          setState(() {
            _phoneNumberIssue = 'Too many failed attempts';
          });
          return;
        case AuthenticationFailReason.userCreationDenied:
          setState(() {
            _phoneNumberIssue = 'Something went wrong';
            _enabled = true;
          });
          return;
        default:
          setState(() {
            _phoneNumberIssue = 'Something went wrong';
            _enabled = true;
          });
          return;
      }
    }

    setState(() {
      _enabled = true;
      _storedHash = result.hash!;
      _page = _Page.verify;
    });
  }

  /// Verifies the authentication.
  Future<void> _verifyAuthentication() async {
    _resetIssues();
    if (_otpController.text.isEmpty) {
      setState(() {
        _otpIssue = 'OTP is required';
      });
      return;
    }

    setState(() {
      _enabled = false;
    });

    var result = await _smsAuth.verifySMS(
      phoneNumber: _phoneNumberWithCountryCode,
      otp: _otpController.text.trim(),
      storedHash: _storedHash,
    );
    if (result.success == false) {
      switch (result.failReason) {
        case AuthenticationFailReason.invalidCredentials:
          setState(() {
            _otpIssue = 'Invalid OTP';
            _enabled = true;
          });
          _resetTextFields();
          return;
        case AuthenticationFailReason.internalError:
          setState(() {
            _otpIssue = 'Internal error';
            _enabled = true;
          });
          return;
        case AuthenticationFailReason.tooManyFailedAttempts:
          setState(() {
            _otpIssue = 'Too many failed attempts';
          });
          return;
        case AuthenticationFailReason.userCreationDenied:
          setState(() {
            _otpIssue = 'Something went wrong';
            _enabled = true;
          });
          return;
        default:
          setState(() {
            _otpIssue = 'Something went wrong';
            _enabled = true;
          });
          return;
      }
    }

    if (mounted) {
      Navigator.of(context).pop();
    }
    widget.onSignedIn();
  }

  /// Resets the issues.
  void _resetIssues() {
    setState(() {
      _phoneNumberIssue = null;
      _otpIssue = null;
    });
  }

  /// Resets the text fields.
  void _resetTextFields() {
    setState(() {
      _phoneNumberController.text = '';
      _otpController.text = '';
    });
  }
}

/// shows a dialog that allows the user to sign in with SMS.
void showSignInWithSMSDialog({
  required BuildContext context,
  required Caller caller,
  required VoidCallback onSignedIn,
  required CountryName defaultCountry,
}) {
  showDialog(
    context: context,
    builder: (context) => SignInWithSMSDialog(
      caller: caller,
      onSignedIn: onSignedIn,
      defaultCountry: defaultCountry,
    ),
  );
}
