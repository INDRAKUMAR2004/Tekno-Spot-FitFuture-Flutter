import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NutritionOverview extends StatefulWidget {
  const NutritionOverview({super.key});

  @override
  State<NutritionOverview> createState() => _NutritionOverviewState();
}

class _NutritionOverviewState extends State<NutritionOverview> {
  bool isLoading = true;
  Map<String, dynamic>? dietData;

  @override
  void initState() {
    super.initState();
    fetchUserDiet();
  }

  Future<void> fetchUserDiet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc =
          await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data()!;
        final diet = data["diet"] ?? {};

        setState(() {
          dietData = {
            "Breakfast": diet["morning"] ?? "No data",
            "Morning Snack": diet["morning_snacks"] ?? "No data",
            "Lunch": diet["afternoon"] ?? "No data",
            "Evening Snack": diet["evening_snacks"] ?? "No data",
            "Dinner": diet["night"] ?? "No data",
          };
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error fetching diet: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Nutrition Overview",
          style: TextStyle(color: Color(0xFF39FF14), fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF39FF14)),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF39FF14)),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "No nutrition data found for this user.",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final diet = data["diet"] ?? {};
          

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    "Your Daily Nutrition Plan",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.greenAccent.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                /// Diet Cards
                _buildMealCard("Breakfast", diet["morning"] ?? "No data"),
                _buildMealCard("Morning Snack", diet["morning_snacks"] ?? "No data"),
                _buildMealCard("Lunch", diet["afternoon"] ?? "No data"),
                _buildMealCard("Evening Snack", diet["evening_snacks"] ?? "No data"),
                _buildMealCard("Dinner", diet["night"] ?? "No data"),

                const SizedBox(height: 30),
               
                
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealCard(String title, String description) {
    return Card(
      color: Colors.black,
      elevation: 6,
      shadowColor: const Color(0xFF39FF14).withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color(0xFF39FF14), width: 1),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.restaurant_menu, color: Color(0xFF39FF14), size: 30),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF39FF14),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}