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
