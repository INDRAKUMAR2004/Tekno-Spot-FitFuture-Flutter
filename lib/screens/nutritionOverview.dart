import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitfuture/utils/constants.dart';
import 'package:flutter/material.dart';

class NutritionOverview extends StatefulWidget {
  const NutritionOverview({super.key});

  @override
  State<NutritionOverview> createState() => _NutritionOverviewState();
}

class _NutritionOverviewState extends State<NutritionOverview> {
  final TextEditingController breakfastCtrl = TextEditingController();
  final TextEditingController morningSnackCtrl = TextEditingController();
  final TextEditingController lunchCtrl = TextEditingController();
  final TextEditingController eveningSnackCtrl = TextEditingController();
  final TextEditingController dinnerCtrl = TextEditingController();
  bool _isUpdating = false;

  Future<void> _updateDiet() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: User not logged in")),
      );
      return;
    }

    setState(() => _isUpdating = true);

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .set({
        "diet": {
          "morning": breakfastCtrl.text.trim(),
          "morning_snacks": morningSnackCtrl.text.trim(),
          "afternoon": lunchCtrl.text.trim(),
          "evening_snacks": eveningSnackCtrl.text.trim(),
          "night": dinnerCtrl.text.trim(),
          "updatedAt": FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Diet plan updated successfully"),
            backgroundColor: AppConstants.neonGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  @override
  void dispose() {
    breakfastCtrl.dispose();
    morningSnackCtrl.dispose();
    lunchCtrl.dispose();
    eveningSnackCtrl.dispose();
    dinnerCtrl.dispose();
    super.dispose();
  }

  void _showEditDietModal(Map<String, dynamic> currentDiet) {
    breakfastCtrl.text = currentDiet["morning"] ?? "";
    morningSnackCtrl.text = currentDiet["morning_snacks"] ?? "";
    lunchCtrl.text = currentDiet["afternoon"] ?? "";
    eveningSnackCtrl.text = currentDiet["evening_snacks"] ?? "";
    dinnerCtrl.text = currentDiet["night"] ?? "";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20,
              left: 20,
              right: 20),
          decoration: const BoxDecoration(
              color: AppConstants.surfaceColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(2)),
                ),
                const Text("Update Nutrition Plan",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.neonGreen)),
                const SizedBox(height: 25),
                _buildEditInput(breakfastCtrl, "Breakfast"),
                _buildEditInput(morningSnackCtrl, "Morning Snack"),
                _buildEditInput(lunchCtrl, "Lunch"),
                _buildEditInput(eveningSnackCtrl, "Evening Snack"),
                _buildEditInput(dinnerCtrl, "Dinner"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isUpdating
                      ? null
                      : () async {
                          setModalState(() => _isUpdating = true);
                          await _updateDiet();
                          if (mounted) setModalState(() => _isUpdating = false);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.neonGreen,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    minimumSize: const Size(double.infinity, 50),
                    elevation: 5,
                    shadowColor: AppConstants.neonGreen.withOpacity(0.3),
                  ),
                  child: _isUpdating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text("Save Plan",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditInput(TextEditingController ctrl, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        maxLines: null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          filled: true,
          fillColor: AppConstants.darkBackground.withOpacity(0.5),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[800]!)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  const BorderSide(color: AppConstants.neonGreen, width: 1.5)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppConstants.darkBackground,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBackground,
        elevation: 0,
        title: const Text(
          "Nutrition Plan",
          style: TextStyle(
              color: AppConstants.neonGreen,
              fontWeight: FontWeight.bold,
              fontSize: 22),
        ),
        actions: [
          IconButton(
            icon:
                const Icon(Icons.calendar_month, color: AppConstants.neonGreen),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                builder: (context, child) => Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                        primary: AppConstants.neonGreen,
                        onPrimary: Colors.black,
                        surface: AppConstants.surfaceColor,
                        onSurface: Colors.white),
                    dialogBackgroundColor: AppConstants.darkBackground,
                  ),
                  child: child!,
                ),
              );
              if (date != null) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "Selected: ${date.day}/${date.month}/${date.year}")));
              }
            },
          ),
        ],
      ),
      body: currentUser == null
          ? const Center(child: Text("Please log in to see your diet plan"))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(currentUser.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Error loading diet: ${snapshot.error}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: AppConstants.neonGreen));
                }

                final data =
                    snapshot.data?.data() as Map<String, dynamic>? ?? {};
                final diet =
                    (data["diet"] as Map?)?.cast<String, dynamic>() ?? {};

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _macroCard("Carbs", "120g", 0.6, Colors.blue),
                          _macroCard("Protein", "80g", 0.4, Colors.red),
                          _macroCard("Fats", "45g", 0.3, Colors.orange),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Today's Schedule",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          IconButton(
                              onPressed: () => _showEditDietModal(diet),
                              icon: const Icon(Icons.edit_note,
                                  color: AppConstants.neonGreen, size: 28)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      _buildMealCard(
                          "Breakfast",
                          diet["morning"] ?? "Oatmeal with fruits",
                          "08:00 AM",
                          Icons.wb_sunny_outlined),
                      _buildMealCard(
                          "Morning Snack",
                          diet["morning_snacks"] ?? "Handful of almonds",
                          "11:00 AM",
                          Icons.apple_outlined),
                      _buildMealCard(
                          "Lunch",
                          diet["afternoon"] ?? "Grilled chicken & rice",
                          "01:30 PM",
                          Icons.restaurant_outlined),
                      _buildMealCard(
                          "Evening Snack",
                          diet["evening_snacks"] ?? "Greek yogurt",
                          "05:00 PM",
                          Icons.coffee_outlined),
                      _buildMealCard(
                          "Dinner",
                          diet["night"] ?? "Salmon with asparagus",
                          "08:30 PM",
                          Icons.nightlight_round_outlined),
                      const SizedBox(height: 30),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _macroCard(String label, String value, double percent, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 4,
                backgroundColor: Colors.grey[900],
                color: color),
          ),
          const SizedBox(height: 12),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildMealCard(
      String title, String description, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppConstants.neonGreen.withOpacity(0.1))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: AppConstants.neonGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppConstants.neonGreen, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: AppConstants.neonGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text(time,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(description,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
