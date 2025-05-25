import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_solana/controller/user_controller.dart';
import 'package:flutter_solana/model/user_model.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var rememberMe = false.obs;

  /// Check if user is currently signed in
  bool get isSignedIn => _auth.currentUser != null;

  /// Get current user
  // User? get currentUser => _auth.currentUser;

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  final String _abstractApiKey = "4a710a82920b4fceba3c64edb0b44c34";
  // Observable để lưu thông tin user hiện tại
  Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  RxString currentUid = ''.obs;
  RxBool isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Lắng nghe thay đổi trạng thái auth
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        currentUid.value = user.uid;
        print("Current User UID: ${user.uid}");
        await _loadUserData(); // load Firestore user data
      } else {
        currentUser.value = null;
      }
    });
  }

  String? getCurrentUserUid() {
    final user = _auth.currentUser;
    if (user != null) {
      print("Method 1 - Current UID: ${user.uid}");
      return user.uid;
    }
    return null;
  }

  Future<void> _loadUserData() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        // Tránh lỗi nếu field 'walletPublicKey' không tồn tại hoặc không phải map
        final walletMap = data['walletPublicKey'];
        String publicKey = '';

        if (walletMap != null &&
            walletMap is Map &&
            walletMap['publicKey'] != null) {
          publicKey = walletMap['publicKey'];
        }

        currentUser.value = UserModel(
          uid: uid,
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          isAdmin: data['isAdmin'] ?? false,
          walletPublicKey: publicKey,
        );

        isAdmin.value = currentUser.value!.isAdmin;
      }
    }
  }

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
        Uri.parse('http://192.168.2.60:5000/auth/register'),
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

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) throw Exception("Sign in failed");

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String userName = user.displayName ?? 'User';
      bool isAdmin = false;

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          isAdmin = userData['isAdmin'] as bool? ?? false;
          userName = userData['name'] as String? ?? userName;
        }
      } else {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
          'name': userName,
          'isAdmin': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // ⬇️ Đưa vào UserController để dùng toàn app
      Get.put(UserController(uid: user.uid, name: userName));

      Get.snackbar('Success', 'Welcome back, $userName!',
          backgroundColor: Get.theme.colorScheme.primary,
          colorText: Get.theme.colorScheme.onPrimary,
          snackPosition: SnackPosition.BOTTOM);

      await Future.delayed(const Duration(milliseconds: 500));

      if (isAdmin) {
        Get.offAllNamed('/admin-home');
      } else {
        Get.offAllNamed('/bottom-nav-bar');
      }
    } on FirebaseAuthException catch (e) {
      _handleSignInFirebaseError(e);
    } catch (e) {
      _showError('An unexpected error occurred. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void _handleSignInFirebaseError(FirebaseAuthException e) {
    String msg;
    switch (e.code) {
      case 'user-not-found':
        msg = 'No user found for that email address.';
        break;
      case 'wrong-password':
        msg = 'Wrong password provided.';
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
