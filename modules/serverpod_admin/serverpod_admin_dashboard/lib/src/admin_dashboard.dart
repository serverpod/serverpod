import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_admin_client/serverpod_admin_client.dart'
    as admin_client;
import 'package:serverpod_admin_dashboard/src/controller/admin_dashboard.dart';
import 'package:serverpod_client/serverpod_client.dart';

typedef AdminResource = admin_client.AdminResource;
typedef AdminColumn = admin_client.AdminColumn;

/// Reusable admin dashboard for the `serverpod_admin` module.
///
/// Provide any generated Serverpod client that includes the `serverpod_admin`
/// module (i.e. `config/generator.yaml` lists it and code has been regenerated).
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({
    super.key,
    required this.client,
    this.title = 'Serverpod Admin Dashboard',
    this.initialThemeMode = ThemeMode.system,
    this.lightTheme,
    this.darkTheme,
  });

  final ServerpodClientShared client;
  final String title;
  final ThemeMode initialThemeMode;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late final admin_client.EndpointAdmin _adminEndpoint =
      _resolveAdminEndpoint(widget.client);
  late final AdminDashboardController _controller = AdminDashboardController(
    adminEndpoint: _adminEndpoint,
    initialThemeMode: widget.initialThemeMode,
  );

  admin_client.EndpointAdmin _resolveAdminEndpoint(
    ServerpodClientShared client,
  ) {
    final module = client.moduleLookup['serverpod_admin'];
    if (module is admin_client.Caller) {
      return module.admin;
    }
    throw StateError(
      'Provided client has not registered the serverpod_admin module. '
      'Ensure config/generator.yaml includes it and regenerate code.',
    );
  }

  ThemeData get _lightTheme => widget.lightTheme ?? _buildLightTheme();
  ThemeData get _darkTheme => widget.darkTheme ?? _buildDarkTheme();

  ThemeData _buildLightTheme() {
    const primaryColor = Color(0xFF6A5AE0);
    const surfaceTint = Color(0xFFF5F7FB);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ).copyWith(surface: surfaceTint, surfaceContainerHighest: Colors.white),
      scaffoldBackgroundColor: surfaceTint,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      textTheme: Typography.blackMountainView.apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    const primaryColor = Color(0xFFACA6FF);
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ).copyWith(surface: const Color(0xFF141622)),
      scaffoldBackgroundColor: const Color(0xFF0E101D),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Color(0xFF0E101D),
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF181B2C),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      textTheme: Typography.whiteMountainView,
    );
  }

  @override
  void initState() {
    super.initState();
    // Kick off initial load.
    _controller.loadResources();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          title: widget.title,
          themeMode: _controller.themeMode,
          theme: _lightTheme,
          darkTheme: _darkTheme,
          home: AdminHomePage(
            controller: _controller,
          ),
        );
      },
    );
  }
}

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({
    super.key,
    required this.controller,
  });

  final AdminDashboardController controller;

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
      builder: (context) => _RecordDialog(
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
      builder: (context) => _RecordDialog(
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
                child: _Sidebar(
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
                          ? _RecordsPane(
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
                                  _Sidebar(
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
                                  child: _RecordsPane(
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
                    const _DashboardFooter(),
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

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.resources,
    required this.isLoading,
    required this.errorMessage,
    required this.selectedResource,
    required this.onSelect,
    required this.onRetry,
    required this.isCollapsed,
    required this.onToggleCollapse,
  });

  final List<AdminResource> resources;
  final bool isLoading;
  final String? errorMessage;
  final AdminResource? selectedResource;
  final void Function(AdminResource resource) onSelect;
  final VoidCallback onRetry;
  final bool isCollapsed;
  final VoidCallback onToggleCollapse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 280,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip:
                        isCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
                    icon: Icon(
                      isCollapsed
                          ? Icons.chevron_right_rounded
                          : Icons.chevron_left_rounded,
                    ),
                    onPressed: onToggleCollapse,
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.dashboard_customize_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Resources',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${resources.length} available',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Reload resources',
                    onPressed: isLoading ? null : onRetry,
                    icon: const Icon(Icons.refresh_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _buildContent(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (errorMessage != null) {
      return _SidebarError(
        message: errorMessage!,
        onRetry: onRetry,
      );
    }

    if (resources.isEmpty) {
      return const Center(
        child: Text('No resources registered.'),
      );
    }

    final theme = Theme.of(context);
    return ListView.separated(
      itemCount: resources.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final resource = resources[index];
        final isSelected = selectedResource?.key == resource.key;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.12)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.dividerColor.withOpacity(0.2),
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: CircleAvatar(
              radius: 18,
              backgroundColor:
                  theme.colorScheme.primary.withOpacity(isSelected ? 0.2 : 0.1),
              child: Icon(
                Icons.data_object_outlined,
                color: theme.colorScheme.primary,
              ),
            ),
            title: Text(
              resource.tableName,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              resource.key,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
            trailing: Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.chevron_right_rounded,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.iconTheme.color?.withOpacity(0.4),
            ),
            onTap: () => onSelect(resource),
          ),
        );
      },
    );
  }
}

