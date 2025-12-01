// File: admin.dart
import 'package:flutter/material.dart';
import 'package:sih/MainFeedPage.dart';
import 'package:sih/ReportStatusPage.dart';
import 'package:sih/models.dart';
import 'package:sih/main.dart';
import 'package:sih/shared_widgets.dart';
import 'package:sih/Profile.dart';
import 'package:sih/HeatmapPage.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  void _navigateToComplaintsPage(BuildContext context, String status) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComplaintsStatusPage(status: status),
      ),
    );
  }

  void _goToProfile(BuildContext context) {
    final User adminUser = User(
      id: 'admin_1',
      username: 'Admin',
      joinDate: DateTime(2022, 1, 1),
      isAdmin: true,
      profileImageUrl: 'https://i.pravatar.cc/300?img=12',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePage(user: adminUser, isCurrentUser: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () => _goToProfile(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 24),
            _buildStatsOverview(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'admin_heatmap_btn',
        onPressed: () {
          Navigator.pushNamed(context, '/heatmap');
        },
        backgroundColor: AppColors.deepBlue,
        icon: const Icon(Icons.map, color: Colors.white),
        label: const Text("View Heatmap", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.dashboard, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to CivicReport Admin',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGray,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Manage and resolve community complaints efficiently',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.mediumGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(BuildContext context) {
    return Row(
      children: [
        _buildStatBox(context, 'Total', '847', AppColors.primaryBlue, 'all'),
        const SizedBox(width: 12),
        _buildStatBox(context, 'Pending', '23', AppColors.brightOrange, 'open'),
        const SizedBox(width: 12),
        _buildStatBox(context, 'In Progress', '156', AppColors.deepBlue, 'in-progress'),
        const SizedBox(width: 12),
        _buildStatBox(context, 'Resolved', '668', AppColors.successGreen, 'resolved'),
      ],
    );
  }

  Widget _buildStatBox(BuildContext context, String title, String value, Color color, String status) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _navigateToComplaintsPage(context, status),
        child: Container(
          height: 120,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.mediumGray,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ComplaintsStatusPage extends StatelessWidget {
  final String status;

  const ComplaintsStatusPage({super.key, required this.status});

  List<Report> _getReportsByStatus(String status) {
    final allReports = [
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
        id: '2',
        author: User(
          id: 'user_2',
          username: 'Michael Rodriguez',
          joinDate: DateTime(2023, 11, 10),
          profileImageUrl: 'https://i.pravatar.cc/300?img=13',
        ),
        title: 'Broken Streetlight - Safety Concern',
        description: 'Streetlight has been out for over a week on Oak Avenue. Creates safety hazard for pedestrians at night.',
        dateTime: DateTime.now().subtract(const Duration(hours: 5)),
        status: 'in-progress',
        tags: ['Broken Light', 'Safety Issue'],
        upvotes: 23,
        downvotes: 0,
        latitude: 13.0674,
        longitude: 80.2376,
      ),
      Report(
        id: '3',
        author: User(
          id: 'user_3',
          username: 'Amanda Williams',
          joinDate: DateTime(2024, 2, 28),
          profileImageUrl: 'https://i.pravatar.cc/300?img=14',
        ),
        title: 'Illegal Garbage Dumping',
        description: 'Someone has been dumping construction waste behind the community center. Environmental hazard.',
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        status: 'resolved',
        tags: ['Illegal Dumping', 'Environment'],
        upvotes: 31,
        downvotes: 2,
        imageUrl: 'https://images.unsplash.com/photo-1627916538059-450f1422d057?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        latitude: 13.0456,
        longitude: 80.2190,
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
      Report(
        id: '5',
        author: User(
          id: 'user_5',
          username: 'Lisa Tran',
          joinDate: DateTime(2023, 8, 20),
          profileImageUrl: 'https://i.pravatar.cc/300?img=17',
        ),
        title: 'Graffiti on Underpass',
        description: 'Large graffiti on the highway underpass at Elm Street. Needs to be cleaned up.',
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        status: 'in-progress',
        tags: ['Graffiti', 'Vandalism'],
        upvotes: 12,
        downvotes: 0,
        latitude: 13.0789,
        longitude: 80.2543,
      ),
      Report(
        id: '6',
        author: User(
          id: 'user_6',
          username: 'Robert Green',
          joinDate: DateTime(2024, 1, 1),
          profileImageUrl: 'https://i.pravatar.cc/300?img=18',
        ),
        title: 'Unsanitary conditions in public park',
        description: 'Trash cans are overflowing and a foul smell is present in the park near the playground.',
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        status: 'open',
        tags: ['Environment', 'Public Works'],
        upvotes: 18,
        downvotes: 3,
        latitude: 13.0567,
        longitude: 80.2234,
      ),
      Report(
        id: '7',
        author: User(
          id: 'user_7',
          username: 'Emily White',
          joinDate: DateTime(2023, 7, 5),
          profileImageUrl: 'https://i.pravatar.cc/300?img=19',
        ),
        title: 'Damaged sidewalk',
        description: 'A large crack in the sidewalk poses a tripping hazard to pedestrians.',
        dateTime: DateTime.now().subtract(const Duration(days: 5)),
        status: 'resolved',
        tags: ['Infrastructure', 'Safety Issue'],
        upvotes: 42,
        downvotes: 5,
        imageUrl: 'https://images.unsplash.com/photo-1594735515284-88f572c84218?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        latitude: 13.0321,
        longitude: 80.2987,
      ),
    ];

    if (status == 'all') return allReports;
    return allReports.where((report) => report.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    final reports = _getReportsByStatus(status);
    final statusDisplayName = status.replaceAll('-', ' ');
    final mockUser = User(id: 'admin_user', username: 'Admin', joinDate: DateTime.now(), isAdmin: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          statusDisplayName.toUpperCase() + ' COMPLAINTS',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: reports.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'No $statusDisplayName complaints found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ReportCard(
                report: report,
                currentUserId: mockUser.id,
                onAuthorTap: () {},
                onReportUpdated: (updatedReport) {
                  // The parent widget (this page) must be a StatefulWidget to update.
                  // Since it's a StatelessWidget, we can't update.
                  // For a prototype, we can use a workaround to force a rebuild.
                  (context as Element).markNeedsBuild();
                },
                isAdmin: true,
              ),
            ),
          );
        },
      ),
    );
  }
}