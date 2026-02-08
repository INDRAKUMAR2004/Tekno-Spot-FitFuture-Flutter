import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  bool _isLoading = false;
  String _gender = "Male"; // Default

  /// SIGNUP → Creating account in Firebase Auth & Saving data to Firestore
  Future<void> _signup() async {
    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final age = _ageController.text.trim();
    final height = _heightController.text.trim();
    final weight = _weightController.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        age.isEmpty ||
        height.isEmpty ||
        weight.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Create User in Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        // 2. Store additional info in Firestore
        await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": name,
          "phone": phone,
          "email": email,
          "gender": _gender,
          "age": int.tryParse(age) ?? 0,
          "height": double.tryParse(height) ?? 0,
          "weight": double.tryParse(weight) ?? 0,
          "createdAt": FieldValue.serverTimestamp(),
        });

        // 3. Update Display Name in Firebase Auth (optional but good practice)
        await user.updateDisplayName(name);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Account created successfully!"),
              backgroundColor: Color(0xFF39FF14),
            ),
          );
          // Redirection is handled by AuthWrapper in main.dart,
          // or we can manually push to home if needed.
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = "Signup failed";
      if (e.code == 'weak-password') {
        message = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        message = "The account already exists for that email.";
      } else if (e.code == 'invalid-email') {
        message = "The email address is badly formatted.";
      }
      _showError(message);
    } catch (e) {
      debugPrint("Signup Error: $e");
      _showError("Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(message, style: const TextStyle(color: Colors.white)),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Text(
                "FitFuture",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF39FF14),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Create Account 🚀",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF39FF14),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Join us for a healthier lifestyle",
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 35),
              _inputBox("Full Name", _nameController, icon: Icons.person),
              const SizedBox(height: 18),
              _inputBox("Phone Number", _phoneController,
                  icon: Icons.phone, keyboardType: TextInputType.phone),
              const SizedBox(height: 18),
              _inputBox("Email", _emailController,
                  icon: Icons.email, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 18),
              _inputBox("Password", _passwordController,
                  icon: Icons.lock, obscure: true),
              const SizedBox(height: 25),

              // Gender Selection
              Row(
                children: [
                  const Text("Gender: ",
                      style: TextStyle(
                          color: Color(0xFF39FF14),
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(width: 15),
                  _genderChip("Male"),
                  const SizedBox(width: 10),
                  _genderChip("Female"),
                ],
              ),
              const SizedBox(height: 25),

              Row(
                children: [
                  Expanded(
                      child: _inputBox("Age", _ageController,
                          keyboardType: TextInputType.number)),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _inputBox("Height", _heightController,
                          keyboardType: TextInputType.number)),
                  const SizedBox(width: 15),
                  Expanded(
                      child: _inputBox("Weight", _weightController,
                          keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 40),
              _isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF39FF14))
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF39FF14),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(
                    color: Color(0xFF39FF14),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _genderChip(String g) {
    bool isSelected = _gender == g;
    return GestureDetector(
      onTap: () => setState(() => _gender = g),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF39FF14) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF39FF14)),
        ),
        child: Text(
          g,
          style: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFF39FF14),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _inputBox(String label, TextEditingController controller,
      {bool obscure = false,
      IconData? icon,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null
            ? Icon(icon, color: const Color(0xFF39FF14), size: 20)
            : null,
        labelStyle: const TextStyle(color: Color(0xFF39FF14), fontSize: 14),
        filled: true,
        fillColor: Colors.black,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF39FF14)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF39FF14), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
