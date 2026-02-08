import 'package:flutter/material.dart';
import 'package:fitfuture/screens/exercise_video_screen.dart';

class WorkoutDetails extends StatelessWidget {
  final Map<String, String> exercise;

  static const neonGreen = Color(0xFF39FF14);
  static const darkBg = Color(0xFF0D0D0D);

  const WorkoutDetails({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    // Determine video URL based on title (or fallback)
    String videoUrl =
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4";

    if (exercise["title"] == "High Knees") {
      videoUrl =
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4";
    }

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
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: neonGreen),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      exercise["img"] ??
                          exercise["image"] ??
                          "assets/Images/plank.jpg",
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercise["title"] ?? "Exercise",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: neonGreen)),
                        Text(exercise["description"] ?? "Workout session",
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey)),
                        Text(exercise["duration"] ?? "00:45",
                            style: const TextStyle(
                                fontSize: 12, color: neonGreen)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            sectionHeader("Key Details"),
            sectionText("• Duration: ${exercise["duration"] ?? "45 Seconds"}"),
            sectionText("• Estimated Calories: 6 kcal"),
            sectionText("• Difficulty: Beginner/Intermediate"),

            sectionHeader("Step-By-Step Guide"),
            sectionText("• Stand Tall With Feet Hip-Width Apart."),
            sectionText("• Engage Your Core And Keep Your Chest Lifted."),

            sectionHeader("Safety Tips"),
            sectionText("• Warm Up Before Starting To Prevent Injury."),
            sectionText(
                "• Land Softly On Balls Of Feet To Reduce Joint Impact."),
            sectionText("• Maintain Upright Posture, Avoid Leaning Forward."),

            sectionHeader("Breathing Tips"),
            sectionText(
                "• Inhale Through Nose, Exhale Through Mouth Steadily."),
            sectionText("• Match Breathing With Steps."),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: neonGreen,
                  foregroundColor: darkBg,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseVideoScreen(
                        exerciseTitle: exercise["title"] ?? "Exercise",
                        videoUrl: videoUrl,
                      ),
                    ),
                  );
                },
                child: const Text("Continue",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget sectionHeader(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(text,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: neonGreen)),
      );

  Widget sectionText(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(fontSize: 14, color: Colors.white70)),
      );
}
