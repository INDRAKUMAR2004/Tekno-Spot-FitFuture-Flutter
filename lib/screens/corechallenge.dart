
import 'package:fitfuture/screens/HomeScreen.dart';
import 'package:fitfuture/screens/dayExcercise.dart';
import 'package:flutter/material.dart';

class ChallengeOverview extends StatelessWidget {
  static const neonGreen = Color(0xFF39FF14);
  static const darkBg = Colors.black;

  const ChallengeOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  icon: const Icon(Icons.arrow_back, color: neonGreen, size: 22),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Core Challenge",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: neonGreen,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Description
            const Text(
              "5-10 min abs workout daily • Planks, crunches, leg raises\n"
              "Goal: Stronger core & better posture",
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),

            const SizedBox(height: 20),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: 0.3,
                minHeight: 12,
                color: neonGreen,
                backgroundColor: Colors.grey[800],
              ),
            ),

            const SizedBox(height: 20),

            // Timeline Box
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: neonGreen.withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWeek("Week 1"),
                  const SizedBox(height: 16),
                  _buildWeek("Week 2"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Start Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: neonGreen,
                foregroundColor: darkBg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shadowColor: neonGreen,
                elevation: 8,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DayExercises()),
                );
              },
              child: const Center(
                child: Text(
                  "Start",
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

  Widget _buildWeek(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: neonGreen,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            return Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: neonGreen,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "${index + 1}",
                  style: const TextStyle(
                    color: darkBg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
