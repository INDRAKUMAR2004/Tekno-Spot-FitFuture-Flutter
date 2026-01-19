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

  bool _loading = false;

  Future<void> _signup() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    try {
      setState(() => _loading = true);
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text("Create Account",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 20),
              _buildField("Full Name", _nameController),
              _buildField("Phone Number", _phoneController, keyboardType: TextInputType.phone),
              _buildField("Email", _emailController, keyboardType: TextInputType.emailAddress),
              _buildField("Password", _passwordController, obscureText: true),
              _buildField("Age (years)", _ageController, keyboardType: TextInputType.number),
              _buildField("Height (e.g., 1.75 m)", _heightController),
              _buildField("Weight (e.g., 70 kg)", _weightController),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _loading ? null : _signup,
                child: Text(_loading ? "Signing up..." : "Sign Up",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text("Already have an account? Login", style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String hint, TextEditingController controller,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.green),
          enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.green), borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.green), borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
