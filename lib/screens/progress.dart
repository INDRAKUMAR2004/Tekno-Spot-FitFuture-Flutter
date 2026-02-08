import 'package:fitfuture/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
        const SnackBar(
            content: Text("Please fill in all fields"),
            behavior: SnackBarBehavior.floating),
      );
      return;
    }

    try {
      await firestore.collection("users").doc(user!.uid).set({
        "activity": {
          "done": activity,
          "duration": duration,
          "calories_burned": kcal,
          "updatedAt": FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("✅ Activity updated successfully"),
              backgroundColor: AppConstants.neonGreen,
              behavior: SnackBarBehavior.floating),
        );
        Navigator.pop(context);
      }

      activityCtrl.clear();
      durationCtrl.clear();
      kcalCtrl.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error updating activity: $e"),
              behavior: SnackBarBehavior.floating),
        );
      }
    }
  }

  void _showAddActivityModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: AppConstants.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10)),
              ),
              const Text(
                "Track New Activity",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.neonGreen),
              ),
              const SizedBox(height: 25),
              _buildInput(activityCtrl, "Activity name", Icons.directions_run),
              _buildInput(durationCtrl, "Duration (min)", Icons.timer,
                  isNumber: true),
              _buildInput(
                  kcalCtrl, "Calories Burned", Icons.local_fire_department,
                  isNumber: true),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: _addActivity,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.neonGreen,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  minimumSize: const Size(double.infinity, 54),
                ),
                child: const Text("Update Progress",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String hint, IconData icon,
      {bool isNumber = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: AppConstants.neonGreen),
          filled: true,
          fillColor: AppConstants.darkBackground,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[800]!)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: AppConstants.neonGreen)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Text("Please log in to view progress",
                style: TextStyle(color: Colors.white))),
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
                  child:
                      CircularProgressIndicator(color: AppConstants.neonGreen));
            }

            final data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
            final activity = data["activity"] ?? {};
            final name = data["name"] ?? "Athlete";

            double caloriesBurned = double.tryParse(
                    activity["calories_burned"]?.toString() ?? "0") ??
                0;
            double calorieGoal = 500.0; // Simulated goal
            double percent = (caloriesBurned / calorieGoal).clamp(0.0, 1.0);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hello, $name",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14)),
                          const Text("Daily Progress",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      IconButton(
                        onPressed: _showAddActivityModal,
                        icon: const Icon(Icons.add_circle,
                            color: AppConstants.neonGreen, size: 32),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Goal Indicator
                  Center(
                    child: CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 12.0,
                      percent: percent,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${(percent * 100).toInt()}%",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold)),
                          const Text("Goal",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      progressColor: AppConstants.neonGreen,
                      backgroundColor: Colors.grey[900]!,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Stats Grid
                  Row(
                    children: [
                      Expanded(
                          child: _statCard(
                              "Calories",
                              "${caloriesBurned.toInt()}",
                              "kcal",
                              Icons.local_fire_department,
                              Colors.orange)),
                      const SizedBox(width: 15),
                      Expanded(
                          child: _statCard(
                              "Duration",
                              activity["duration"]?.toString() ?? "0",
                              "min",
                              Icons.timer,
                              Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _statCard(
                      "Last Activity",
                      activity["done"]?.toString() ?? "None",
                      "",
                      Icons.directions_run,
                      AppConstants.neonGreen,
                      fullWidth: true),

                  const SizedBox(height: 30),

                  // Weekly Chart Placeholder
                  const Text("Weekly Activity",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Container(
                    height: 150,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppConstants.surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (index) {
                        double height =
                            [0.4, 0.7, 0.5, 0.9, 0.6, 0.8, 0.3][index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              width: 12,
                              height: 80 * height,
                              decoration: BoxDecoration(
                                color: index == 3
                                    ? AppConstants.neonGreen
                                    : Colors.grey[800],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(["M", "T", "W", "T", "F", "S", "S"][index],
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 10)),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statCard(
      String label, String value, String unit, IconData icon, Color color,
      {bool fullWidth = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: value,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      if (unit.isNotEmpty)
                        TextSpan(
                            text: " $unit",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
