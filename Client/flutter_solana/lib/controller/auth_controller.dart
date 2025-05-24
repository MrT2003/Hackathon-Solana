import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var rememberMe = false.obs;

  /// Check if user is currently signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Get current user
  User? get currentUser => _auth.currentUser;

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  final String _abstractApiKey = "4a710a82920b4fceba3c64edb0b44c34";

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Validate email using Abstract API
  Future<Map<String, dynamic>> _validateEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://emailvalidation.abstractapi.com/v1/?api_key=4a710a82920b4fceba3c64edb0b44c34&email=$email',
        ),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['deliverability'] != "DELIVERABLE" ||
            result['is_valid_format']['value'] == false ||
            result['is_disposable_email']['value'] == true ||
            result['is_role_email']['value'] == true) {
          return {
            'valid': false,
            'reason':
                'Undeliverable / Disposable / Invalid format / Is role email',
          };
        }
        return {'valid': true};
      } else {
        return {'valid': false, 'reason': 'Email validation service error'};
      }
    } catch (e) {
      print("Email validation error: $e");
      return {
        'valid': false,
        'reason': 'Network error during email validation',
      };
    }
  }

  /// Sign up new user
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showError('All fields are required!');
      return;
    }

    if (password.length < 6) {
      _showError('Password must be at least 6 characters long');
      return;
    }

    try {
      isLoading.value = true;

      final isAdmin = email.toLowerCase().contains("admin");

      // Validate email in background
      final validateEmailFuture = _validateEmail(email);

      // Create user in Firebase
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception("User creation failed");

      // Update name & send email verification in parallel
      await Future.wait([
        user.updateDisplayName(name),
        user.sendEmailVerification(),
      ]);

      final idToken = await user.getIdToken();

      // Sync with backend (non-blocking)
      Future.microtask(() {
        _syncWithBackend(idToken!, user, name, isAdmin);
      });

      // Wait for email validation result
      // final validEmail = await validateEmailFuture;
      // if (validEmail['valid'] == false) {
      //   _showError('Invalid email: $email\nReason: ${validEmail['reason']}');
      //   return;
      // }

      // Show success
      Get.snackbar(
        'Success',
        'Account created! Please verify your email.',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );

      // Redirect
      Future.delayed(Duration(seconds: 1), () {
        Get.offAllNamed('sign-in');
      });
    } on FirebaseAuthException catch (e) {
      _handleFirebaseError(e);
    } catch (e) {
      print("Sign up error: $e");
      _showError('Sign up failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Sync Firebase user with custom backend
  Future<void> _syncWithBackend(
      String idToken, User user, String name, bool isAdmin) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.2.60:8000/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: json.encode({
          'email': user.email,
          'uid': user.uid,
          'name': name,
          'createdAt': user.metadata.creationTime?.toIso8601String(),
          'isAdmin': isAdmin,
        }),
      );

      final data = json.decode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Backend sync failed: ${data['message']}');
      }

      print("Backend sync successful");
    } catch (e) {
      print("Backend sync error: $e");
      Get.snackbar(
        'Warning',
        'Account created but sync failed. Contact support.',
        backgroundColor: Get.theme.colorScheme.tertiary,
        colorText: Get.theme.colorScheme.onTertiary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
      );
    }
  }

  /// Show error snackbar
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Handle Firebase specific errors
  void _handleFirebaseError(FirebaseAuthException e) {
    String msg;
    switch (e.code) {
      case 'weak-password':
        msg = 'The password provided is too weak.';
        break;
      case 'email-already-in-use':
        msg = 'An account already exists for that email.';
        break;
      case 'invalid-email':
        msg = 'The email address is not valid.';
        break;
      case 'operation-not-allowed':
        msg = 'Email/password accounts are not enabled.';
        break;
      default:
        msg = 'Sign up failed: ${e.message}';
    }

    _showError(msg);
  }

  ////// Sign in existing user
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _showError('Email and password are required!');
      return;
    }

    try {
      isLoading.value = true;

      // Sign in with Firebase
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception("Sign in failed");

      print("User logged in: ${user.email}");

      // Check if email is verified (uncomment if needed)
      // if (!user.emailVerified) {
      //   _showError('Please verify your email before signing in.');
      //   await _auth.signOut();
      //   return;
      // }

      // Get user data from Firestore to check admin role
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout when fetching user data');
        },
      );

      // Variables for user info
      bool isAdmin = false;
      String userName = user.displayName ?? 'User';

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          // Safely get admin status and name from Firestore
          isAdmin = userData['isAdmin'] as bool? ?? false;
          userName = userData['name'] as String? ?? userName;
        }
      } else {
        // If user document doesn't exist in Firestore, create it with default values
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': userName,
          'isAdmin': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("Created new user document for: ${user.email}");
      }

      // Show success message
      Get.snackbar(
        'Success',
        'Welcome back, $userName!',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Navigate based on admin role
      await Future.delayed(const Duration(milliseconds: 500));

      if (isAdmin) {
        print("Navigating to admin home...");
        Get.offAllNamed('/admin-home');
      } else {
        print("Navigating to user home...");
        Get.offAllNamed('/bottom-nav-bar'); // hoặc '/user-home'
      }
    } on FirebaseAuthException catch (e) {
      _handleSignInFirebaseError(e);
    } on Exception catch (e) {
      print("Sign in exception: $e");
      _showError('Sign in failed. Please try again.');
    } catch (e) {
      print("Sign in error: $e");
      _showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Handle Firebase sign in specific errors
  void _handleSignInFirebaseError(FirebaseAuthException e) {
    String msg;
    switch (e.code) {
      case 'user-not-found':
        msg = 'No user found for that email address.';
        break;
      case 'wrong-password':
        msg = 'Wrong password provided.';
        break;
      case 'invalid-email':
        msg = 'The email address is not valid.';
        break;
      case 'user-disabled':
        msg = 'This user account has been disabled.';
        break;
      case 'too-many-requests':
        msg = 'Too many failed attempts. Please try again later.';
        break;
      case 'invalid-credential':
        msg = 'Invalid email or password.';
        break;
      default:
        msg = 'Sign in failed: ${e.message}';
    }

    _showError(msg);
  }

// Helper method để tạo _showError nếu chưa có
  /// Sign out user
  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _auth.signOut();

      Get.snackbar(
        'Success',
        'Signed out successfully!',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 1),
      );

      Get.offAllNamed('/sign-in');
    } catch (e) {
      print("Sign out error: $e");
      _showError('Sign out failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      _showError('Please enter your email address.');
      return;
    }

    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);

      Get.snackbar(
        'Success',
        'Password reset email sent! Check your inbox.',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'No user found for that email address.';
          break;
        case 'invalid-email':
          msg = 'The email address is not valid.';
          break;
        default:
          msg = 'Failed to send reset email: ${e.message}';
      }
      _showError(msg);
    } catch (e) {
      print("Password reset error: $e");
      _showError('Failed to send reset email. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }
}
