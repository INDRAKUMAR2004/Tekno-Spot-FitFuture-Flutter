import 'package:fitfuture/screens/profile.dart';
import 'package:flutter/material.dart';

class ProfileEditScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String weight;
  final String height;
  final String age;

  const ProfileEditScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.weight,
    required this.height,
    required this.age,
  });

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;
  late TextEditingController weightCtrl;
  late TextEditingController heightCtrl;
  late TextEditingController ageCtrl;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.name);
    emailCtrl = TextEditingController(text: widget.email);
    phoneCtrl = TextEditingController(text: widget.phone);
    weightCtrl = TextEditingController(text: widget.weight);
    heightCtrl = TextEditingController(text: widget.height);
    ageCtrl = TextEditingController(text: widget.age);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back Button
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF39FF14)),
              onPressed: () => Navigator.pop(context),
            ),

            // Header
            const Center(
              child: Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF39FF14),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Avatar
            const Center(
              child: CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage(
                  "https://randomuser.me/api/portraits/men/20.jpg",
                ),
              ),
            ),
            const SizedBox(height: 10),

            Center(
              child: Text(
                nameCtrl.text,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF39FF14)),
              ),
            ),
            Center(
              child: Text(
                emailCtrl.text,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _inputField("Full Name", nameCtrl),
                    _inputField("Email", emailCtrl),
                    _inputField("Mobile Number", phoneCtrl),
                    _inputField("Weight", weightCtrl, inputType: TextInputType.number),
                    _inputField("Height", heightCtrl, inputType: TextInputType.number),
                    _inputField("Age", ageCtrl, inputType: TextInputType.number),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF39FF14),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      
                      onPressed: () {
                        // Send updated data back
                        Navigator.pop(context, {
                          "name": nameCtrl.text,
                          "email": emailCtrl.text,
                          "phone": phoneCtrl.text,
                          "weight": weightCtrl.text,
                          "height": heightCtrl.text,
                          "age": ageCtrl.text,
                        });
                      },
                      child: const Text(
                        "Update",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        style: const TextStyle(color: Color(0xFF39FF14)),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF111111),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF39FF14)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF39FF14)),
          ),
        ),
      ),
    );
  }
}
