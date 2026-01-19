import 'package:fitfuture/screens/workoutoverview.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16).copyWith(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              const Text(
                "Discover",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF39FF14),
                ),
              ),
              const SizedBox(height: 16),

              /// Big Challenge Card
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutOverview()));
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        "assets/Images/plank.jpg",
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.3),
                        colorBlendMode: BlendMode.darken,
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "30-Days Plank Challenge",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF39FF14),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Strengthen Your Core Day By Day With Progressive Planks.",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutOverview()));},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF39FF14),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Join Now",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Recommended Section
              const SizedBox(height: 20),
              const Text(
                "Recommended For You",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF39FF14),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildSmallCard(
                      "Core & Cardio Fusion",
                      "30 Min • Core",
                      "assets/Images/bicycle.jpg",
                    ),
                    buildSmallCard(
                      "Sunrise Stretch Flow",
                      "20 Min • Full Body",
                      "assets/Images/russian.jpg",
                    ),
                    buildSmallCard(
                      "Upper-Body Power",
                      "25 Min • Strength",
                      "assets/Images/legraises.jpg",
                    ),
                  ],
                ),
              ),

              /// Another Banner
              const SizedBox(height: 20),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      "assets/Images/plank.jpg",
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                    ),
                  ),
                  const Positioned(
                    left: 20,
                    bottom: 20,
                    right: 20,
                    child: Text(
                      "Your Muscles Are Ready. Let's Build Strength.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF39FF14),
                      ),
                    ),
                  ),
                ],
              ),

              /// Next-Level Section
              const SizedBox(height: 20),
              const Text(
                "Next-Level Sessions",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF39FF14),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    buildSmallCard("Cardio Blast", "", "assets/Images/bicycle.jpg"),
                    buildSmallCard("Core Burn", "", "assets/Images/russian.jpg"),
                    buildSmallCard(
                        "Endurance Row Circuit", "", "assets/Images/legraises.jpg"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable Small Card Widget
  Widget buildSmallCard(String title, String subtitle, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 150,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (subtitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF39FF14)),
              ),
            ),
        ],
      ),
    );
  }
}