class _SidebarError extends StatelessWidget {
  const _SidebarError({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: onRetry,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}

class _RecordsPane extends StatelessWidget {
  const _RecordsPane({
    required this.resource,
    required this.records,
    required this.isLoading,
    required this.errorMessage,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  final AdminResource? resource;
  final List<Map<String, String>> records;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onAdd;
  final void Function(Map<String, String> record)? onEdit;
  final void Function(Map<String, String> record)? onDelete;

  @override
  Widget build(BuildContext context) {
    if (resource == null) {
      return Center(
        child: Text(
          'Select a resource to view its records.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              color: theme.colorScheme.primary.withOpacity(0.06),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource!.tableName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            '${records.length} records',
                            style: theme.textTheme.labelLarge,
                          ),
                          avatar: const Icon(Icons.table_rows, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Key: ${resource!.key}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.textTheme.labelMedium?.color
                                ?.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add),
                  label: Text('Add ${resource!.tableName}'),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: _RecordsBody(
                resource: resource!,
                records: records,
                isLoading: isLoading,
                errorMessage: errorMessage,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardFooter extends StatelessWidget {
  const _DashboardFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surface.withOpacity(0.8),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: theme.colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Brought to you by the Serverpod team with love',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecordsBody extends StatefulWidget {
  const _RecordsBody({
    required this.resource,
    required this.records,
    required this.isLoading,
    required this.errorMessage,
    required this.onEdit,
    required this.onDelete,
  });

  final AdminResource resource;
  final List<Map<String, String>> records;
  final bool isLoading;
  final String? errorMessage;
  final void Function(Map<String, String> record)? onEdit;
  final void Function(Map<String, String> record)? onDelete;

  @override
  State<_RecordsBody> createState() => _RecordsBodyState();
}

class _RecordsBodyState extends State<_RecordsBody> {
  final ScrollController _verticalController = ScrollController();
  final ScrollController _horizontalController = ScrollController();
  static const List<int> _rowsPerPageOptions = [5, 10, 25, 50];
  int _rowsPerPage = 10;
  int _currentPage = 0;

  @override
  void dispose() {
    _verticalController.dispose();
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _RecordsBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.records.length != oldWidget.records.length) {
      final clamped = _clampPageIndex(_currentPage);
      if (clamped != _currentPage) {
        setState(() {
          _currentPage = clamped;
        });
      }
    }
  }

  int _clampPageIndex(int page) {
    final maxPage = math.max(0, _totalPages - 1);
    return page.clamp(0, maxPage);
  }

  int get _totalPages =>
      math.max(1, (widget.records.length / _rowsPerPage).ceil());

  List<Map<String, String>> _pageRecords() {
    final start = _currentPage * _rowsPerPage;
    if (start >= widget.records.length) return const [];
    final endExclusive = math.min(
      start + _rowsPerPage,
      widget.records.length,
    );
    return widget.records.sublist(start, endExclusive);
  }

  void _goToPreviousPage() {
    if (_currentPage == 0) return;
    setState(() {
      _currentPage = _currentPage - 1;
    });
  }

  void _goToNextPage() {
    if (_currentPage >= _totalPages - 1) return;
    setState(() {
      _currentPage = _currentPage + 1;
    });
  }

  void _updateRowsPerPage(int? value) {
    if (value == null || value == _rowsPerPage) return;
    setState(() {
      _rowsPerPage = value;
      _currentPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.errorMessage != null) {
      return Center(
        child: Text(
          widget.errorMessage!,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    if (widget.records.isEmpty) {
      return Center(
        child: Text(
          'No records found for ${widget.resource.tableName}.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      );
    }

    final columns = widget.resource.columns;
    final pagedRecords = _pageRecords();
    final theme = Theme.of(context);
    final startRecord =
        widget.records.isEmpty ? 0 : _currentPage * _rowsPerPage + 1;
    final endRecord = widget.records.isEmpty
        ? 0
        : math.min(
            _currentPage * _rowsPerPage + pagedRecords.length,
            widget.records.length,
          );
    return Column(
      children: [
        Expanded(
          child: Scrollbar(
            controller: _verticalController,
            thumbVisibility: true,
            radius: const Radius.circular(12),
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              primary: false,
              child: SingleChildScrollView(
                controller: _verticalController,
                primary: false,
                child: DataTableTheme(
                  data: DataTableThemeData(
                    headingTextStyle: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    headingRowColor: WidgetStateProperty.resolveWith(
                      (states) => theme.colorScheme.secondary.withOpacity(0.08),
                    ),
                    dataTextStyle: theme.textTheme.bodyMedium,
                    dividerThickness: 0.6,
                  ),
                  child: DataTable(
                    columnSpacing: 36,
                    horizontalMargin: 20,
                    columns: columns
                        .map(
                          (column) => DataColumn(
                            label: Row(
                              children: [
                                const Icon(Icons.view_column_outlined,
                                    size: 16),
                                const SizedBox(width: 8),
                                Text(column.name),
                              ],
                            ),
                          ),
                        )
                        .toList()
                      ..add(
                        const DataColumn(
                          label: Text('Actions'),
                        ),
                      ),
                    rows: pagedRecords
                        .map(
                          (record) => DataRow(
                            cells: columns
                                .map(
                                  (column) => DataCell(
                                    ConstrainedBox(
                                      constraints:
                                          const BoxConstraints(minWidth: 160),
                                      child: Text(
                                        _formatRecordValue(
                                          column,
                                          record[column.name],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList()
                              ..add(
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Edit record',
                                        icon: const Icon(Icons.edit_outlined),
                                        onPressed: widget.onEdit == null
                                            ? null
                                            : () => widget.onEdit!(record),
                                      ),
                                      IconButton(
                                        tooltip: 'Delete record',
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: theme.colorScheme.error,
                                        ),
                                        onPressed: widget.onDelete == null
                                            ? null
                                            : () => widget.onDelete!(record),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _PaginationControls(
          currentPage: _currentPage,
          totalPages: _totalPages,
          startRecord: startRecord,
          endRecord: endRecord,
          totalRecords: widget.records.length,
          rowsPerPage: _rowsPerPage,
          rowsPerPageOptions: _rowsPerPageOptions,
          onRowsPerPageChanged: _updateRowsPerPage,
          onPrevious: _goToPreviousPage,
          onNext: _goToNextPage,
        ),
      ],
    );
  }
}

class _PaginationControls extends StatelessWidget {
  const _PaginationControls({
    required this.currentPage,
    required this.totalPages,
    required this.startRecord,
    required this.endRecord,
    required this.totalRecords,
    required this.rowsPerPage,
    required this.rowsPerPageOptions,
    required this.onRowsPerPageChanged,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final int startRecord;
  final int endRecord;
  final int totalRecords;
  final int rowsPerPage;
  final List<int> rowsPerPageOptions;
  final ValueChanged<int?> onRowsPerPageChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface.withOpacity(0.6),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.4),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Rows per page',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          DropdownButton<int>(
            value: rowsPerPage,
            items: rowsPerPageOptions
                .map(
                  (value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  ),
                )
                .toList(),
            onChanged: onRowsPerPageChanged,
          ),
          const Spacer(),
          Text(
            'Showing $startRecord-$endRecord of $totalRecords',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Previous page',
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: currentPage == 0 ? null : onPrevious,
          ),
          Text(
            'Page ${currentPage + 1} of $totalPages',
            style: theme.textTheme.bodyMedium,
          ),
          IconButton(
            tooltip: 'Next page',
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: currentPage >= totalPages - 1 ? null : onNext,
          ),
        ],
      ),
    );
  }
}

class _RecordDialog extends StatefulWidget {
  const _RecordDialog({
    required this.resource,
    required this.onSubmit,
    this.initialValues = const {},
    this.isUpdate = false,
  });

  final AdminResource resource;
  final Future<bool> Function(Map<String, String> payload) onSubmit;
  final Map<String, String> initialValues;
  final bool isUpdate;

  @override
  State<_RecordDialog> createState() => _RecordDialogState();
}

class _RecordDialogState extends State<_RecordDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _readOnlyFields = {};
  bool _isSubmitting = false;
  String? _submitError;
  final ScrollController _formScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    for (final column in widget.resource.columns) {
      final includeColumn = widget.isUpdate
          ? true
          : column.isPrimary
              ? false
              : true;
      if (!includeColumn) continue;
      final initialValue = widget.initialValues[column.name] ?? '';
      _controllers[column.name] = TextEditingController(text: initialValue);
      _readOnlyFields[column.name] =
          widget.isUpdate && column.isPrimary ? true : false;
    }
  }

  @override
  void dispose() {
    _formScrollController.dispose();
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fields = widget.resource.columns
        .where((column) => _controllers.containsKey(column.name))
        .map(
          (column) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _DialogField(
              column: column,
              controller: _controllers[column.name]!,
              readOnly: _readOnlyFields[column.name] ?? false,
            ),
          ),
        )
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final maxWidth = isWide ? 720.0 : 520.0;
        final maxHeight =
            MediaQuery.of(context).size.height * (isWide ? 0.85 : 0.9);

        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: isWide ? 64 : 24,
            vertical: isWide ? 48 : 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxWidth,
              maxHeight: maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.add_box_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.isUpdate
                                  ? 'Update ${widget.resource.tableName}'
                                  : 'Add ${widget.resource.tableName}',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.isUpdate
                                  ? 'Modify the fields and save your changes.'
                                  : 'Complete the form to create a new record.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Close dialog',
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(false),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Material(
                      color: theme.colorScheme.surface.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(18),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Scrollbar(
                          controller: _formScrollController,
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            controller: _formScrollController,
                            primary: false,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  ...fields,
                                  if (_submitError != null) ...[
                                    const SizedBox(height: 14),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _submitError!,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          color: theme.colorScheme.error,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 12),
                      FilledButton.icon(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        icon: _isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save_alt),
                        label: Text(
                          _isSubmitting
                              ? (widget.isUpdate ? 'Updating...' : 'Saving...')
                              : (widget.isUpdate ? 'Update' : 'Create'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleSubmit() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final payload = <String, String>{};
    for (final entry in _controllers.entries) {
      payload[entry.key] = entry.value.text.trim();
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    final success = await widget.onSubmit(payload);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _isSubmitting = false;
        _submitError =
            'Failed to ${widget.isUpdate ? 'update' : 'create'} record. Please try again.';
      });
    }
  }
}

class _DialogField extends StatelessWidget {
  const _DialogField({
    required this.column,
    required this.controller,
    required this.readOnly,
  });

  final AdminColumn column;
  final TextEditingController controller;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dataType = column.dataType;
    final normalizedType = dataType.toLowerCase().replaceAll('?', '');
    final typeToken = normalizedType.split('.').last;
    final isDateType = typeToken.contains('date') || typeToken.contains('time');
    final requiresValue = !column.hasDefault;

    TextInputType? keyboardType;
    List<TextInputFormatter>? inputFormatters;
    VoidCallback? onTap;
    Widget? suffixIcon;

    switch (typeToken) {
      case 'int':
      case 'integer':
      case 'bigint':
      case 'smallint':
        keyboardType = TextInputType.number;
        inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        break;
      case 'double':
      case 'decimal':
      case 'float':
      case 'numeric':
        keyboardType =
            const TextInputType.numberWithOptions(signed: true, decimal: true);
        break;
      case 'bool':
      case 'boolean':
        keyboardType = TextInputType.text;
        break;
      default:
        keyboardType = TextInputType.text;
    }

    if (isDateType) {
      onTap = () async {
        final picked = await _pickDateTime(context, controller.text);
        if (picked != null) {
          controller.text = picked;
        }
      };
      suffixIcon = const Icon(Icons.calendar_today_outlined);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          column.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: readOnly || isDateType,
          onTap: readOnly ? null : onTap,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            labelText: '${readOnly ? 'Locked' : 'Enter'} ${column.name}',
            helperText: 'Type: ${column.dataType}',
            suffixIcon: suffixIcon,
          ),
          validator: readOnly
              ? null
              : (raw) =>
                  _validateValue(raw, requiresValue, typeToken, isDateType),
        ),
      ],
    );
  }
}

String _formatRecordValue(AdminColumn column, String? value) {
  if (value == null || value.isEmpty) return '';
  final dataType = column.dataType.toLowerCase();
  if (dataType.contains('date') || dataType.contains('time')) {
    final parsed = DateTime.tryParse(value);
    if (parsed != null) {
      return parsed.toLocal().toString();
    }
  }
  return value;
}

Future<String?> _pickDateTime(
  BuildContext context,
  String currentValue,
) async {
  final now = DateTime.now();
  final initial = DateTime.tryParse(currentValue)?.toLocal() ?? now;

  final pickedDate = await showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(1970),
    lastDate: DateTime(2100),
  );
  if (pickedDate == null) return null;

  final pickedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initial),
  );

  final dateTime = DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
    pickedTime?.hour ?? initial.hour,
    pickedTime?.minute ?? initial.minute,
  );
  return dateTime.toIso8601String();
}

String? _validateValue(
  String? raw,
  bool requiresValue,
  String typeToken,
  bool isDateType,
) {
  final value = raw?.trim() ?? '';
  if (requiresValue && value.isEmpty) {
    return 'Required';
  }
  if (value.isEmpty) return null;

  switch (typeToken) {
    case 'int':
    case 'integer':
    case 'bigint':
    case 'smallint':
      return int.tryParse(value) == null ? 'Enter a valid integer.' : null;
    case 'double':
    case 'decimal':
    case 'float':
    case 'numeric':
      return double.tryParse(value) == null ? 'Enter a valid number.' : null;
    case 'bool':
    case 'boolean':
      final lowered = value.toLowerCase();
      return ['true', 'false', '1', '0', 'yes', 'no'].contains(lowered)
          ? null
          : 'Enter true/false.';
    default:
      if (isDateType && DateTime.tryParse(value) == null) {
        return 'Pick a valid date & time.';
      }
      return null;
  }
}
