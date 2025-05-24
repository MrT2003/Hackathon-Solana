import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var isLoading = false.obs;
  var isPasswordVisible = false.obs;

  final String _abstractApiKey = "4a710a82920b4fceba3c64edb0b44c34";

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<Map<String, dynamic>> _validateEmail(String email) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://emailvalidation.abstractapi.com/v1/?api_key=$_abstractApiKey&email=$email',
        ),
      );

      if (response.statusCode == 200) {
        final validateResult = json.decode(response.body);
        print("Validate result: $validateResult");

        if (validateResult['deliverability'] != "DELIVERABLE" ||
            validateResult['is_valid_format']['value'] == false ||
            validateResult['is_disposable_email']['value'] == true ||
            validateResult['is_role_email']['value'] == true) {
          return {
            'valid': false,
            'reason':
                'Undeliverable / Disposable / Invalid format / Is role email'
          };
        } else {
          return {'valid': true};
        }
      } else {
        return {'valid': false, 'reason': 'Email validation service error'};
      }
    } catch (e) {
      print("Email validation error: $e");
      return {
        'valid': false,
        'reason': 'Network error during email validation'
      };
    }
  }

  // Sign Up method
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    // Basic validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required!',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Password length validation
    if (password.length < 6) {
      Get.snackbar(
        'Weak Password',
        'Password must be at least 6 characters long',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Check if user is admin
      bool isAdmin = email.toLowerCase().contains("admin");

      print("Name: $name");
      print("Email: $email");
      print("Password: $password");

      // Validate email using Abstract API
      final validMail = await _validateEmail(email);
      print("VALID: ${validMail['valid']}");

      if (validMail['valid'] == false) {
        Get.snackbar(
          'Invalid Email',
          'Invalid email: $email\nReason: ${validMail['reason']}',
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 4),
        );
        return;
      }

      // Create user with Firebase
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await userCredential.user?.updateDisplayName(name);

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      // Get Firebase ID token
      final idToken = await userCredential.user?.getIdToken();
      print("FIREBASE_ID_TOKEN: $idToken");

      // Send token to backend
      await _syncWithBackend(idToken!, userCredential.user!, name, isAdmin);

      Get.snackbar(
        'Success',
        'Account created successfully! Please check your email for verification.',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );

      // Navigate to main screen after successful signup
      Future.delayed(Duration(seconds: 2), () {
        Get.offAllNamed('/bottomNavBar');
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'Sign up failed: ${e.message}';
      }

      Get.snackbar(
        'Sign Up Error',
        errorMessage,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
      );
    } catch (error) {
      print("Sign up error: $error");
      Get.snackbar(
        'Error',
        'Sign up failed. Please try again.',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sync user data with backend
  Future<void> _syncWithBackend(
      String idToken, User user, String name, bool isAdmin) async {
    try {
      final backendResponse = await http.post(
        Uri.parse(
            'http://localhost:8000/auth/register'), // Change to your backend URL
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

      final response = json.decode(backendResponse.body);

      if (backendResponse.statusCode != 200 &&
          backendResponse.statusCode != 201) {
        String errorMessage = response['message'] ?? 'No message from backend';
        throw Exception('Backend sync failed: $errorMessage');
      }

      print("Backend sync successful");
    } catch (e) {
      print("Backend sync error: $e");
      Get.snackbar(
        'Warning',
        'Account created but failed to sync with server. Please contact support if you experience issues.',
        backgroundColor: Get.theme.colorScheme.tertiary,
        colorText: Get.theme.colorScheme.onTertiary,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
      );
    }
  }
}
