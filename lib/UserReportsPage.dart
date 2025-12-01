// File: UserReportsPage.dart
import 'package:flutter/material.dart';
import 'package:sih/models.dart';
import 'package:sih/main.dart';
import 'package:sih/shared_widgets.dart';
import 'dart:io';

class UserReportsPage extends StatefulWidget {
  final User user;

  const UserReportsPage({
    super.key,
    required this.user,
  });

  @override
  State<UserReportsPage> createState() => _UserReportsPageState();
}

class _UserReportsPageState extends State<UserReportsPage> {
  // Use a local list to manage reports and their state
  final List<Report> _userReports = [
    Report(
      id: '1',
      author: User(
        id: 'user_1',
        username: 'Sarah Chen',
        joinDate: DateTime(2023, 10, 26),
        profileImageUrl: 'https://i.pravatar.cc/300?img=15',
      ),
      title: 'Dangerous Pothole on Main Street',
      description: 'Large pothole causing vehicle damage near the intersection of Main St and 5th Ave. Multiple cars have been affected.',
      dateTime: DateTime.now().subtract(const Duration(hours: 2)),
      status: 'open',
      tags: ['Pothole', 'Infrastructure'],
      upvotes: 15,
      downvotes: 1,
      latitude: 13.0827,
      longitude: 80.2707,
    ),
    Report(
      id: '4',
      author: User(
        id: 'user_4',
        username: 'James Park',
        joinDate: DateTime(2024, 3, 1),
        profileImageUrl: 'https://i.pravatar.cc/300?img=16',
      ),
      title: 'Noise Complaint - Construction',
      description: 'Construction work starting at 5 AM violates city noise ordinance. Affecting entire neighborhood.',
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      status: 'open',
      tags: ['Noise Complaint', 'Public Works'],
      upvotes: 8,
      downvotes: 0,
      latitude: 13.0900,
      longitude: 80.2000,
    ),
  ];

  // This method will be called by the ReportCard to update the state
  void _onReportUpdated(Report updatedReport) {
    setState(() {
      final index = _userReports.indexWhere((r) => r.id == updatedReport.id);
      if (index != -1) {
        _userReports[index] = updatedReport;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = 'mock_user_id'; // Dummy ID

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          "${widget.user.username}'s Reports",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _userReports.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.assignment_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "No reports found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${widget.user.username} hasn't submitted any reports yet.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _userReports.length,
        itemBuilder: (context, index) {
          final report = _userReports[index];
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ReportCard(
                report: report,
                currentUserId: currentUserId,
                onAuthorTap: () => Navigator.pop(context),
                onReportUpdated: _onReportUpdated,
                isAdmin: false,
              ),
            ),
          );
        },
      ),
    );
  }
}