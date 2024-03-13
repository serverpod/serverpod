import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_email_flutter/src/auth.dart';

const _defaultMaxPasswordLength = 128;
const _defaultMinPasswordLength = 8;

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

  /// Creates a new sign in with email dialog.
  const SignInWithEmailDialog({
    super.key,
    required this.caller,
    required this.onSignedIn,
    this.maxPasswordLength = _defaultMaxPasswordLength,
    this.minPasswordLength = _defaultMinPasswordLength,
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

  _Page _page = _Page.createAccount;

  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    _emailAuth = EmailAuthController(widget.caller);
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
            hintText: 'User name',
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
            hintText: 'Email',
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
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
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
          onPressed: _enabled ? _createAccount : null,
          child: const Text('Create Account'),
        ),
        TextButton(
          onPressed: _enabled
              ? () {
                  setState(() {
                    _page = _Page.signIn;
                  });
                }
              : null,
          child: const Text('I have an account'),
        ),
      ];
    } else if (_page == _Page.signIn) {
      widgets = [
        TextField(
          enabled: _enabled,
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Email',
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
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
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
          onPressed: _enabled ? _signIn : null,
          child: const Text('Sign In'),
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
              child: const Text('Forgot Pass'),
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
              child: const Text('Create Account'),
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
            hintText: 'Email',
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
          child: const Text('Reset Password'),
        ),
        TextButton(
          onPressed: _enabled
              ? () {
                  setState(() {
                    _page = _Page.signIn;
                  });
                }
              : null,
          child: const Text('Back'),
        ),
      ];
    } else if (_page == _Page.confirmEmail) {
      widgets = [
        const Text(
          'Please check your email. We have sent you a code to verify your address.',
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          enabled: _enabled,
          controller: _validationCodeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Validation code',
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
          child: const Text('Sign In'),
        ),
        TextButton(
          onPressed: _enabled
              ? () {
                  setState(() {
                    _page = _Page.signIn;
                  });
                }
              : null,
          child: const Text('Back'),
        ),
      ];
    } else if (_page == _Page.confirmPasswordReset) {
      widgets = [
        const Text(
          'Please check your email. We have sent you a code to verify your account.',
        ),
        const SizedBox(
          height: 16,
        ),
        TextField(
          enabled: _enabled,
          controller: _validationCodeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Validation code',
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
            hintText: 'New password',
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
          child: const Text('Sign In'),
        ),
        TextButton(
          onPressed: _enabled
              ? () {
                  setState(() {
                    _page = _Page.signIn;
                  });
                }
              : null,
          child: const Text('Back'),
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
        _userNameIssue = 'Please enter a user name';
      });
      return;
    }

    var email = _emailController.text.trim().toLowerCase();
    if (!EmailValidator.validate(email)) {
      setState(() {
        _emailIssue = 'Invalid email';
      });
      return;
    }

    var password = _passwordController.text;
    if (password.length < widget.minPasswordLength) {
      setState(() {
        _passwordIssue = 'Minimum ${widget.minPasswordLength} characters';
      });
      return;
    }
    if (password.length > widget.maxPasswordLength) {
      setState(() {
        _passwordIssue = 'Maximum ${widget.maxPasswordLength} characters';
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
        _emailIssue = 'Email already in use';
      }
    });
  }

  Future<void> _validateAccount() async {
    _resetIssues();
    if (_validationCodeController.text.isEmpty) {
      setState(() {
        _validationCodeIssue = 'Enter your code';
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
        _validationCodeIssue = 'Incorrect code';
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
        _emailIssue = 'Invalid email';
      });
      return;
    }

    var password = _passwordController.text;
    if (password.length < widget.minPasswordLength) {
      setState(() {
        _passwordIssue = 'Minimum ${widget.minPasswordLength} characters';
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
        _passwordIssue = 'Incorrect password';
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
        _emailIssue = 'Invalid email';
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
    if (_passwordController.text.length < 8) {
      setState(() {
        _passwordIssue = 'Min 8 characters';
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
        _validationCodeIssue = 'Incorrect code';
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
}) {
  showDialog(
    context: context,
    builder: (context) {
      return SignInWithEmailDialog(
        caller: caller,
        onSignedIn: onSignedIn,
        maxPasswordLength: maxPasswordLength ?? _defaultMaxPasswordLength,
        minPasswordLength: minPasswordLength ?? _defaultMinPasswordLength,
      );
    },
  );
}
