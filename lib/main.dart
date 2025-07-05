import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_logger.dart';
import 'injection_container.dart' as di;
import 'shared/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  AppLogger.init();

  // Initialize dependency injection
  await di.init();

  AppLogger.info('🚀 App started successfully');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Timely - Clock & Prime Numbers',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
