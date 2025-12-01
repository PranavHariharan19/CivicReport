// File: Profile.dart
import 'package:flutter/material.dart';
import 'package:sih/models.dart';
import 'package:sih/main.dart';
import 'package:sih/shared_widgets.dart';
import 'package:sih/UserReportsPage.dart';
import 'package:sih/MainFeedPage.dart';
import 'dart:async';

// ------------------ Profile Page ------------------
class ProfilePage extends StatefulWidget {
  final User user;
  final bool isCurrentUser;

  const ProfilePage({
    super.key,
    required this.user,
    this.isCurrentUser = false,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late AnimationController _fadeAnimationController;
  late Animation<double> _fadeAnimation;

  // Mock list of reports, which will be updated on interaction
  List<Report> _userReports = [];

  @override
  void initState() {
    super.initState();
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeAnimationController, curve: Curves.easeIn),
    );
    _fadeAnimationController.forward();

    // Initialize reports for mock user
    if (!widget.user.isAdmin) {
      _userReports = [
        Report(
          id: '1',
          author: widget.user,
          title: 'Dangerous Pothole on Main Street',
          description:
          'Large pothole causing vehicle damage near the intersection of Main St and 5th Ave. Multiple cars have been affected.',
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
          author: widget.user,
          title: 'Noise Complaint - Construction',
          description:
          'Construction work starting at 5 AM violates city noise ordinance. Affecting entire neighborhood.',
          dateTime: DateTime.now().subtract(const Duration(days: 2)),
          status: 'open',
          tags: ['Noise Complaint', 'Public Works'],
          upvotes: 8,
          downvotes: 0,
          latitude: 13.0900,
          longitude: 80.2000,
        ),
      ];
    }
  }

  @override
  void dispose() {
    _fadeAnimationController.dispose();
    super.dispose();
  }

