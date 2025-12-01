// File: MainFeedPage.dart
import 'package:flutter/material.dart';
import 'package:sih/models.dart';
import 'package:sih/shared_widgets.dart';
import 'package:sih/Profile.dart';
import 'package:sih/main.dart';
import 'dart:io';
import 'dart:async';

// Tag Helper
class TagData {
  final String title;
  final Color color;
  TagData(this.title, this.color);
}

class MainFeedPage extends StatefulWidget {
  const MainFeedPage({super.key});

  @override
  State<MainFeedPage> createState() => _MainFeedPageState();
}

class _MainFeedPageState extends State<MainFeedPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock user
  final User _mockUser = User(
    id: 'public_user_1',
    username: 'Alice',
    joinDate: DateTime(2023, 1, 15),
    profileImageUrl: 'https://i.pravatar.cc/300?img=1',
  );

  // Sample reports
  final List<Report> _reports = [
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
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _goToProfile(BuildContext context, User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePage(user: user, isCurrentUser: user.id == _mockUser.id),
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();
    Set<String> selectedTags = {};

    final List<TagData> predefinedTags = [
      TagData("Pothole", Colors.grey.shade600),
      TagData("Illegal Dumping", Colors.brown.shade600),
      TagData("Broken Light", Colors.amber.shade600),
      TagData("Safety Issue", Colors.red.shade600),
      TagData("Infrastructure", Colors.blue.shade600),
      TagData("Public Works", Colors.orange.shade600),
      TagData("Environment", Colors.green.shade600),
      TagData("Noise Complaint", Colors.purple.shade600),
    ];

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text("Create New Report"),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDialogTextField(controller: titleController, label: "Title", maxLines: 1),
                    const SizedBox(height: 16),
                    _buildDialogTextField(controller: bodyController, label: "Description", maxLines: 4),
                    const SizedBox(height: 16),
                    _buildTagSection(predefinedTags, selectedTags, setDialogState),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text("Cancel", style: TextStyle(color: Colors.grey.shade600)),
                ),
                _buildPostButton(ctx, titleController, bodyController, selectedTags),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDialogTextField({
    required TextEditingController controller,
    required String label,
    required int maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildTagSection(List<TagData> predefinedTags, Set<String> selectedTags, StateSetter setDialogState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Add Tags:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: predefinedTags.map((tag) {
            final isSelected = selectedTags.contains(tag.title);
            return ChoiceChip(
              label: Text(tag.title),
              selected: isSelected,
              onSelected: (selected) {
                setDialogState(() {
                  if (selected) {
                    selectedTags.add(tag.title);
                  } else {
                    selectedTags.remove(tag.title);
                  }
                });
              },
              selectedColor: tag.color.withOpacity(0.8),
              backgroundColor: tag.color.withOpacity(0.2),
              labelStyle: TextStyle(color: isSelected ? Colors.white : tag.color, fontWeight: FontWeight.w600),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPostButton(
      BuildContext ctx,
      TextEditingController titleController,
      TextEditingController bodyController,
      Set<String> selectedTags,
      ) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(25),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: () {
          if (titleController.text.isEmpty || bodyController.text.isEmpty) return;

          final newReport = Report(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            author: _mockUser,
            title: titleController.text.trim(),
            description: bodyController.text.trim(),
            dateTime: DateTime.now(),
            status: 'open',
            tags: selectedTags.toList(),
            upvotes: 0,
            downvotes: 0,
            latitude: 13.0827,
            longitude: 80.2707,
          );

          setState(() => _reports.insert(0, newReport));
          Navigator.of(ctx).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Report submitted successfully!'), backgroundColor: AppColors.successGreen),
          );
        },
        child: const Text("Post", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Community Feed", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppColors.primaryGradient)),
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.person, color: Colors.white), onPressed: () => _goToProfile(context, _mockUser)),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
            await Future.delayed(const Duration(milliseconds: 500));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Feed refreshed!')));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _reports.length,
            itemBuilder: (context, index) {
              final report = _reports[index];
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ReportCard(
                    report: report,
                    currentUserId: _mockUser.id,
                    onAuthorTap: () => _goToProfile(context, report.author),
                    onReportUpdated: (updatedReport) {
                      setState(() {
                        final reportIndex = _reports.indexWhere((r) => r.id == updatedReport.id);
                        if (reportIndex != -1) {
                          _reports[reportIndex] = updatedReport;
                        }
                      });
                    },
                    isAdmin: false,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'heatmap_btn',
            onPressed: () => Navigator.pushNamed(context, '/heatmap'),
            backgroundColor: AppColors.deepBlue,
            icon: const Icon(Icons.map, color: Colors.white),
            label: const Text("View Heatmap", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'create_report_btn',
            onPressed: () => _showCreatePostDialog(context),
            backgroundColor: AppColors.primaryBlue,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text("Create Report", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}