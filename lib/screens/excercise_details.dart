import 'package:flutter/material.dart';
import 'package:fitfuture/screens/exercise_video_screen.dart';

class ExerciseDetails extends StatelessWidget {
  final Map<String, String> exercise;

  const ExerciseDetails({super.key, required this.exercise});

  static const neonGreen = Color(0xFF39FF14);
  static const darkBg = Colors.black;

  @override
  Widget build(BuildContext context) {
    // Determine video URL based on title (or fallback)
    String videoUrl =
        "https://test-videos.co.uk/vids/jellyfish/mp4/h264/1080/Jellyfish_1080_10s_1MB.mp4"; // Default sample

    // Using some sample exercise clips from a different source
    if (exercise["title"] == "Plank Hold") {
      videoUrl =
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4";
    } else {
      // General fitness related sample
      videoUrl =
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4";
    }

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
                image: DecorationImage(
                  image: AssetImage(exercise["image"] ??
                      exercise["img"] ??
                      "assets/Images/plank.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title + Duration
            Text(
              exercise["title"] ?? "Exercise",
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: neonGreen,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              exercise["duration"] ?? "01:00",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            // Key Details
            const SectionHeader(title: "Key Details"),
            DetailText(
                text: "• Duration: ${exercise["duration"] ?? "1 Minute"}"),
            const DetailText(text: "• Calories Burned: ~6 kcal"),
            const DetailText(text: "• Difficulty: Beginner/Intermediate"),

            // Step by Step
            const SectionHeader(title: "Step-by-Step Guide"),
            const DetailText(
                text:
                    "• How to set up: Maintain proper posture and engage core."),
            const DetailText(
                text: "• Maintain form: Keep movements controlled and steady."),
            const DetailText(
                text:
                    "• Avoid mistakes: Don't rush; focus on the target muscle."),

            // Safety Tips
            const SectionHeader(title: "Safety Tips"),
            const DetailText(
                text: "• Stop immediately if you feel sharp pain."),
            const DetailText(text: "• Keep the area clear of obstructions."),
            const DetailText(text: "• Stay hydrated throughout your workout."),

            const SizedBox(height: 30),

            // Continue Button (Now plays video)
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
            const SizedBox(height: 20),
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
