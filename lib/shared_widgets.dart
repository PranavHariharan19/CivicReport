// File: shared_widgets.dart
import 'package:flutter/material.dart';
import 'package:sih/models.dart';
import 'package:sih/main.dart';
import 'package:sih/ReportStatusPage.dart';
import 'package:sih/Profile.dart';
import 'dart:io';

// ------------------ Fixed Report Card Widget ------------------
class ReportCard extends StatefulWidget {
  final Report report;
  final String currentUserId;
  final VoidCallback onAuthorTap;
  final Function(Report updatedReport) onReportUpdated; // Changed type to pass back the updated report
  final bool isAdmin;
  final bool showStatusChip;

  const ReportCard({
    super.key,
    required this.report,
    required this.currentUserId,
    required this.onAuthorTap,
    required this.onReportUpdated,
    this.isAdmin = false,
    this.showStatusChip = true,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late Report _currentReport; // Manage a local copy of the report
  bool? _userVoteType;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();

    _currentReport = widget.report;
    // Mock user vote state
    _userVoteType = null;
  }

  @override
  void didUpdateWidget(covariant ReportCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.report.id != widget.report.id) {
      // Reinitialize state if the report changes
      _currentReport = widget.report;
      // You may also need to reset vote state here if it's based on the report
      _userVoteType = null;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  void _handleVote(bool isUpvote) {
    setState(() {
      if (_userVoteType != null && _userVoteType! == isUpvote) {
        if (isUpvote) _currentReport.upvotes--; else _currentReport.downvotes--;
        _userVoteType = null;
      } else {
        if (_userVoteType != null) {
          if (_userVoteType!) _currentReport.upvotes--; else _currentReport.downvotes--;
        }
        if (isUpvote) _currentReport.upvotes++; else _currentReport.downvotes++;
        _userVoteType = isUpvote;
      }
    });

    final updatedReport = _currentReport.copyWith(
      upvotes: _currentReport.upvotes,
      downvotes: _currentReport.downvotes,
    );
    widget.onReportUpdated(updatedReport);
  }

  void _addComment(String text) {
    if (text.trim().isEmpty) return;

    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      author: User(
        id: widget.currentUserId,
        username: 'Current User',
        joinDate: DateTime.now(),
      ),
      text: text,
      dateTime: DateTime.now(),
    );

    setState(() {
      _currentReport.comments.insert(0, newComment);
    });

    final updatedReport = _currentReport.copyWith(
      comments: List.from(_currentReport.comments),
    );
    widget.onReportUpdated(updatedReport);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comment added!')),
    );
  }

  void _showCommentsDialog() {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: SizedBox(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.7,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.comment, color: Colors.white),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Comments',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(ctx).pop(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: _currentReport.comments.isEmpty
                          ? const Center(
                        child: Text(
                          'No comments yet.\nBe the first to comment!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _currentReport.comments.length,
                        itemBuilder: (context, index) {
                          final comment = _currentReport.comments[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundImage: comment.author.profileImageUrl != null
                                          ? NetworkImage(comment.author.profileImageUrl!)
                                          : null,
                                      child: comment.author.profileImageUrl == null
                                          ? const Icon(Icons.person, size: 16)
                                          : null,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      comment.author.username,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    const Spacer(),
                                    Text(
                                      _getTimeAgo(comment.dateTime),
                                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(comment.text),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: AppColors.primaryBlue,
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white, size: 20),
                              onPressed: () {
                                setDialogState(() {
                                  _addComment(commentController.text);
                                  commentController.clear();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'resolved':
        statusColor = AppColors.successGreen;
        statusIcon = Icons.check_circle;
        break;
      case 'in-progress':
        statusColor = AppColors.deepBlue;
        statusIcon = Icons.work;
        break;
      case 'rejected':
        statusColor = AppColors.warningRed;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppColors.brightOrange;
        statusIcon = Icons.pending_actions;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportStatusPage(
              report: widget.report,
              isAdmin: widget.isAdmin,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: statusColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusIcon, size: 12, color: statusColor),
            const SizedBox(width: 6),
            Text(
              status.toUpperCase(),
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: statusColor),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onAuthorTap,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: _currentReport.author.profileImageUrl != null
                          ? NetworkImage(_currentReport.author.profileImageUrl!)
                          : null,
                      child: _currentReport.author.profileImageUrl == null
                          ? const Icon(Icons.person, size: 24)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: widget.onAuthorTap,
                          child: Text(
                            _currentReport.author.username,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        Text(
                          _getTimeAgo(_currentReport.dateTime),
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  if (widget.showStatusChip)
                    _buildStatusChip(_currentReport.status ?? 'open'),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentReport.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkGray),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentReport.description,
                    style: const TextStyle(fontSize: 14, color: AppColors.mediumGray, height: 1.4),
                  ),
                ],
              ),
            ),

            // Media
            if (_currentReport.imageUrl != null) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _currentReport.imageUrl!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(height: 200, color: Colors.grey.shade200, child: const Center(child: Icon(Icons.error, color: Colors.grey))),
                  ),
                ),
              ),
            ],

            // Tags
            if (_currentReport.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: _currentReport.tags.map((tag) {
                    final color = _getChipColor(tag);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text(tag, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
                    );
                  }).toList(),
                ),
              ),
            ],

            // Actions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _buildActionButton(
                    icon: _userVoteType == true ? Icons.thumb_up : Icons.thumb_up_outlined,
                    label: '${_currentReport.upvotes}',
                    onTap: () => _handleVote(true),
                    isActive: _userVoteType == true,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: _userVoteType == false ? Icons.thumb_down : Icons.thumb_down_outlined,
                    label: '${_currentReport.downvotes}',
                    onTap: () => _handleVote(false),
                    isActive: _userVoteType == false,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 16),
                  _buildActionButton(
                    icon: Icons.comment_outlined,
                    label: '${_currentReport.comments.length}',
                    onTap: _showCommentsDialog,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? color : Colors.grey.shade300, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isActive ? color : Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: isActive ? color : Colors.grey.shade600, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Color _getChipColor(String tag) {
    switch (tag) {
      case 'Pothole':
        return Colors.brown;
      case 'Illegal Dumping':
        return Colors.red;
      case 'Broken Light':
        return Colors.orange;
      case 'Safety Issue':
        return Colors.purple;
      case 'Infrastructure':
        return Colors.blue;
      case 'Public Works':
        return Colors.green;
      case 'Environment':
        return Colors.teal;
      case 'Noise Complaint':
        return Colors.indigo;
      default:
        return AppColors.primaryBlue;
    }
  }
}