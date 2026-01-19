import 'package:fitfuture/screens/excercise_details.dart';
import 'package:flutter/material.dart';

class DayExercises extends StatelessWidget {
  const DayExercises({super.key});

  static const neonGreen = Color(0xFF39FF14);
  static const darkBg = Colors.black;

  final List<Map<String, String>> exercises = const [
    {
      "title": "Plank Hold",
      "description": "Engages Core and Shoulders",
      "duration": "00:30",
      "image": "assets/Images/plank.jpg"
    },
    {
      "title": "Bicycle Crunches",
      "description": "Targets Abs & Obliques",
      "duration": "01:00",
      "image": "assets/Images/bicycle.jpg"
    },
    {
      "title": "Russian Twists",
      "description": "Core Rotation Movement",
      "duration": "01:00",
      "image": "assets/Images/russian.jpg"
    },
    {
      "title": "Leg Raises",
      "description": "Lower abs & hip flexors",
      "duration": "01:00",
      "image": "assets/Images/legraises.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Day 1 – Core Challenge",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: neonGreen,
              ),
            ),
            const SizedBox(height: 20),

            // Exercise List
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ExerciseDetails(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111111),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: neonGreen.withOpacity(0.2),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Exercise Image
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: neonGreen, width: 2),
                              image: DecorationImage(
                                image: AssetImage(exercise["image"]!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),

                          // Exercise Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exercise["title"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: neonGreen,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  exercise["description"]!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  exercise["duration"]!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: neonGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Start Workout Button
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
                    builder: (_) => const ExerciseDetails(),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  "Start Workout",
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
