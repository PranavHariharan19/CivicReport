// File: lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models.dart' as models;

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Add this temporary state variable
  String _pendingUserType = 'public';

  User? get currentUser => _supabase.auth.currentUser;

  bool get isAuthenticated => currentUser != null;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  // Sign in with email + password
  // Sign in with email + password
  Future<AuthResponse?> signInWithEmail(String email, String password, {String userType = 'public'}) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await _ensureUserExists(response.user!, userType: userType);
        notifyListeners();
      }
      return response;
    } catch (e) {
      print("Error during signInWithEmail: $e");
      return null;
    }
  }

  // Sign up with email + password

  // Sign up with email + password
  Future<AuthResponse?> signUpWithEmail(String email, String password, String username, {String userType = 'public'}) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'user_type': userType,
        },
        // 👇 Important: tell Supabase where to redirect after email confirmation
        emailRedirectTo: 'http://localhost:3000/', // or your production domain/deep link
      );

      if (response.user != null) {
        await _createUserProfile(response.user!, username, userType: userType);
        notifyListeners();
      } else {
        print("Sign up successful — check your email to confirm your account.");
      }

      return response;
    } catch (e) {
      print("Error during signUpWithEmail: $e");
      return null;
    }
  }

  // In lib/services/auth_service.dart

  // Sign in with Google using Supabase OAuth
  Future<bool> signInWithGoogle({String userType = 'public'}) async {
    try {
      // Set the temporary state variable before the redirect
      _pendingUserType = userType;

      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
          redirectTo: 'http://localhost:3000',
      );

      return true;
    } catch (e) {
      print('Error during Google Sign-in: $e');
      return false;
    }
  }

  // Check if user is admin
  Future<bool> isUserAdmin(String userId) async {
    try {
      final userData = await _supabase
          .from('users')
          .select('user_type, is_admin')
          .eq('auth_id', userId)
          .maybeSingle();

      if (userData != null) {
        return userData['user_type'] == 'admin' || userData['is_admin'] == true;
      }
      return false;
    } catch (e) {
      print("Error checking admin status: $e");
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      notifyListeners();
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  // Create user profile in database
  Future<void> _createUserProfile(User authUser, String username, {String userType = 'public'}) async {
    try {
      final userData = {
        'id': authUser.id,
        'auth_id': authUser.id,
        'username': username,
        'email': authUser.email,
        'user_type': userType,
        'join_date': DateTime.now().toIso8601String(),
        'profile_image_url': authUser.userMetadata?['avatar_url'],
        'reports_submitted': 0,
        'total_upvotes': 0,
        'total_comments': 0,
        'is_admin': userType == 'admin',
        'is_active': true,
        'last_active': DateTime.now().toIso8601String(),
      };

      await _supabase.from('users').upsert(userData);
    } catch (e) {
      print("Error creating user profile: $e");
    }
  }

  // Ensure user exists in database (for OAuth users)
  // In lib/services/auth_service.dart

  // Ensure user exists in database (for OAuth users)
  Future<void> _ensureUserExists(User authUser, {String userType = 'public'}) async {
    try {
      final existingUser = await _supabase
          .from('users')
          .select('id, user_type')
          .eq('auth_id', authUser.id)
          .maybeSingle();

      if (existingUser == null) {
        await _createUserProfile(
          authUser,
          authUser.email?.split('@')[0] ?? 'User',
          userType: _pendingUserType,
        );
      } else {
        final updates = <String, dynamic>{
          'last_active': DateTime.now().toIso8601String(),
        };

        // Only update user_type if it's not set or if the new type is 'admin'
        if (existingUser['user_type'] == null || _pendingUserType == 'admin') {
          updates['user_type'] = _pendingUserType;
        }

        await _supabase
            .from('users')
            .update(updates)
            .eq('auth_id', authUser.id);
      }
    } catch (e) {
      print("Error ensuring user exists: $e");
    }
  }

  // Get user data from database
  Future<models.User?> getUserData(String authId) async {
    try {
      final userData = await _supabase
          .from('users')
          .select()
          .eq('auth_id', authId)
          .single();

      return models.User.fromMap(userData);
    } catch (e) {
      print("Error getting user data: $e");
      return null;
    }
  }

  // Get current user data
  Future<models.User?> getCurrentUserData() async {
    if (currentUser == null) return null;
    return await getUserData(currentUser!.id);
  }

  // Update user profile
  Future<bool> updateUserProfile({
    String? username,
    String? profileImageUrl,
  }) async {
    try {
      if (currentUser == null) return false;

      final updates = <String, dynamic>{};
      if (username != null) updates['username'] = username;
      if (profileImageUrl != null) updates['profile_image_url'] = profileImageUrl;
      updates['last_active'] = DateTime.now().toIso8601String();

      if (updates.isNotEmpty) {
        await _supabase
            .from('users')
            .update(updates)
            .eq('auth_id', currentUser!.id);
      }

      notifyListeners();
      return true;
    } catch (e) {
      print("Error updating user profile: $e");
      return false;
    }
  }

  // Get user stats
  Future<Map<String, int>> getUserStats(String userId) async {
    try {
      // Get reports count and upvotes
      final reports = await _supabase
          .from('reports')
          .select('id')
          .eq('author_id', userId);

      int reportsCount = reports.length;

      // Get total upvotes for user's reports
      if (reports.isNotEmpty) {
        final votes = await _supabase
            .from('votes')
            .select('vote_type')
            .inFilter('report_id', reports.map((r) => r['id']).toList())
            .eq('vote_type', 'upvote');

        int totalUpvotes = votes.length;

        // Get comments count
        final comments = await _supabase
            .from('comments')
            .select('id')
            .eq('author_id', userId);

        int totalComments = comments.length;

        return {
          'reports': reportsCount,
          'upvotes': totalUpvotes,
          'comments': totalComments,
        };
      }

      return {'reports': 0, 'upvotes': 0, 'comments': 0};
    } catch (e) {
      print("Error getting user stats: $e");
      return {'reports': 0, 'upvotes': 0, 'comments': 0};
    }
  }

  // Create admin user (for setup purposes)
  Future<bool> createAdminUser(String email, String password, String username) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'username': username,
          'user_type': 'admin',
        },
      );

      if (response.user != null) {
        await _createUserProfile(response.user!, username, userType: 'admin');
        return true;
      }
      return false;
    } catch (e) {
      print("Error creating admin user: $e");
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(
        email,
        // 👇 Use your app’s redirect, not Supabase’s internal callback
        redirectTo: 'http://localhost:3000/', // or your deep link
      );
      return true;
    } catch (e) {
      print("Error resetting password: $e");
      return false;
    }
  }

  // Update password
  Future<bool> updatePassword(String newPassword) async {
    try {
      if (currentUser == null) return false;

      final response = await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      return response.user != null;
    } catch (e) {
      print("Error updating password: $e");
      return false;
    }
  }
}