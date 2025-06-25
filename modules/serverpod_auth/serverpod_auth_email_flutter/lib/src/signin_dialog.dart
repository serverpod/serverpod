import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_email_flutter/src/auth.dart';
import 'package:serverpod_auth_email_flutter/src/signin_labels.dart';

const _defaultMaxPasswordLength = 128;
const _defaultMinPasswordLength = 8;

/// Configure the initial page of the sign in dialog.
enum InitPage {
  /// Use sign in as the initial page.
  signIn._(_Page.signIn),

  /// Use create account as the initial page.
  createAccount._(_Page.createAccount);

  const InitPage._(this._page);

  final _Page _page;
}

enum _Page {
  createAccount,
  confirmEmail,
  signIn,
  forgotPassword,
  confirmPasswordReset,
}

/// A dialog for signing in with email and password.
class SignInWithEmailDialog extends StatefulWidget {
  /// A reference to the auth module as retrieved from the client object.
  final Caller caller;

  /// Callback that is called when the user has successfully signed in.
  final VoidCallback onSignedIn;

  /// The maximum length of the password.
  final int maxPasswordLength;

  /// The minimum length of the password.
  final int minPasswordLength;

  /// Optional labels for the sign in with email dialog.
  /// If null, default English labels will be used.
  final SignInWithEmailDialogLabels? localization;

  /// Optionally configure the initial page to show in the dialog.
  /// If null, defaults to [InitPage.createAccount].
  final InitPage? initPage;

  /// Creates a new sign in with email dialog.
  const SignInWithEmailDialog({
    super.key,
    required this.caller,
    required this.onSignedIn,
    this.maxPasswordLength = _defaultMaxPasswordLength,
    this.minPasswordLength = _defaultMinPasswordLength,
    this.localization,
    this.initPage,
  });

  @override
  SignInWithEmailDialogState createState() => SignInWithEmailDialogState();
}

