// File: ReportStatusPage.dart
import 'package:flutter/material.dart';
import 'package:sih/models.dart';
import 'package:sih/main.dart';
import 'package:sih/shared_widgets.dart';

class ReportStatusPage extends StatefulWidget {
  final Report report;
  final bool isAdmin;

  const ReportStatusPage({
    super.key,
    required this.report,
    required this.isAdmin,
  });

  @override
  State<ReportStatusPage> createState() => _ReportStatusPageState();
}

class _ReportStatusPageState extends State<ReportStatusPage> {
  late Report _currentReport;
  String? _resolutionNotes;
  String? _resolutionProofUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentReport = widget.report;
  }

  void _updateReportStatus(String newStatus) {
    setState(() {
      _currentReport = _currentReport.copyWith(
        status: newStatus,
        lastUpdated: DateTime.now(),
      );
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Report status updated to $newStatus'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  void _showResolutionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.check_circle, color: AppColors.successGreen, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text("Resolve Report"),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (value) => _resolutionNotes = value,
                      decoration: const InputDecoration(
                        labelText: "Resolution Notes",
                        hintText: "Describe how this issue was resolved...",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Add proof of resolution:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            _resolutionProofUrl = 'https://images.unsplash.com/photo-1579732789218-18e31006941a?q=80&w=1974&auto=format&fit=crop';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mock photo selected!')),
                          );
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Take Proof Photo"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    if (_resolutionProofUrl != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.image, color: Colors.green.shade600),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Proof photo selected",
                                style: TextStyle(color: Colors.green.shade700),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                setDialogState(() {
                                  _resolutionProofUrl = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("Cancel", style: TextStyle(color: Colors.grey.shade600)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _updateReportStatus('resolved');
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.successGreen,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Mark as Resolved"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Report Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display status and timestamp
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                children: [
                  Row(
                    children: [
                      Text(
                        'Status: ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      Text(
                        _currentReport.status!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _currentReport.statusColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_currentReport.lastUpdated != null)
                    Text(
                      'Last Admin Action: ${_getTimeAgo(_currentReport.lastUpdated!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ReportCard(
              report: _currentReport,
              currentUserId: 'admin_user_id',
              onAuthorTap: () {},
              onReportUpdated: (updatedReport) {
                // Update the state of this page when the ReportCard's internal state changes
                setState(() {
                  _currentReport = updatedReport;
                });
              },
              isAdmin: widget.isAdmin,
              showStatusChip: false,
            ),
            const SizedBox(height: 20),
            if (widget.isAdmin) _buildAdminControls(),
            if (_currentReport.status == 'resolved' && _resolutionNotes != null)
              _buildResolutionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
        children: [
          Row(
            children: [
              Icon(Icons.admin_panel_settings, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              const Text(
                "Admin Controls",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_currentReport.status == 'open') ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _updateReportStatus('in-progress'),
                icon: const Icon(Icons.sync),
                label: const Text("Set to In-Progress"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (_currentReport.status != 'resolved')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _showResolutionDialog,
                icon: const Icon(Icons.check_circle),
                label: const Text("Mark as Resolved"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.successGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          if (_currentReport.status != 'rejected' && _currentReport.status != 'resolved') ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : () => _updateReportStatus('rejected'),
                icon: const Icon(Icons.cancel),
                label: const Text("Mark as Rejected"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warningRed,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResolutionSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: const Border(
          left: BorderSide(color: AppColors.successGreen, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.check_circle, color: AppColors.successGreen, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                "Resolution Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _resolutionNotes?.isNotEmpty == true
                  ? _resolutionNotes!
                  : 'No resolution notes provided.',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.mediumGray,
                height: 1.5,
              ),
            ),
          ),
          if (_resolutionProofUrl != null) ...[
            const SizedBox(height: 16),
            const Text(
              "Proof of Resolution:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _resolutionProofUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.grey, size: 48),
                        SizedBox(height: 8),
                        Text('Failed to load proof image'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}