import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProgressTracking extends StatefulWidget {
  const ProgressTracking({super.key});

  @override
  State<ProgressTracking> createState() => _ProgressTrackingState();
}

class _ProgressTrackingState extends State<ProgressTracking> {
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Controllers for modal
  final TextEditingController activityCtrl = TextEditingController();
  final TextEditingController durationCtrl = TextEditingController();
  final TextEditingController kcalCtrl = TextEditingController();

  Future<void> _addActivity() async {
    String activity = activityCtrl.text.trim();
    String duration = durationCtrl.text.trim();
    String kcal = kcalCtrl.text.trim();

    if (activity.isEmpty || duration.isEmpty || kcal.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    try {
      await firestore.collection("users").doc(user!.uid).update({
        "activity": {
          "done": activity,
          "duration": duration,
          "calories_burned": kcal,
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Activity updated successfully")),
      );

      activityCtrl.clear();
      durationCtrl.clear();
      kcalCtrl.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating activity: $e")),
      );
    }
  }

  void _showAddActivityModal() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF111111),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter Activity",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF39FF14),
                  ),
                ),
                const SizedBox(height: 15),
                _buildInput(activityCtrl, "Activity name"),
                _buildInput(durationCtrl, "Duration (min)", isNumber: true),
                _buildInput(kcalCtrl, "Calories", isNumber: true),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addActivity,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF39FF14),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Add Activity",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String hint,
      {bool isNumber = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFF1a1a1a),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 15)),
          Text(value.isNotEmpty ? value : "N/A",
              style: const TextStyle(color: Color(0xFF39FF14), fontSize: 15)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Center(
        child: Text(
          "Please log in to view your progress.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: firestore.collection("users").doc(user!.uid).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF39FF14)),
              );
            }

            final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
            final activity = data["activity"] ?? {};
            final name = data["name"] ?? "Guest User";
            final age = data["age"] ?? "N/A";
            final weight = data["weight"] ?? "N/A";
            final height = data["height"] ?? "N/A";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16).copyWith(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Progress Tracking",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF39FF14),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Profile Card
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            const SizedBox(height: 4),
                            Text("Age: $age",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildStat("$weight Kg"),
                                const SizedBox(width: 15),
                                _buildStat("$height m"),
                              ],
                            )
                          ],
                        ),
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                              "https://randomuser.me/api/portraits/men/20.jpg"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// Add Activity Button
                  ElevatedButton(
                    onPressed: _showAddActivityModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF39FF14),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      "+ Add Activity",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// Activity Summary BELOW button
                  const Text(
                    "Activity Summary",
                    style: TextStyle(
                      color: Color(0xFF39FF14),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildActivityRow(
                      "Activity Done", activity["done"]?.toString() ?? "N/A"),
                  _buildActivityRow("Calories Burned",
                      activity["calories_burned"]?.toString() ?? "N/A"),
                  _buildActivityRow(
                      "Duration", "${activity["duration"]?.toString() ?? 'N/A'} min"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStat(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1a1a1a),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 14, color: Color(0xFF39FF14)),
      ),
    );
  }
}
