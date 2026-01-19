import 'package:fitfuture/screens/workout_derails.dart';
import 'package:flutter/material.dart';

class WorkoutOverview extends StatelessWidget {
  final List<Map<String, String>> exercises = [
    {
      "title": "High Knees",
      "description": "Run in place lifting knees high",
      "duration": "00:45",
      "img": "assets/Images/bicycle.jpg",
    },
    {
      "title": "Mountain Climbers",
      "description": "Cardio + core move",
      "duration": "01:00",
      "img": "assets/Images/russian.jpg",
    },
    {
      "title": "Plank Shoulder Taps",
      "description": "Plank with alternate taps",
      "duration": "00:45",
      "img": "assets/Images/plank.jpg",
    },
    {
      "title": "Side Plank Hip Dips",
      "description": "Strengthen obliques",
      "duration": "00:45",
      "img": "assets/Images/legraises.jpg",
    },
  ];

  static const neonGreen = Color(0xFF39FF14);
  static const darkBg = Color(0xFF0D0D0D);

  WorkoutOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exercises.length + 2, // +2 for header + footer
        itemBuilder: (context, index) {
          if (index == 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/Images/plank.jpg",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Core & Cardio Fusion",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: neonGreen,
                  ),
                ),
                const Text(
                  "5 Exercises • Min Duration",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
              ],
            );
          } else if (index == exercises.length + 1) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: darkBg,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => WorkoutDetails()),
                );
              },
              child: const Text("Start", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            );
          }

          final item = exercises[index - 1];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => WorkoutDetails()),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: neonGreen),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item["img"]!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item["title"]!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: neonGreen)),
                        Text(item["description"]!, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Text(item["duration"]!, style: const TextStyle(fontSize: 12, color: neonGreen)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
