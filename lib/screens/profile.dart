import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitfuture/screens/HomeScreen.dart';
import 'package:fitfuture/screens/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;
  late TextEditingController phoneController;

  bool isEditing = false;
  bool isLoading = true;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    heightController = TextEditingController();
    weightController = TextEditingController();
    phoneController = TextEditingController();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get();

      if (doc.exists) {
        userData = doc.data();

        nameController.text = userData?["name"] ?? "";
        ageController.text = userData?["age"]?.toString() ?? "";
        heightController.text = userData?["height"]?.toString() ?? "";
        weightController.text = userData?["weight"]?.toString() ?? "";
        phoneController.text = userData?["phone"]?.toString() ?? "";
      }

      setState(() => isLoading = false);
    } catch (e) {
      debugPrint("Error fetching user profile: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> updateProfile() async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).update({
        "name": nameController.text.trim(),
        "age": int.tryParse(ageController.text) ?? 0,
        "height": double.tryParse(heightController.text) ?? 0,
        "weight": double.tryParse(weightController.text) ?? 0,
        "phone": phoneController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Color(0xFF39FF14),
        ),
      );

      setState(() => isEditing = false);
    } catch (e) {
      debugPrint("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating profile: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF39FF14)),
        ),
      );
    }

    if (userData == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text("No user data found.", style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Color(0xFF39FF14), fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF39FF14)),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.save : Icons.edit, color: const Color(0xFF39FF14)),
            onPressed: () {
              if (isEditing) {
                updateProfile();
              } else {
                setState(() => isEditing = true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage("https://randomuser.me/api/portraits/men/20.jpg"),
            ),
            const SizedBox(height: 12),

            _editableField("Name", nameController),
            _editableField("Email", TextEditingController(text: user!.email ?? ""), readOnly: true),
            _editableField("Phone", phoneController),
            _editableField("Age", ageController),
            _editableField("Height (cm)", heightController),
            _editableField("Weight (kg)", weightController),

            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade800),
            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(Ionicons.log_out, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _editableField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        readOnly: !isEditing || readOnly,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF39FF14)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF39FF14)),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF39FF14), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
