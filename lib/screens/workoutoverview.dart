import 'package:fitfuture/screens/workout_derails.dart';
import 'package:fitfuture/utils/constants.dart';
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

  WorkoutOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppConstants.darkBackground,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    "assets/Images/plank.jpg",
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppConstants.darkBackground.withOpacity(0.95),
                          Colors.transparent
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: const Text(
                "Core & Cardio Fusion",
                style: TextStyle(
                    color: AppConstants.neonGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              centerTitle: false,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "5 Exercises • 15 Min • Intermediate",
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "This intense fusion session combines high-intensity cardio with targeted core strengthening to maximize calorie burn and stability.",
                    style: TextStyle(
                        fontSize: 14, color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Exercises",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final item = exercises[index];
                return _buildExerciseCard(context, item);
              },
              childCount: exercises.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: AppConstants.darkBackground.withOpacity(0.9),
          border:
              Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.neonGreen,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            minimumSize: const Size(double.infinity, 50),
            elevation: 10,
            shadowColor: AppConstants.neonGreen.withOpacity(0.4),
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => WorkoutDetails(exercise: exercises[0])));
          },
          child: const Text("START WORKOUT",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, Map<String, String> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WorkoutDetails(exercise: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.03)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(item["img"]!,
                  width: 75, height: 75, fit: BoxFit.cover),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item["title"]!,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(item["description"]!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: AppConstants.neonGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Text(item["duration"]!,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.neonGreen)),
            ),
          ],
        ),
      ),
    );
  }
}
