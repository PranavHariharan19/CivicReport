// File: models.dart
import 'package:flutter/material.dart';

// ------------------ User Model ------------------
class User {
  final String id;
  final String username;
  final String? email;
  final DateTime joinDate;
  final String? profileImageUrl;
  final String? userType;
  final bool isAdmin;
  final bool isActive;
  final DateTime? lastActive;
  final int reportsSubmitted;
  final int totalUpvotes;
  final int totalComments;

  User({
    required this.id,
    required this.username,
    this.email,
    required this.joinDate,
    this.profileImageUrl,
    this.userType,
    this.isAdmin = false,
    this.isActive = true,
    this.lastActive,
    this.reportsSubmitted = 0,
    this.totalUpvotes = 0,
    this.totalComments = 0,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      id: data['id'] ?? '',
      username: data['username'] ?? 'Unknown User',
      email: data['email'],
      joinDate: data['join_date'] != null
          ? DateTime.parse(data['join_date'])
          : DateTime.now(),
      profileImageUrl: data['profile_image_url'],
      userType: data['user_type'],
      isAdmin: data['is_admin'] ?? false,
      isActive: data['is_active'] ?? true,
      lastActive: data['last_active'] != null
          ? DateTime.parse(data['last_active'])
          : null,
      reportsSubmitted: data['reports_submitted'] ?? 0,
      totalUpvotes: data['total_upvotes'] ?? 0,
      totalComments: data['total_comments'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'join_date': joinDate.toIso8601String(),
      'profile_image_url': profileImageUrl,
      'user_type': userType,
      'is_admin': isAdmin,
      'is_active': isActive,
      'last_active': lastActive?.toIso8601String(),
      'reports_submitted': reportsSubmitted,
      'total_upvotes': totalUpvotes,
      'total_comments': totalComments,
    };
  }

  User copyWith({
    String? id,
    String? username,
    String? email,
    DateTime? joinDate,
    String? profileImageUrl,
    String? userType,
    bool? isAdmin,
    bool? isActive,
    DateTime? lastActive,
    int? reportsSubmitted,
    int? totalUpvotes,
    int? totalComments,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      joinDate: joinDate ?? this.joinDate,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      userType: userType ?? this.userType,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive ?? this.isActive,
      lastActive: lastActive ?? this.lastActive,
      reportsSubmitted: reportsSubmitted ?? this.reportsSubmitted,
      totalUpvotes: totalUpvotes ?? this.totalUpvotes,
      totalComments: totalComments ?? this.totalComments,
    );
  }
}

// ------------------ Comment Model ------------------
class Comment {
  final String id;
  final User author;
  final String text;
  final DateTime dateTime;
  final DateTime? updatedAt;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.dateTime,
    this.updatedAt,
  });

  factory Comment.fromMap(Map<String, dynamic> data) {
    return Comment(
      id: data['id'] ?? '',
      author: User.fromMap(data['author'] ?? {}),
      text: data['text'] ?? '',
      dateTime: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
      updatedAt: data['updated_at'] != null
          ? DateTime.parse(data['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author_id': author.id,
      'text': text,
      'created_at': dateTime.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

// ------------------ Report Model ------------------
class Report {
  final String id;
  final User author;
  final String title;
  final String description;
  final String? imageUrl;
  final String? mediaType;
  final DateTime dateTime;
  final DateTime? lastUpdated;
  final List<Comment> comments;
  final List<String> tags;
  int upvotes;
  int downvotes;
  String? status;
  final String? priority;
  final String? assignedTo;
  String? resolutionProofUrl;
  String? resolutionNotes;
  String? adminNotes;
  final double latitude;
  final double longitude;

  Report({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    this.imageUrl,
    this.mediaType,
    required this.dateTime,
    this.lastUpdated,
    List<Comment>? comments,
    required this.tags,
    this.upvotes = 0,
    this.downvotes = 0,
    this.status = 'open',
    this.priority = 'medium',
    this.assignedTo,
    this.resolutionProofUrl,
    this.resolutionNotes,
    this.adminNotes,
    required this.latitude,
    required this.longitude,
  }) : comments = comments ?? [];

  factory Report.fromMap(Map<String, dynamic> data) {
    return Report(
      id: data['id'] ?? '',
      author: User.fromMap(data['author'] ?? {}),
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['image_url'],
      mediaType: data['media_type'],
      dateTime: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
      lastUpdated: data['last_updated'] != null
          ? DateTime.parse(data['last_updated'])
          : null,
      comments: (data['comments'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromMap(c as Map<String, dynamic>))
          .toList(),
      tags: List<String>.from(data['tags'] ?? []),
      upvotes: data['upvotes'] ?? 0,
      downvotes: data['downvotes'] ?? 0,
      status: data['status'] ?? 'open',
      priority: data['priority'] ?? 'medium',
      assignedTo: data['assigned_to'],
      resolutionProofUrl: data['resolution_proof_url'],
      resolutionNotes: data['resolution_notes'],
      adminNotes: data['admin_notes'],
      latitude: data['latitude'] ?? 0.0,
      longitude: data['longitude'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author_id': author.id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'media_type': mediaType,
      'created_at': dateTime.toIso8601String(),
      'last_updated': lastUpdated?.toIso8601String(),
      'tags': tags,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'status': status,
      'priority': priority,
      'assigned_to': assignedTo,
      'resolution_proof_url': resolutionProofUrl,
      'resolution_notes': resolutionNotes,
      'admin_notes': adminNotes,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  Report copyWith({
    String? id,
    User? author,
    String? title,
    String? description,
    String? imageUrl,
    String? mediaType,
    DateTime? dateTime,
    DateTime? lastUpdated,
    List<Comment>? comments,
    List<String>? tags,
    int? upvotes,
    int? downvotes,
    String? status,
    String? priority,
    String? assignedTo,
    String? resolutionProofUrl,
    String? resolutionNotes,
    String? adminNotes,
    double? latitude,
    double? longitude,
  }) {
    return Report(
      id: id ?? this.id,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      mediaType: mediaType ?? this.mediaType,
      dateTime: dateTime ?? this.dateTime,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      comments: comments ?? this.comments,
      tags: tags ?? this.tags,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      resolutionProofUrl: resolutionProofUrl ?? this.resolutionProofUrl,
      resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      adminNotes: adminNotes ?? this.adminNotes,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  bool get isResolved => status == 'resolved';

  Color get statusColor {
    switch (status) {
      case 'resolved':
        return Colors.green;
      case 'in-progress':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String get statusDisplayName {
    switch (status) {
      case 'in-progress':
        return 'In Progress';
      case 'resolved':
        return 'Resolved';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Open';
    }
  }

  Color get priorityColor {
    switch (priority) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.yellow;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String get priorityDisplayName {
    return priority?.toUpperCase() ?? 'MEDIUM';
  }
}