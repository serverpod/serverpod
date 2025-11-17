import 'package:flutter/material.dart';
import 'package:serverpod_admin_dashboard/src/controller/admin_dashboard.dart';
import 'package:serverpod_admin_dashboard/src/export/admin_resources.dart';
import 'package:serverpod_admin_dashboard/src/widgets/footer.dart';
import 'package:serverpod_admin_dashboard/src/widgets/record_dialog.dart';
import 'package:serverpod_admin_dashboard/src/widgets/records_pan.dart';
import 'package:serverpod_admin_dashboard/src/widgets/side_bar.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.controller,
  });

  final AdminDashboardController controller;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<AdminResource> _resources = const [];
  AdminResource? _selectedResource;
  String? _errorMessage;
  bool _isLoading = false;
  List<Map<String, String>> _records = const [];
  bool _isRecordsLoading = false;
  String? _recordsError;
  bool _isSidebarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _loadResources();
  }

  Future<void> _loadResources() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final resources = await widget.controller.adminEndpoint.resources();
      AdminResource? selected;
      if (_selectedResource != null) {
        for (final resource in resources) {
          if (resource.key == _selectedResource!.key) {
            selected = resource;
            break;
          }
        }
      }
      selected ??= resources.isNotEmpty ? resources.first : null;
      if (!mounted) return;
      setState(() {
        _resources = resources;
        _selectedResource = selected;
      });
      if (selected != null) {
        await _loadRecords(selected);
      } else {
        if (mounted) {
          setState(() {
            _records = const [];
          });
        }
      }
    } catch (error) {
      debugPrint('Failed to load admin resources: $error');
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Unable to load resources. Please try again.';
        _resources = const [];
        _selectedResource = null;
        _records = const [];
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _selectResource(AdminResource resource) {
    setState(() {
      _selectedResource = resource;
    });
    _loadRecords(resource);
  }

  Future<void> _loadRecords(AdminResource resource) async {
    setState(() {
      _isRecordsLoading = true;
      _recordsError = null;
    });
    try {
      final records = await widget.controller.adminEndpoint.list(resource.key);
      if (!mounted) return;
      setState(() {
        _records = records;
      });
    } catch (error) {
      debugPrint('Failed to load records for ${resource.key}: $error');
      if (!mounted) return;
      setState(() {
        _recordsError =
            'Unable to load ${resource.tableName} records. Please try again.';
        _records = const [];
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isRecordsLoading = false;
      });
    }
  }

  Future<void> _showEditDialog(
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

    if (updated == true && mounted) {
      await _loadRecords(resource);
    }
  }

  Future<bool> _updateRecord(
    AdminResource resource,
    Map<String, String> payload,
  ) async {
    try {
      await widget.controller.adminEndpoint.update(resource.key, payload);
      if (!mounted) return true;
      await _loadRecords(resource);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${resource.tableName} updated successfully.'),
        ),
      );
      return true;
    } catch (error) {
      debugPrint('Failed to update ${resource.key}: $error');
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update ${resource.tableName}: $error'),
        ),
      );
      return false;
    }
  }

  Future<void> _confirmDelete(
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

  Future<void> _deleteRecord(
    AdminResource resource,
    Map<String, String> record,
  ) async {
    final primaryValue = _resolvePrimaryKeyValue(resource, record);
    if (primaryValue == null) {
      debugPrint(
        'Unable to resolve primary key for ${resource.key}, aborting delete.',
      );
      return;
    }

    try {
      await widget.controller.adminEndpoint.delete(resource.key, primaryValue);
      if (!mounted) return;
      await _loadRecords(resource);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${resource.tableName} deleted successfully.'),
        ),
      );
    } catch (error) {
      debugPrint('Failed to delete ${resource.key}: $error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete ${resource.tableName}: $error'),
        ),
      );
    }
  }

  String? _resolvePrimaryKeyValue(
    AdminResource resource,
    Map<String, String> record,
  ) {
    final primaryColumn =
        resource.columns.firstWhere((column) => column.isPrimary, orElse: () {
      return AdminColumn(
        name: 'id',
        dataType: 'String',
        hasDefault: true,
        isPrimary: true,
      );
    });
    final raw = record[primaryColumn.name];
    if (raw == null || raw.isEmpty) return null;
    return raw;
  }

  Future<void> _showCreateDialog(AdminResource resource) async {
    final created = await showDialog<bool>(
      context: context,
      builder: (context) => RecordDialog(
        resource: resource,
        onSubmit: (payload) => _createRecord(resource, payload),
      ),
    );

    if (created == true && mounted) {
      // Records are reloaded in _createRecord, nothing more to do.
    }
  }

  Future<bool> _createRecord(
    AdminResource resource,
    Map<String, String> payload,
  ) async {
    debugPrint(
      'Admin dashboard submitting to "${resource.key}" with payload: $payload',
    );
    try {
      await widget.controller.adminEndpoint.create(resource.key, payload);
      if (!mounted) return true;
      await _loadRecords(resource);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${resource.tableName} created successfully.'),
        ),
      );
      return true;
    } catch (error) {
      debugPrint('Failed to create ${resource.key}: $error');
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create ${resource.tableName}: $error'),
        ),
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 800;

    return Scaffold(
      appBar: AppBar(
        leading: isSmallScreen
            ? Builder(
                builder: (context) => IconButton(
                  tooltip: 'Open navigation',
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              )
            : null,
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            tooltip: widget.controller.themeMode == ThemeMode.dark
                ? 'Switch to light mode'
                : 'Switch to dark mode',
            onPressed: widget.controller.toggleThemeMode,
            icon: Icon(
              widget.controller.themeMode == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: isSmallScreen
          ? Drawer(
              child: SafeArea(
                child: Sidebar(
                  resources: _resources,
                  isLoading: _isLoading,
                  errorMessage: _errorMessage,
                  selectedResource: _selectedResource,
                  onRetry: _loadResources,
                  onSelect: (resource) {
                    Navigator.of(context).pop(); // close drawer
                    _selectResource(resource);
                  },
                  isCollapsed: false,
                  onToggleCollapse: () {},
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0x1A6A5AE0),
                Color(0x106A5AE0),
                Color(0x006A5AE0),
              ],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1440),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: isSmallScreen
                          ? RecordsPane(
                              resource: _selectedResource,
                              records: _records,
                              isLoading: _isRecordsLoading,
                              errorMessage: _recordsError,
                              onAdd: _selectedResource == null
                                  ? null
                                  : () => _showCreateDialog(_selectedResource!),
                              onEdit: _selectedResource == null
                                  ? null
                                  : (record) => _showEditDialog(
                                        _selectedResource!,
                                        record,
                                      ),
                              onDelete: _selectedResource == null
                                  ? null
                                  : (record) => _confirmDelete(
                                        _selectedResource!,
                                        record,
                                      ),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (_isSidebarCollapsed)
                                  Container(
                                    width: 40,
                                    alignment: Alignment.topCenter,
                                    child: IconButton(
                                      tooltip: 'Expand sidebar',
                                      icon: const Icon(
                                        Icons.chevron_right_rounded,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isSidebarCollapsed = false;
                                        });
                                      },
                                    ),
                                  )
                                else
                                  Sidebar(
                                    resources: _resources,
                                    isLoading: _isLoading,
                                    errorMessage: _errorMessage,
                                    selectedResource: _selectedResource,
                                    onRetry: _loadResources,
                                    onSelect: _selectResource,
                                    isCollapsed: _isSidebarCollapsed,
                                    onToggleCollapse: () {
                                      setState(() {
                                        _isSidebarCollapsed = true;
                                      });
                                    },
                                  ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: RecordsPane(
                                    resource: _selectedResource,
                                    records: _records,
                                    isLoading: _isRecordsLoading,
                                    errorMessage: _recordsError,
                                    onAdd: _selectedResource == null
                                        ? null
                                        : () => _showCreateDialog(
                                            _selectedResource!),
                                    onEdit: _selectedResource == null
                                        ? null
                                        : (record) => _showEditDialog(
                                              _selectedResource!,
                                              record,
                                            ),
                                    onDelete: _selectedResource == null
                                        ? null
                                        : (record) => _confirmDelete(
                                              _selectedResource!,
                                              record,
                                            ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 16),
                    const Footer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
