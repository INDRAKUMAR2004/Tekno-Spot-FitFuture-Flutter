import 'package:flutter/material.dart';

class ExerciseDetails extends StatelessWidget {
  const ExerciseDetails({super.key});

  static const neonGreen = Color(0xFF39FF14);
  static const darkBg = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Image
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: neonGreen, width: 2),
                image: const DecorationImage(
                  image: AssetImage("assets/Images/plank.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title + Duration
            const Text(
              "Plank Hold",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: neonGreen,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "00:30",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            // Key Details
            const SectionHeader(title: "Key Details"),
            const DetailText(text: "• Duration: 30 Seconds"),
            const DetailText(text: "• Calories Burned: ~5 kcal"),
            const DetailText(text: "• Difficulty: Beginner/Intermediate"),

            // Step by Step
            const SectionHeader(title: "Step-by-Step Guide"),
            const DetailText(text: "• How to set up: Elbows under shoulders, body in straight line."),
            const DetailText(text: "• Maintain form: Engage core, don’t drop hips."),
            const DetailText(text: "• Avoid mistakes: Don’t hold breath during plank."),

            // Safety Tips
            const SectionHeader(title: "Safety Tips"),
            const DetailText(text: "• Keep core tight to avoid arching or sagging lower back."),
            const DetailText(text: "• Align shoulders over elbows to prevent shoulder strain."),
            const DetailText(text: "• Stop if sharp pain occurs."),

            // Breathing Tips
            const SectionHeader(title: "Breathing Tips"),
            const DetailText(text: "• Inhale through nose for slow count of four."),
            const DetailText(text: "• Exhale through mouth for slow count of four, keeping core tight."),
            const DetailText(text: "• Maintain steady rhythm."),

            const SizedBox(height: 30),

            // Continue Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: darkBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shadowColor: neonGreen,
                elevation: 6,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Center(
                child: Text(
                  "Continue",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 Reusable Section Header
class SectionHeader extends StatelessWidget {
  final String title;
  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ExerciseDetails.neonGreen,
        ),
      ),
    );
  }
}

// 🔹 Reusable Detail Text
class DetailText extends StatelessWidget {
  final String text;
  const DetailText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.5,
          color: Colors.grey,
        ),
      ),
    );
  }
}
