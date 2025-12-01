// File: lib/providers/complaints_provider.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models.dart' as models;

class ComplaintsProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<models.Report> _complaints = [];
  List<models.Report> get complaints => _complaints;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Load complaints from Supabase
  Future<void> loadComplaints() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _supabase
          .from('reports')
          .select('*, author:author_id(id, username, profile_image_url)')
          .order('created_at', ascending: false);

      _complaints = await _buildReportsFromData(response);
    } catch (e) {
      _errorMessage = 'Failed to load complaints: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update complaint status
  Future<bool> updateComplaint(String id, String status, {String? priority, String? adminNotes}) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
        'last_updated': DateTime.now().toIso8601String(),
      };

      if (priority != null) updateData['priority'] = priority;
      if (adminNotes != null) updateData['admin_notes'] = adminNotes;

      await _supabase.from('reports').update(updateData).eq('id', id);

      // Update local data
      final index = _complaints.indexWhere((c) => c.id == id);
      if (index != -1) {
        _complaints[index] = _complaints[index].copyWith(
          status: status,
          priority: priority ?? _complaints[index].priority,
          adminNotes: adminNotes ?? _complaints[index].adminNotes,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = 'Failed to update complaint: $e';
      notifyListeners();
      return false;
    }
  }

  // Get complaints by status
  List<models.Report> getComplaintsByStatus(String status) {
    if (status == 'unviewed') {
      return _complaints.where((c) => c.status == 'open').toList();
    }
    return _complaints.where((c) => c.status == status).toList();
  }

  // Get complaint counts
  Map<String, int> getComplaintCounts() {
    return {
      'total': _complaints.length,
      'open': _complaints.where((c) => c.status == 'open').length,
      'in-progress': _complaints.where((c) => c.status == 'in-progress').length,
      'resolved': _complaints.where((c) => c.status == 'resolved').length,
      'rejected': _complaints.where((c) => c.status == 'rejected').length,
    };
  }

  // Helper method to build reports from raw data
  Future<List<models.Report>> _buildReportsFromData(List<Map<String, dynamic>> data) async {
    final List<models.Report> reports = [];

    for (var reportData in data) {
      try {
        models.User author;
        if (reportData['author'] != null) {
          author = models.User(
            id: reportData['author']['id'],
            username: reportData['author']['username'],
            joinDate: DateTime.now(),
            profileImageUrl: reportData['author']['profile_image_url'],
          );
        } else {
          final authorData = await _supabase
              .from('users')
              .select()
              .eq('id', reportData['author_id'])
              .single();
          author = models.User.fromMap(authorData);
        }

        final votes = await _supabase
            .from('votes')
            .select('vote_type')
            .eq('report_id', reportData['id']);

        int upvotes = votes.where((v) => v['vote_type'] == 'upvote').length;
        int downvotes = votes.where((v) => v['vote_type'] == 'downvote').length;

        final commentsCount = await _supabase
            .from('comments')
            .select('id')
            .eq('report_id', reportData['id'])
            .count();

        final report = models.Report(
          id: reportData['id'],
          author: author,
          title: reportData['title'] ?? '',
          description: reportData['description'] ?? '',
          imageUrl: reportData['image_url'],
          mediaType: reportData['media_type'],
          dateTime: reportData['created_at'] != null
              ? DateTime.parse(reportData['created_at'])
              : DateTime.now(),
          lastUpdated: reportData['last_updated'] != null
              ? DateTime.parse(reportData['last_updated'])
              : null,
          tags: List<String>.from(reportData['tags'] ?? []),
          upvotes: upvotes,
          downvotes: downvotes,
          status: reportData['status'] ?? 'open',
          priority: reportData['priority'] ?? 'medium',
          assignedTo: reportData['assigned_to'],
          resolutionProofUrl: reportData['resolution_proof_url'],
          resolutionNotes: reportData['resolution_notes'],
          adminNotes: reportData['admin_notes'],
          comments: [],
          // Fix: Add latitude and longitude from the data source
          latitude: reportData['latitude'] ?? 0.0,
          longitude: reportData['longitude'] ?? 0.0,
        );

        reports.add(report);
      } catch (e) {
        print('Error building report from data: $e');
      }
    }

    return reports;
  }

  // Stream complaints for real-time updates
  Stream<List<models.Report>> get complaintsStream {
    return _supabase
        .from('reports')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .asyncMap((data) async => await _buildReportsFromData(data));
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}