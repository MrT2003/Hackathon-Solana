import 'package:flutter/material.dart';
import 'package:flutter_solana/controller/auth_controller.dart';
import 'package:get/get.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final AuthController authController = Get.put(AuthController());
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Logo + Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ECO-TOKEN",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00B14F),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.eco,
                        color: Color(0xFF00B14F),
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 32),
                // Email Field
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Your email",
                    prefixIcon: Icon(Icons.email_outlined),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF00B14F), width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Password Field
                Obx(() => TextField(
                      controller: passwordController,
                      obscureText: !authController.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Your password",
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            authController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: authController.togglePasswordVisibility,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFF00B14F), width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(() => Checkbox(
                              value: authController.rememberMe.value,
                              onChanged: (value) {
                                authController.rememberMe.value =
                                    value ?? false;
                              },
                              activeColor: Color(0xFF00B14F),
                            )),
                        Text(
                          "Remember me",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        _showForgotPasswordDialog(context, authController);
                      },
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(color: Color(0xFF00B14F)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Sign In Button
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authController.isLoading.value
                            ? null
                            : () async {
                                await authController.signIn(
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF00B14F),
                          disabledBackgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: authController.isLoading.value
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Sign In",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                      ),
                    )),
                const SizedBox(height: 16),
                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/sign-up');
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Color(0xFF00B14F),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dialog for forgot password
  void _showForgotPasswordDialog(
      BuildContext context, AuthController authController) {
    final TextEditingController resetEmailController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text(
          "Reset Password",
          style: TextStyle(color: Color(0xFF00B14F)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Enter your email address to receive password reset link."),
            SizedBox(height: 16),
            TextField(
              controller: resetEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF00B14F), width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          Obx(() => ElevatedButton(
                onPressed: authController.isLoading.value
                    ? null
                    : () async {
                        if (resetEmailController.text.trim().isNotEmpty) {
                          await authController.sendPasswordResetEmail(
                            resetEmailController.text.trim(),
                          );
                          Get.back();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00B14F),
                ),
                child: authController.isLoading.value
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Send",
                        style: TextStyle(color: Colors.white),
                      ),
              )),
        ],
      ),
    );
  }
}
