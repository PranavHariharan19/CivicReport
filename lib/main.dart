import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih/pages/landing_page.dart';
import 'package:sih/pages/main_feed_page.dart';
import 'package:sih/pages/admin_page.dart';
import 'package:sih/pages/login_page.dart';
import 'package:sih/services/auth_service.dart';
import 'package:sih/services/storage_service.dart';
import 'package:sih/providers/complaints_provider.dart';
import 'package:sih/pages/heatmap_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ComplaintsProvider()),
        Provider(create: (_) => StorageService()),
      ],
      child: const CivicReportApp(),
    ),
  );
}

class CivicReportApp extends StatelessWidget {
  const CivicReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CivicReport',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/admin': (context) => const AdminDashboard(),
        '/feed': (context) => const MainFeedPage(),
        '/login': (context) => const LoginPage(userType: 'public'),
        '/admin-login': (context) => const LoginPage(userType: 'admin'),
        '/heatmap': (context) => const HeatmapPage(),
      },
    );
  }
}
