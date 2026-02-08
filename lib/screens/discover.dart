import 'package:fitfuture/screens/workoutoverview.dart';
import 'package:fitfuture/utils/constants.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Discover",
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        "Find your next challenge",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: AppConstants.surfaceColor,
                        borderRadius: BorderRadius.circular(12)),
                    child:
                        const Icon(Icons.search, color: AppConstants.neonGreen),
                  )
                ],
              ),
              const SizedBox(height: 25),

              /// Big Challenge Card
              _buildFeaturedCard(
                context,
                "30-Days Plank Challenge",
                "Strengthen your core day by day with progressive planks.",
                "assets/Images/plank.jpg",
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => WorkoutOverview())),
              ),

              /// Recommended Section
              const SizedBox(height: 30),
              const Text(
                "Recommended For You",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildSmallCard(
                      context,
                      "Core & Cardio Fusion",
                      "30 Min • Intermediate",
                      "assets/Images/bicycle.jpg",
                    ),
                    _buildSmallCard(
                      context,
                      "Sunrise Stretch Flow",
                      "20 Min • Beginner",
                      "assets/Images/russian.jpg",
                    ),
                    _buildSmallCard(
                      context,
                      "Upper-Body Power",
                      "25 Min • Advanced",
                      "assets/Images/legraises.jpg",
                    ),
                  ],
                ),
              ),

              /// Premium Banner
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [AppConstants.neonGreen, Colors.blueAccent]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Go Premium",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          SizedBox(height: 4),
                          Text(
                              "Unlock all specialized workout plans & diet guides.",
                              style: TextStyle(
                                  color: Colors.black87, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.lock_open, color: Colors.black54, size: 40),
                  ],
                ),
              ),

              /// Next-Level Section
              const SizedBox(height: 30),
              const Text(
                "Next-Level Sessions",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 180,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildSmallCard(context, "Cardio Blast", "Hard",
                        "assets/Images/bicycle.jpg"),
                    _buildSmallCard(context, "Core Burn", "Intense",
                        "assets/Images/russian.jpg"),
                    _buildSmallCard(context, "Endurance Row", "Steady",
                        "assets/Images/legraises.jpg"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, String title,
      String description, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: AppConstants.neonGreen.withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8))
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(imagePath,
                  height: 220, width: double.infinity, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.neonGreen)),
                  const SizedBox(height: 6),
                  Text(description,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        color: AppConstants.neonGreen,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text("Join Now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 13)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallCard(
      BuildContext context, String title, String subtitle, String imagePath) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => WorkoutOverview())),
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 160,
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.asset(imagePath,
                  width: 160, height: 100, fit: BoxFit.cover),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 11, color: AppConstants.neonGreen)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