/// State for the sign in with email dialog.
class SignInWithEmailDialogState extends State<SignInWithEmailDialog> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _validationCodeController =
      TextEditingController();

  String? _userNameIssue;
  String? _emailIssue;
  String? _passwordIssue;
  String? _validationCodeIssue;

  late final EmailAuthController _emailAuth;
  late final SignInWithEmailDialogLabels _localization;

  late _Page _page;

  bool _enabled = true;
  bool _isPasswordObscured = true;

  @override
  void initState() {
    super.initState();
    _emailAuth = EmailAuthController(widget.caller);
    _localization = widget.localization ?? SignInWithEmailDialogLabels.enUS();
    _page = widget.initPage?._page ?? _Page.createAccount;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets;

    if (_page == _Page.createAccount) {
      widgets = [
        TextField(
          enabled: _enabled,
          controller: _usernameController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: _localization.inputHintUserName,
            helperText: ' ',
            errorText: _userNameIssue,
          ),
          onChanged: (_) {
            setState(() {
              _userNameIssue = null;
            });
          },
        ),
        TextField(
          enabled: _enabled,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: _localization.inputHintEmail,
            helperText: ' ',
            errorText: _emailIssue,
          ),
          onChanged: (_) {
            setState(() {
              _emailIssue = null;
            });
          },
        ),
        TextField(
          enabled: _enabled,
          controller: _passwordController,
          obscureText: _isPasswordObscured,
          decoration: InputDecoration(
            hintText: _localization.inputHintPassword,
            helperText: ' ',
            errorText: _passwordIssue,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordObscured = !_isPasswordObscured;
                });
              },
            ),
          ),
          onChanged: (_) {
            setState(() {
              _passwordIssue = null;
            });
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: _enabled ? _createAccount : null,
          child: Text(_localization.buttonTitleSignUp),
        ),
        TextButton(
          onPressed: _enabled
              ? () {
                  setState(() {
                    _page = _Page.signIn;
                  });
                }
              : null,
          child: Text(_localization.buttonTitleOpenSignIn),
        ),
      ];
    } else if (_page == _Page.signIn) {
      widgets = [
        TextField(
          enabled: _enabled,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: _localization.inputHintEmail,
            helperText: ' ',
            errorText: _emailIssue,
          ),
          onChanged: (_) {
            setState(() {
              _emailIssue = null;
            });
          },
        ),
        TextField(
          enabled: _enabled,
          controller: _passwordController,
          obscureText: _isPasswordObscured,
          decoration: InputDecoration(
            hintText: _localization.inputHintPassword,
            helperText: ' ',
            errorText: _passwordIssue,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordObscured ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordObscured = !_isPasswordObscured;
                });
              },
            ),
          ),
          onChanged: (_) {
            setState(() {
              _passwordIssue = null;
            });
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: _enabled ? _signIn : null,
          child: Text(_localization.buttonTitleSignIn),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _page = _Page.forgotPassword;
                });
              },
              child: Text(_localization.buttonTitleForgotPassword),
            ),
            const Spacer(),
            TextButton(
              onPressed: _enabled
                  ? () {
                      setState(() {
                        _page = _Page.createAccount;
                      });
                    }
                  : null,
              child: Text(_localization.buttonTitleOpenSignUp),
            ),
          ],
        ),
      ];
    } else if (_page == _Page.forgotPassword) {
      widgets = [
        TextField(
          enabled: _enabled,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: _localization.inputHintEmail,
            helperText: ' ',
            errorText: _emailIssue,
          ),
          onChanged: (_) {
            setState(() {
              _emailIssue = null;
            });
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: _enabled ? _initiatePasswordReset : null,
          child: Text(_localization.buttonTitleResetPassword),
        ),
        TextButton(
          onPressed: _enabled
              ? () {
                  setState(() {
                    _page = _Page.signIn;
                  });
                }
              : null,
          child: Text(_localization.buttonTitleBack),
        ),
      ];
    } else if (_page == _Page.confirmEmail) {
      widgets = [
        Text(
          _localization.messageEmailVerificationSent,
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          enabled: _enabled,
          controller: _validationCodeController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: _localization.inputHintValidationCode,
            helperText: ' ',
            errorText: _validationCodeIssue,
          ),
          onChanged: (_) {
            setState(() {
              _passwordIssue = null;
            });
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: _enabled ? _validateAccount : null,
          child: Text(_localization.buttonTitleSignIn),
        ),
        TextButton(
          onPressed: _enabled
              ? () {
                  setState(() {
                    _page = _Page.signIn;
                  });
                }
              : null,
          child: Text(_localization.buttonTitleBack),
        ),
      ];
    } else if (_page == _Page.confirmPasswordReset) {
      widgets = [
        Text(
          _localization.messagePasswordResetSent,
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          enabled: _enabled,
          controller: _validationCodeController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: _localization.inputHintValidationCode,
            helperText: ' ',
            errorText: _validationCodeIssue,
          ),
          onChanged: (_) {
            setState(() {
              _passwordIssue = null;
            });
          },
        ),
        TextField(
          enabled: _enabled,
          maxLength: widget.maxPasswordLength,
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: _localization.inputHintNewPassword,
            helperText: ' ',
            errorText: _passwordIssue,
          ),
          onChanged: (_) {
            setState(() {
              _passwordIssue = null;
            });
          },
        ),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
          onPressed: _enabled ? _resetPassword : null,
          child: Text(_localization.buttonTitleSignIn),
        ),
        TextButton(
          onPressed: _enabled
              ? () {
                  setState(() {
                    _page = _Page.signIn;
                  });
                }
              : null,
          child: Text(_localization.buttonTitleBack),
        ),
      ];
    } else {
      throw UnimplementedError('Unexpected state $_page');
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

  Future<void> _createAccount() async {
    _resetIssues();
    var userName = _usernameController.text.trim();
    if (userName.isEmpty) {
      setState(() {
        _userNameIssue = _localization.errorMessageUserNameRequired;
      });
      return;
    }

    var email = _emailController.text.trim().toLowerCase();
    if (!EmailValidator.validate(email)) {
      setState(() {
        _emailIssue = _localization.errorMessageInvalidEmail;
      });
      return;
    }

    var password = _passwordController.text;
    if (password.length < widget.minPasswordLength) {
      setState(() {
        _passwordIssue =
            _localization.minimumLengthMessage(widget.minPasswordLength);
      });
      return;
    }
    if (password.length > widget.maxPasswordLength) {
      setState(() {
        _passwordIssue =
            _localization.maximumLengthMessage(widget.maxPasswordLength);
      });
      return;
    }

    setState(() {
      _enabled = false;
    });

    var success = await _emailAuth.createAccountRequest(
      userName,
      email,
      password,
    );

    setState(() {
      _enabled = true;

      if (success) {
        _page = _Page.confirmEmail;
      } else {
        _emailIssue = _localization.errorMessageEmailInUse;
      }
    });
  }

  Future<void> _validateAccount() async {
    _resetIssues();
    if (_validationCodeController.text.isEmpty) {
      setState(() {
        _validationCodeIssue = _localization.messageEnterCode;
      });
      return;
    }
    var email = _emailController.text.toLowerCase().trim();

    setState(() {
      _enabled = false;
    });

    var userInfo = await _emailAuth.validateAccount(
      email,
      _validationCodeController.text,
    );

    if (userInfo == null) {
      setState(() {
        _validationCodeIssue = _localization.errorMessageIncorrectCode;
        _enabled = true;
      });
      return;
    }

    // We've setup the account, sign in!
    var result = await _emailAuth.signIn(email, _passwordController.text);
    if (result == null) {
      // Something went wrong, start over
      setState(() {
        _page = _Page.createAccount;
        _enabled = true;
      });
      return;
    }

    // Pop dialog
    if (mounted) {
      Navigator.of(context).pop();
    }
    widget.onSignedIn();
  }

  Future<void> _signIn() async {
    _resetIssues();
    var email = _emailController.text.trim().toLowerCase();
    if (!EmailValidator.validate(email)) {
      setState(() {
        _emailIssue = _localization.errorMessageInvalidEmail;
      });
      return;
    }

    var password = _passwordController.text;
    if (password.length < widget.minPasswordLength) {
      setState(() {
        _passwordIssue =
            _localization.minimumLengthMessage(widget.minPasswordLength);
      });
      return;
    }

    setState(() {
      _enabled = false;
    });

    var result = await _emailAuth.signIn(email, password);
    if (result == null) {
      // Something went wrong, start over
      setState(() {
        _passwordIssue = _localization.errorMessageIncorrectPassword;
        _enabled = true;
      });
      return;
    }

    // Pop dialog
    if (mounted) {
      Navigator.of(context).pop();
    }
    widget.onSignedIn();
  }

  Future<void> _initiatePasswordReset() async {
    _resetIssues();
    var email = _emailController.text.trim().toLowerCase();
    if (!EmailValidator.validate(email)) {
      setState(() {
        _emailIssue = _localization.errorMessageInvalidEmail;
      });
      return;
    }

    setState(() {
      _enabled = false;
    });

    await _emailAuth.initiatePasswordReset(email);

    setState(() {
      _page = _Page.confirmPasswordReset;
      _enabled = true;
    });
  }

  Future<void> _resetPassword() async {
    _resetIssues();
    if (_passwordController.text.length < widget.minPasswordLength) {
      setState(() {
        _passwordIssue =
            _localization.minimumLengthMessage(widget.minPasswordLength);
      });
      return;
    }

    var email = _emailController.text.trim().toLowerCase();

    setState(() {
      _enabled = false;
    });

    var success = await _emailAuth.resetPassword(
      email,
      _validationCodeController.text,
      _passwordController.text,
    );

    if (!success) {
      setState(() {
        _validationCodeIssue = _localization.errorMessageIncorrectCode;
        _enabled = true;
      });
      return;
    }

    var result = await _emailAuth.signIn(email, _passwordController.text);
    if (result == null) {
      // Something went wrong, start over
      setState(() {
        _resetTextFields();
        _page = _Page.signIn;
        _enabled = true;
      });
      return;
    }

    // Pop dialog
    if (mounted) {
      Navigator.of(context).pop();
    }
    widget.onSignedIn();
  }

  void _resetIssues() {
    setState(() {
      _emailIssue = '';
      _passwordIssue = '';
      _validationCodeIssue = '';
      _userNameIssue = '';
    });
  }

  void _resetTextFields() {
    setState(() {
      _validationCodeController.text = '';
      _passwordController.text = '';
      _emailController.text = '';
      _usernameController.text = '';
    });
  }
}

/// Shows a dialog that allows the user to sign in with email.
void showSignInWithEmailDialog({
  required BuildContext context,
  required Caller caller,
  required VoidCallback onSignedIn,
  int? maxPasswordLength,
  int? minPasswordLength,
  SignInWithEmailDialogLabels? localization,
  InitPage? initPage,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return SignInWithEmailDialog(
        caller: caller,
        onSignedIn: onSignedIn,
        maxPasswordLength: maxPasswordLength ?? _defaultMaxPasswordLength,
        minPasswordLength: minPasswordLength ?? _defaultMinPasswordLength,
        localization: localization,
        initPage: initPage,
      );
    },
  );
}
