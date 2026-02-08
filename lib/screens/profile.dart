import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitfuture/screens/loginScreen.dart';
import 'package:fitfuture/utils/constants.dart';
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
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
        "name": nameController.text.trim(),
        "gender": userData?["gender"] ?? "Male",
        "age": int.tryParse(ageController.text) ?? 0,
        "height": double.tryParse(heightController.text) ?? 0,
        "weight": double.tryParse(weightController.text) ?? 0,
        "phone": phoneController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile updated successfully!"),
            backgroundColor: AppConstants.neonGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }

      setState(() => isEditing = false);
    } catch (e) {
      debugPrint("Error updating profile: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error updating profile: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _genderChoice(String g) {
    bool isSelected = userData?["gender"] == g;
    return GestureDetector(
      onTap: () {
        setState(() {
          userData?["gender"] = g;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppConstants.neonGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppConstants.neonGreen),
        ),
        child: Text(
          g,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppConstants.darkBackground,
        body: Center(
          child: CircularProgressIndicator(color: AppConstants.neonGreen),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppConstants.darkBackground,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBackground,
        elevation: 0,
        title: const Text(
          "My Profile",
          style: TextStyle(
              color: AppConstants.neonGreen,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppConstants.neonGreen, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check_circle : Icons.edit_note,
                color: AppConstants.neonGreen, size: 28),
            onPressed: () {
              if (isEditing) {
                updateProfile();
              } else {
                setState(() => isEditing = true);
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Header
            Center(
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppConstants.neonGreen, Colors.blueAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(
                        (userData?["gender"]?.toString().toLowerCase() ==
                                "female")
                            ? "https://randomuser.me/api/portraits/women/20.jpg"
                            : "https://randomuser.me/api/portraits/men/20.jpg",
                      ),
                    ),
                  ),
                  if (isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppConstants.neonGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.black, size: 20),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              nameController.text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const Text(
              "Elite Athlete",
              style: TextStyle(
                  color: AppConstants.neonGreen,
                  fontSize: 14,
                  letterSpacing: 1.2),
            ),
            const SizedBox(height: 30),

            // Statistics Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _infoStat("Weight", "${weightController.text} kg"),
                  _infoStat("Height", "${heightController.text} cm"),
                  _infoStat("Age", ageController.text),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Fields
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppConstants.surfaceColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  _editableField(
                      "Full Name", nameController, Icons.person_outline),
                  _editableField(
                      "Email Address",
                      TextEditingController(text: user!.email ?? ""),
                      Icons.email_outlined,
                      readOnly: true),
                  _editableField(
                      "Phone Number", phoneController, Icons.phone_outlined,
                      keyboardType: TextInputType.phone),
                  _editableField(
                      "Age", ageController, Icons.calendar_today_outlined,
                      keyboardType: TextInputType.number),
                  _editableField("Height (cm)", heightController, Icons.height,
                      keyboardType: TextInputType.number),
                  _editableField("Weight (kg)", weightController,
                      Icons.monitor_weight_outlined,
                      keyboardType: TextInputType.number),

                  if (isEditing) ...[
                    const SizedBox(height: 20),
                    const Text("Change Gender",
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _genderChoice("Male"),
                        const SizedBox(width: 15),
                        _genderChoice("Female"),
                      ],
                    ),
                  ],

                  const SizedBox(height: 30),

                  // Logout Button
                  InkWell(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.redAccent.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Ionicons.log_out_outline,
                              color: Colors.redAccent),
                          SizedBox(width: 10),
                          Text(
                            "Logout Account",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoStat(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _editableField(
      String label, TextEditingController controller, IconData icon,
      {bool readOnly = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        readOnly: !isEditing || readOnly,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color:
                  isEditing && !readOnly ? AppConstants.neonGreen : Colors.grey,
              fontSize: 14),
          prefixIcon: Icon(icon,
              color:
                  isEditing && !readOnly ? AppConstants.neonGreen : Colors.grey,
              size: 22),
          filled: true,
          fillColor: AppConstants.darkBackground.withOpacity(0.5),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppConstants.neonGreen, width: 1.5),
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
