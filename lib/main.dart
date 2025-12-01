// File: main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sih/LandingPage.dart';
import 'package:sih/MainFeedPage.dart';
import 'package:sih/admin.dart';
import 'package:sih/login_page.dart';
import 'package:sih/services/auth_service.dart';
import 'package:sih/services/storage_service.dart';
import 'package:sih/ComplaintsProvider.dart';
import 'package:sih/HeatmapPage.dart';

void main() {
  // Mock initialization of services
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

class AppColors {
  static const primaryBlue = Color(0xFF667EEA);
  static const deepBlue = Color(0xFF764BA2);
  static const successGreen = Color(0xFF10B981);
  static const brightOrange = Color(0xFFF59E0B);
  static const warningRed = Color(0xFFEF4444);
  static const lightGray = Color(0xFFF8FAFC);
  static const mediumGray = Color(0xFF64748B);
  static const darkGray = Color(0xFF1F2937);
  static const primaryGradient = LinearGradient(
    colors: [primaryBlue, deepBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFF3B5998), Color(0xFFD62C22)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}