  void _showProfilePhoto(BuildContext context, String? imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (_) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.black.withOpacity(0.8),
            alignment: Alignment.center,
            child: Hero(
              tag: "profilePhoto_${widget.user.username}",
              child: InteractiveViewer(
                panEnabled: true,
                minScale: 0.5,
                maxScale: 4,
                child: (imageUrl != null && imageUrl.isNotEmpty)
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.person,
                              size: 120, color: Colors.white),
                        ),
                  ),
                )
                    : Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.person,
                      size: 120, color: Colors.white),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onReportUpdated(Report updatedReport) {
    setState(() {
      final index = _userReports.indexWhere((r) => r.id == updatedReport.id);
      if (index != -1) {
        _userReports[index] = updatedReport;
      }
    });
  }

  void _goToUserFeed(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserReportsPage(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isCurrentUser && _selectedTabIndex == 1) _selectedTabIndex = 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          widget.isCurrentUser
              ? "My Profile"
              : "${widget.user.username}'s Profile",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.secondaryGradient,
          ),
        ),
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            children: [
              _buildHeaderSection(),
              const SizedBox(height: 20),
              if (!widget.user.isAdmin) _buildTabSelector(),
              const SizedBox(height: 16),
              if (!widget.user.isAdmin) _buildTabContent(),
              if (widget.user.isAdmin) _buildAdminOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminOptions() {
    return Container(
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
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSettingsGroup(
            title: "Admin Settings",
            icon: Icons.admin_panel_settings_outlined,
            children: [
              _buildSettingsTile(
                icon: Icons.edit,
                title: "Edit Admin Profile",
                subtitle: "Update your personal information",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Admin profile edit coming soon!"),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                icon: Icons.notifications_outlined,
                title: "Notification Preferences",
                subtitle: "Customize your alerts",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Admin notification settings coming soon!"),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettingsGroup(
            title: "System",
            icon: Icons.computer,
            children: [
              _buildSettingsTile(
                icon: Icons.bar_chart,
                title: "System Analytics",
                subtitle: "View performance metrics",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Analytics dashboard coming soon!"),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                icon: Icons.security_outlined,
                title: "Security",
                subtitle: "Manage security settings",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Security settings coming soon!"),
                      backgroundColor: Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(_selectedTabIndex),
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (_selectedTabIndex == 0) _buildMyReportsSection(),
            if (_selectedTabIndex == 1 && widget.isCurrentUser)
              _buildSettingsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSettingsGroup(
            title: "Profile Settings",
            icon: Icons.person_outline,
            children: [
              _buildSettingsTile(
                icon: Icons.edit,
                title: "Edit Profile",
                subtitle: "Update your profile information",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Edit profile feature coming soon!"),
                      backgroundColor: Colors.blue.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                icon: Icons.notifications_outlined,
                title: "Notifications",
                subtitle: "Manage your notification preferences",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Notification settings coming soon!"),
                      backgroundColor: Colors.blue.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSettingsGroup(
            title: "Account Settings",
            icon: Icons.security,
            children: [
              _buildSettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: "Privacy",
                subtitle: "Manage your privacy settings",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Privacy settings coming soon!"),
                      backgroundColor: Colors.blue.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
              _buildSettingsTile(
                icon: Icons.help_outline,
                title: "Help & Support",
                subtitle: "Get help and contact support",
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Help center coming soon!"),
                      backgroundColor: Colors.blue.shade600,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 40),

          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildMyReportsSection() {
    if (_userReports.isEmpty) {
      return _buildEmptyReports();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.assignment, color: Colors.blue.shade600),
            const SizedBox(width: 8),
            Text(
              "Reports (${_userReports.length})",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A202C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _userReports.length,
          itemBuilder: (context, index) => ReportCard(
            report: _userReports[index],
            currentUserId: widget.user.id,
            onAuthorTap: () => _goToUserFeed(widget.user),
            onReportUpdated: (updatedReport) {
              setState(() {
                final reportIndex = _userReports.indexWhere((r) => r.id == updatedReport.id);
                if (reportIndex != -1) {
                  _userReports[reportIndex] = updatedReport;
                }
              });
            },
            isAdmin: false,
            showStatusChip: false,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyReports() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: 48,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "No reports yet",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isCurrentUser
                ? "Tap the + button to create your first report"
                : "${widget.user.username} hasn't submitted any reports yet",
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    final reportsSubmitted = _userReports.length;
    final totalUpvotes = _userReports.fold(0, (sum, report) => sum + report.upvotes);
    final totalComments = _userReports.fold(0, (sum, report) => sum + report.comments.length);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _showProfilePhoto(context, widget.user.profileImageUrl),
            child: Hero(
              tag: "profilePhoto_${widget.user.username}",
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.secondaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.transparent,
                  backgroundImage: (widget.user.profileImageUrl != null &&
                      widget.user.profileImageUrl!.isNotEmpty)
                      ? NetworkImage(widget.user.profileImageUrl!)
                      : null,
                  child: (widget.user.profileImageUrl == null ||
                      widget.user.profileImageUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 55, color: Colors.white)
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            widget.user.username,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A202C),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              "Joined on ${widget.user.joinDate.day}/${widget.user.joinDate.month}/${widget.user.joinDate.year}",
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (!widget.user.isAdmin)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem("Reports", reportsSubmitted, Icons.assignment, Colors.blue),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                _buildStatItem("Upvotes", totalUpvotes, Icons.thumb_up, Colors.green),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                _buildStatItem("Comments", totalComments, Icons.comment, Colors.orange),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          "$value",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF1A202C),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildTabButton(0, "Reports", Icons.assignment)),
          if (widget.isCurrentUser)
            Expanded(child: _buildTabButton(1, "Settings", Icons.settings)),
        ],
      ),
    );
  }

  Widget _buildTabButton(int index, String text, IconData icon) {
    final isSelected = _selectedTabIndex == index;
    return Container(
      margin: const EdgeInsets.all(4),
      child: InkWell(
        onTap: () => setState(() => _selectedTabIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: isSelected
                ? AppColors.secondaryGradient
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/',
                  (Route<dynamic> route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Successfully logged out"),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.red.shade600,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Sign out of your account",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.red.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.red.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryBlue, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkGray,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}