import 'package:flutter/material.dart';
import 'package:serverpod_admin_dashboard/src/controller/admin_dashboard.dart';
import 'package:serverpod_admin_dashboard/src/helpers/admin_resources.dart';
import 'package:serverpod_admin_dashboard/src/widgets/record_dialog.dart';
import 'package:serverpod_admin_dashboard/src/screens/record_details.dart';

/// Business logic operations for the Home screen.
/// Separated from UI to avoid setState usage.
class HomeOperations {
  HomeOperations({
    required this.controller,
    required this.context,
  });

  final AdminDashboardController controller;
  final BuildContext context;

  /// Shows the create record dialog.
  Future<void> showCreateDialog(AdminResource resource) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => RecordDialog(
        resource: resource,
        onSubmit: (payload) => _createRecord(resource, payload),
      ),
    );

    if (created == true) {
      // Records are reloaded in _createRecord
    }
  }

  /// Shows the edit record dialog.
  Future<void> showEditDialog(
    AdminResource resource,
    Map<String, String> record,
  ) async {
    final updated = await showDialog<bool>(
      context: context,
      builder: (context) => RecordDialog(
        resource: resource,
        onSubmit: (payload) => _updateRecord(resource, payload),
        initialValues: record,
        isUpdate: true,
      ),
    );

    if (updated == true) {
      // Records are reloaded in _updateRecord
    }
  }

  /// Shows the record details page.
  void showDetailsPage(
    AdminResource resource,
    Map<String, String> record,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RecordDetails(
          resource: resource,
          record: record,
          onEdit: (record) => showEditDialog(resource, record),
          onDelete: (record) => showDeleteConfirmation(resource, record),
        ),
      ),
    );
  }

  /// Shows the delete confirmation dialog.
  Future<void> showDeleteConfirmation(
    AdminResource resource,
    Map<String, String> record,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete from ${resource.tableName}?'),
        content: const Text(
          'This action cannot be undone. Are you sure you want to delete this record?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _deleteRecord(resource, record);
    }
  }

  Future<bool> _createRecord(
    AdminResource resource,
    Map<String, String> payload,
  ) async {
    try {
      await controller.createRecord(resource, payload);
      if (!context.mounted) return true;
      _showSnackBar(
        '${resource.tableName} created successfully.',
        isError: false,
      );
      return true;
    } catch (error) {
      debugPrint('Failed to create ${resource.key}: $error');
      if (!context.mounted) return false;
      _showSnackBar(
        'Failed to create ${resource.tableName}: $error',
        isError: true,
      );
      return false;
    }
  }

  Future<bool> _updateRecord(
    AdminResource resource,
    Map<String, String> payload,
  ) async {
    try {
      await controller.updateRecord(resource, payload);
      if (!context.mounted) return true;
      _showSnackBar(
        '${resource.tableName} updated successfully.',
        isError: false,
      );
      return true;
    } catch (error) {
      debugPrint('Failed to update ${resource.key}: $error');
      if (!context.mounted) return false;
      _showSnackBar(
        'Failed to update ${resource.tableName}: $error',
        isError: true,
      );
      return false;
    }
  }

  Future<void> _deleteRecord(
    AdminResource resource,
    Map<String, String> record,
  ) async {
    final primaryValue = controller.resolvePrimaryKeyValue(resource, record);
    if (primaryValue == null) {
      debugPrint(
        'Unable to resolve primary key for ${resource.key}, aborting delete.',
      );
      return;
    }

    try {
      await controller.deleteRecord(resource, primaryValue);
      if (!context.mounted) return;
      _showSnackBar(
        '${resource.tableName} deleted successfully.',
        isError: false,
      );
    } catch (error) {
      debugPrint('Failed to delete ${resource.key}: $error');
      if (!context.mounted) return;
      _showSnackBar(
        'Failed to delete ${resource.tableName}: $error',
        isError: true,
      );
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}
