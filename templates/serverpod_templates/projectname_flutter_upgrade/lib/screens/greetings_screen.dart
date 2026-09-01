import 'package:flutter/material.dart';

import '../client.dart';

class GreetingsScreen extends StatefulWidget {
  final Future<void> Function()? onSignOut;
  const GreetingsScreen({super.key, this.onSignOut});

  @override
  State<GreetingsScreen> createState() => _GreetingsScreenState();
}

class _GreetingsScreenState extends State<GreetingsScreen> {
  /// Holds the last result or null if no result exists yet.
  String? _resultMessage;

  /// Holds the last error message that we've received from the server or null
  /// if no error exists yet.
  String? _errorMessage;

  final _textEditingController = TextEditingController();

  /// Calls the `hello` method of the `greeting` endpoint. Will set either the
  /// `_resultMessage` or `_errorMessage` field, depending on if the call
  /// is successful.
  void _callHello() async {
    try {
      final result = await client.greeting.hello(_textEditingController.text);
      setState(() {
        _errorMessage = null;
        _resultMessage = result.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (widget.onSignOut != null) ...[
            const Text('You are connected'),
            ElevatedButton(
              onPressed: widget.onSignOut,
              child: const Text('Sign out'),
            ),
          ],
          const SizedBox(height: 32),
          TextField(
            controller: _textEditingController,
            onSubmitted: (_) => _callHello(),
            decoration: InputDecoration(
              hintText: 'Enter your name',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: _callHello,
                icon: const Icon(Icons.send),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ResultDisplay(
            resultMessage: _resultMessage,
            errorMessage: _errorMessage,
          ),
        ],
      ),
    );
  }
}

/// ResultDisplays shows the result of the call. Either the returned result
/// from the `example.greeting` endpoint method or an error message.
class ResultDisplay extends StatelessWidget {
  final String? resultMessage;
  final String? errorMessage;

  const ResultDisplay({super.key, this.resultMessage, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    String text;
    Color backgroundColor;
    Color foregroundColor;
    if (errorMessage != null) {
      backgroundColor = colors.errorContainer;
      foregroundColor = colors.onErrorContainer;
      text = errorMessage!;
    } else if (resultMessage != null) {
      backgroundColor = colors.primaryContainer;
      foregroundColor = colors.onPrimaryContainer;
      text = resultMessage!;
    } else {
      backgroundColor = colors.surfaceContainerHighest;
      foregroundColor = colors.onSurfaceVariant;
      text = 'No server response yet.';
    }

    return Container(
      constraints: const BoxConstraints(minHeight: 60),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      // Reuses the text field's border so the shape and width always match.
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: OutlineInputBorder(
          borderSide: BorderSide(color: foregroundColor),
        ),
      ),
      child: Center(
        child: Text(text, style: TextStyle(color: foregroundColor)),
      ),
    );
  }
}
