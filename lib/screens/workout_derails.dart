import 'package:flutter/material.dart';

class WorkoutDetails extends StatelessWidget {
  static const neonGreen = Color(0xFF39FF14);
  static const darkBg = Color(0xFF0D0D0D);

  const WorkoutDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Card
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: neonGreen),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/Images/plank.jpg",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Core & Cardio Fusion", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: neonGreen)),
                        Text("Run in Place Lifting Knees High", style: TextStyle(fontSize: 13, color: Colors.grey)),
                        Text("00:45", style: TextStyle(fontSize: 12, color: neonGreen)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            sectionHeader("Key Details"),
            sectionText("• Duration: 45 Seconds"),
            sectionText("• Estimated Calories: 6 kcal"),
            sectionText("• Difficulty: Beginner/Intermediate"),

            sectionHeader("Step-By-Step Guide"),
            sectionText("• Stand Tall With Feet Hip-Width Apart."),
            sectionText("• Engage Your Core And Keep Your Chest Lifted."),

            sectionHeader("Safety Tips"),
            sectionText("• Warm Up Before Starting To Prevent Injury."),
            sectionText("• Land Softly On Balls Of Feet To Reduce Joint Impact."),
            sectionText("• Maintain Upright Posture, Avoid Leaning Forward."),

            sectionHeader("Breathing Tips"),
            sectionText("• Inhale Through Nose, Exhale Through Mouth Steadily."),
            sectionText("• Match Breathing With Steps."),

            const SizedBox(height: 20),
            Container(
              width: 700,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: neonGreen,
                  foregroundColor: darkBg,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: const Text("Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: neonGreen)),
      );

  Widget sectionText(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.white70)),
      );
}
