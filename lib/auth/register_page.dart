import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool passwordConfirmed() {
    return passwordController.text.trim() ==
        confirmPasswordController.text.trim();
  }

  Future<void> signUp() async {
    if (!passwordConfirmed()) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Passwords don't match."),
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(e.message ?? 'An error occurred'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Icon(Icons.person_add, size: 100),
                SizedBox(height: 24),
                Text("Create an account",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 24),

                // Email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                SizedBox(height: 12),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Password"),
                ),
                SizedBox(height: 12),

                // Confirm Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Confirm Password"),
                ),
                SizedBox(height: 24),

                // Register Button
                ElevatedButton(
                  onPressed: signUp,
                  child: Text("Register"),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50)),
                ),

                SizedBox(height: 16),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already a member? "),
                    GestureDetector(
                      onTap: widget.showLoginPage,
                      child: Text("Login now",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
