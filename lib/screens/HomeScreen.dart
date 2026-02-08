// lib/screens/HomeScreen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitfuture/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:fitfuture/screens/profile.dart';
import 'package:fitfuture/screens/workoutoverview.dart';
import 'package:fitfuture/screens/nutritionOverview.dart';
import 'package:fitfuture/screens/discover.dart';
import 'package:fitfuture/screens/progress.dart';
import 'package:fitfuture/screens/chatbot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Future<Map<String, String>> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {"name": "Athlete", "gender": "Male"};

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      final data = snapshot.data();
      if (data != null) {
        return {
          "name": data['name']?.toString() ?? "Athlete",
          "gender": data['gender']?.toString() ?? "Male",
        };
      }
    } catch (_) {}
    return {
      "name": user.displayName ?? user.email?.split('@')[0] ?? "Athlete",
      "gender": "Male",
    };
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _HomePageBody(getUserData: _getUserData),
      const NutritionOverview(),
      const DiscoverScreen(),
      const ProgressTracking(),
      const ChatbotScreen(),
    ];

    return Scaffold(
      backgroundColor: AppConstants.darkBackground,
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border:
              Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppConstants.darkBackground,
          selectedItemColor: AppConstants.neonGreen,
          unselectedItemColor: Colors.grey[600],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu), label: 'Diet'),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore_outlined), label: 'Explore'),
            BottomNavigationBarItem(
                icon: Icon(Icons.analytics_outlined), label: 'Stats'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline), label: 'AI'),
          ],
        ),
      ),
    );
  }
}

class _HomePageBody extends StatelessWidget {
  final Future<Map<String, String>> Function() getUserData;
  const _HomePageBody({required this.getUserData});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FutureBuilder<Map<String, String>>(
                future: getUserData(),
                builder: (context, snapshot) {
                  final name = snapshot.data?["name"] ?? "Athlete";
                  final gender = snapshot.data?["gender"] ?? "Male";
                  final portraitUrl = gender.toLowerCase() == "female"
                      ? "https://randomuser.me/api/portraits/women/20.jpg"
                      : "https://randomuser.me/api/portraits/men/20.jpg";

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome back,",
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 13),
                            ),
                            Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ProfileScreen())),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppConstants.neonGreen,
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: NetworkImage(portraitUrl),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                height: 55,
                decoration: BoxDecoration(
                  color: AppConstants.surfaceColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 12),
                    Text("Search workouts...",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Featured Challenge
            _sectionTitle("Featured Challenge"),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildFeaturedCard(context),
            ),
            const SizedBox(height: 30),

            // Recommended Workouts
            _sectionTitle("Recommended for You"),
            const SizedBox(height: 15),
            SizedBox(
              height: 240,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 20),
                children: [
                  _workoutCard(context, "Full Body HIIT",
                      "25 Min • High Intensity", "assets/Images/bicycle.jpg"),
                  _workoutCard(context, "Morning Yoga", "15 Min • Relaxation",
                      "assets/Images/russian.jpg"),
                  _workoutCard(context, "Core Strength",
                      "20 Min • Intermediate", "assets/Images/legraises.jpg"),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Daily Motivation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppConstants.neonGreen.withOpacity(0.8),
                      Colors.blueAccent.withOpacity(0.8)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Daily Motivation",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    SizedBox(height: 8),
                    Text(
                      "\"The only bad workout is the one that didn't happen.\"",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => WorkoutOverview())),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: AssetImage("assets/Images/plank.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.8), Colors.transparent],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "30-Day Core Challenge",
                style: TextStyle(
                    color: AppConstants.neonGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Step up your fitness game today.",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _workoutCard(
      BuildContext context, String title, String subtitle, String image) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => WorkoutOverview())),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(image,
                  height: 140, width: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
