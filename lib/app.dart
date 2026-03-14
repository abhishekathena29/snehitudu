import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routing/app_router.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';

class ElderlyCompanionApp extends StatefulWidget {
  const ElderlyCompanionApp({super.key});

  @override
  State<ElderlyCompanionApp> createState() => _ElderlyCompanionAppState();
}

class _ElderlyCompanionAppState extends State<ElderlyCompanionApp> {
  late final AuthService _authService;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _authService = AuthService();
    _appRouter = AppRouter(_authService);
  }

  @override
  void dispose() {
    _authService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthService>.value(
      value: _authService,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Snehitudu',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
