import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routing/app_router.dart';
import 'services/memory_photo_service.dart';
import 'services/profile_service.dart';
import 'theme/app_theme.dart';

class ElderlyCompanionApp extends StatefulWidget {
  const ElderlyCompanionApp({super.key});

  @override
  State<ElderlyCompanionApp> createState() => _ElderlyCompanionAppState();
}

class _ElderlyCompanionAppState extends State<ElderlyCompanionApp> {
  late final ProfileService _profileService;
  late final MemoryPhotoService _photoService;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _profileService = ProfileService();
    _photoService = MemoryPhotoService();
    _appRouter = AppRouter();
  }

  @override
  void dispose() {
    _profileService.dispose();
    _photoService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileService>.value(value: _profileService),
        ChangeNotifierProvider<MemoryPhotoService>.value(value: _photoService),
      ],
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
