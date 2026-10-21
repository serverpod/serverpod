import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

/// Opens a sheet for adding another sign-in method to the signed-in account.
///
/// The user stays signed in to their current account throughout: whichever
/// provider they pick is linked to it, and if that sign-in method already
/// belongs to a separate account they are asked whether to merge the two.
Future<void> showLinkAccountSheet(
  final BuildContext context, {
  required final ServerpodClientShared client,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (final sheetContext) => _LinkAccountSheet(client: client),
  );
}

class _LinkAccountSheet extends StatefulWidget {
  const _LinkAccountSheet({required this.client});

  final ServerpodClientShared client;

  @override
  State<_LinkAccountSheet> createState() => _LinkAccountSheetState();
}

class _LinkAccountSheetState extends State<_LinkAccountSheet> {
  late final AccountLinkingController _controller = AccountLinkingController(
    client: widget.client,
    confirmMerge: _confirmMerge,
    onLinked: _onLinked,
    onCancelled: _onCancelled,
    onError: _onError,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<bool> _confirmMerge(final AccountLinkConflict conflict) async {
    final describedAs =
        conflict.profile?.email ??
        conflict.profile?.userName ??
        conflict.profile?.fullName ??
        'another account';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (final dialogContext) => AlertDialog(
        title: const Text('Combine accounts?'),
        content: Text(
          'You already have an account for $describedAs, created on '
          '${_formatDate(conflict.createdAt)}. Combining moves it into the '
          'account you are signed in to, and the other account is removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Combine'),
          ),
        ],
      ),
    );

    return confirmed ?? false;
  }

  void _onLinked() {
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sign-in method linked.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _onCancelled() {
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  void _onError(final Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Linking failed: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  static String _formatDate(final DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Text(
            'Link another sign-in method',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SignInWidget(
            client: widget.client,
            accountLinking: _controller,
          ),
        ],
      ),
    );
  }
}
