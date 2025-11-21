import 'package:flutter/material.dart';
import 'package:serverpod_admin_client/serverpod_admin_client.dart';
import 'package:serverpod_admin_client/serverpod_admin_client.dart'
    as admin_client;
import 'package:serverpod_admin_dashboard/src/controller/admin_dashboard.dart';
import 'package:serverpod_admin_dashboard/src/screens/home.dart';

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
          home: Home(
            controller: _controller,
          ),
        );
      },
    );
  }
}
