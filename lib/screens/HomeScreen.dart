// lib/screens/home_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:fitfuture/screens/about.dart';
import 'package:fitfuture/screens/corechallenge.dart';
import 'package:fitfuture/screens/excercise_details.dart';
import 'package:fitfuture/screens/notifications.dart';
import 'package:fitfuture/screens/profile.dart';
import 'package:fitfuture/screens/workoutoverview.dart';
import 'package:fitfuture/screens/nutritionOverview.dart';
import 'package:fitfuture/screens/discover.dart';
import 'package:fitfuture/screens/progress.dart';
import 'package:fitfuture/screens/chatbot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static Widget sectionTitle(BuildContext context, String title,
      {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF39FF14)),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ]
      ]),
    );
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  /// ✅ Fetch user name from Firestore (users collection), fallback to FirebaseAuth
  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Guest";

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection("users").doc(user.uid).get();
      final data = snapshot.data();
      if (data != null && data['name'] != null && data['name'].toString().isNotEmpty) {
        return data['name'];
      }
    } catch (_) {}
    return user.displayName ?? user.email ?? "User";
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _HomePageBody(getUserName: _getUserName),
      const NutritionOverview(),
      const DiscoverScreen(),
      const ProgressTracking(),
      const ChatbotScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF39FF14),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Nutrition'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.support_agent), label: 'Chatbot'),
        ],
      ),
    );
  }
}

/// -------------------- HOME PAGE BODY --------------------
class _HomePageBody extends StatelessWidget {
  final Future<String> Function() getUserName;
  const _HomePageBody({required this.getUserName});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          FutureBuilder<String>(
            future: getUserName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Loading...",
                      style: TextStyle(color: Color(0xFF39FF14))),
                );
              }
              return Header(userName: snapshot.data ?? "Guest");
            },
          ),
          const SizedBox(height: 12),
          const SearchBar(),
          const SizedBox(height: 16),
          const HomeBanner(),
          const SizedBox(height: 24),

          /// CHALLENGES
          HomeScreen.sectionTitle(context, "Challenges"),
          const SizedBox(height: 10),
          SizedBox(
            height: 230,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                ChallengeCard(
                  days: "14-Day",
                  title: "Core Challenge",
                  points: ["5–10 min abs daily", "Plank, Crunches, Leg Raise"],
                  goal: "Stronger core & posture",
                ),
                ChallengeCard(
                  days: "7-Day",
                  title: "Full Body Burn",
                  points: ["15–20 min", "Squats, Pushups, Burpees"],
                  goal: "Boost stamina",
                ),
                ChallengeCard(
                  days: "30-Day",
                  title: "Yoga Flow",
                  points: ["20 min daily", "Flexibility & Calmness"],
                  goal: "Improve mobility",
                ),
              ],
            ),
          ),

          /// MADE FOR YOU
          HomeScreen.sectionTitle(context, "Made for You",
              subtitle: "Personalized workouts to match your goals."),
          const WorkoutCard(
            title: "Full-Body Circuit",
            description: "Balanced strength and cardio",
            details: "30 mins • 8 exercises",
            image: "assets/Images/fbc.jpg",
          ),
          const WorkoutCard(
            title: "Morning Energy Flow",
            description: "Gentle stretches and light cardio",
            details: "20 mins • 5 exercises",
            image: "assets/Images/mef.jpg",
          ),
          const WorkoutCard(
            title: "Strength Challenge",
            description: "Upper, lower, core",
            details: "30 mins • 8 exercises",
            image: "assets/Images/sc.jpg",
          ),

          /// FAVOURITES
          HomeScreen.sectionTitle(context, "Our Favourites",
              subtitle: "Curated workouts we love for you."),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                ExerciseCard(
                    title: "Squat Exercise",
                    duration: "12 mins",
                    calories: "120 Kcal",
                    image: "assets/Images/squat.jpg"),
                ExerciseCard(
                    title: "Core Crusher",
                    duration: "25 mins",
                    calories: "180 Kcal",
                    image: "assets/Images/corecrusher.jpg"),
                ExerciseCard(
                    title: "Cardio Kick",
                    duration: "25 mins",
                    calories: "200 Kcal",
                    image: "assets/Images/cardio.jpg"),
                ExerciseCard(
                    title: "Lunge Blast",
                    duration: "18 mins",
                    calories: "160 Kcal",
                    image: "assets/Images/lbp.jpg"),
              ],
            ),
          ),

          /// TOP HITS
          HomeScreen.sectionTitle(context, "Top Hits",
              subtitle: "Must-try workouts everyone loves."),
          const WorkoutCard(
            title: "Power HIIT Blast",
            description: "High intensity intervals",
            details: "25 mins • 6 exercises",
            image: "assets/Images/hiit.jpg",
          ),
          const WorkoutCard(
            title: "Morning Yoga Flow",
            description: "Gentle stretch & breathing",
            details: "25 mins • 6 exercises",
            image: "assets/Images/myf.jpg",
          ),
          const WorkoutCard(
            title: "Cardio Kickboxing",
            description: "Punch & kick high-energy",
            details: "25 mins • 6 exercises",
            image: "assets/Images/ckb.jpg",
          ),

          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

/// -------------------- HEADER --------------------
class Header extends StatelessWidget {
  final String userName;
  const Header({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Hi, $userName",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF39FF14))),
            const SizedBox(height: 4),
            const Text("It's time to challenge your limits.",
                style: TextStyle(fontSize: 12, color: Color(0xFF39FF14))),
          ]),
        ),
        IconButton(
            icon: const Icon(Icons.info, color: Color(0xFF39FF14)),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const AboutPage()))),
        IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFF39FF14)),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const NotificationsPage()))),
        IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF39FF14)),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const ProfileScreen()))),
      ]),
    );
  }
}

/// -------------------- SEARCH BAR --------------------
class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFF39FF14)),
      ),
      child: const Row(children: [
        Icon(Icons.search, color: Color(0xFF39FF14)),
        SizedBox(width: 8),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search",
                hintStyle: TextStyle(color: Color(0xFF39FF14)),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              style: TextStyle(color: Color(0xFF39FF14)),
            ),
          ),
        ),
      ]),
    );
  }
}

/// -------------------- HOME BANNER --------------------
class HomeBanner extends StatelessWidget {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
            image: AssetImage("assets/Images/banner.jpg"), fit: BoxFit.cover),
      ),
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [
            Colors.black.withOpacity(0.35),
            Colors.transparent,
          ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Weekly Challenge",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.lightBlue)),
            SizedBox(height: 6),
            Text("Strengthen your core & sculpt obliques.",
                style: TextStyle(fontSize: 12, color: Colors.white)),
            SizedBox(height: 2),
            Text("Hold steady, twist with control each day.",
                style: TextStyle(fontSize: 10, color: Colors.white)),
          ]),
        ),
      ),
    );
  }
}

/// -------------------- CHALLENGE CARD --------------------
class ChallengeCard extends StatelessWidget {
  final String days;
  final String title;
  final List<String> points;
  final String goal;

  const ChallengeCard({
    super.key,
    required this.days,
    required this.title,
    required this.points,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ChallengeOverview())),
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF39FF14)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(days,
              style: const TextStyle(
                  color: Color(0xFF39FF14), fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          ...points.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child:
                    Text("• $p", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              )),
          const Spacer(),
          Text(goal,
              style:
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const ChallengeOverview())),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF39FF14),
                foregroundColor: Colors.black,
              ),
              child: const Text("Start"),
            ),
          ),
        ]),
      ),
    );
  }
}

/// -------------------- EXERCISE CARD --------------------
class ExerciseCard extends StatelessWidget {
  final String title;
  final String duration;
  final String calories;
  final String image;

  const ExerciseCard(
      {super.key,
      required this.title,
      required this.duration,
      required this.calories,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ExerciseDetails())),
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFF39FF14)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(image,
                  height: 110, width: double.infinity, fit: BoxFit.cover)),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(title,
                  style: const TextStyle(
                      color: Color(0xFF39FF14), fontWeight: FontWeight.bold))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                const Icon(Icons.timer, size: 14, color: Color(0xFF39FF14)),
                const SizedBox(width: 6),
                Text(duration,
                    style: const TextStyle(color: Colors.white, fontSize: 12))
              ]),
              Row(children: [
                const Icon(Icons.local_fire_department,
                    size: 14, color: Color(0xFF39FF14)),
                const SizedBox(width: 6),
                Text(calories,
                    style: const TextStyle(color: Colors.white, fontSize: 12))
              ]),
            ]),
          )
        ]),
      ),
    );
  }
}

/// -------------------- WORKOUT CARD --------------------
class WorkoutCard extends StatelessWidget {
  final String title;
  final String description;
  final String details;
  final String image;

  const WorkoutCard(
      {super.key,
      required this.title,
      required this.description,
      required this.details,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => WorkoutOverview())),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF39FF14)),
        ),
        child: Row(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(image,
                  width: 110, height: 80, fit: BoxFit.cover)),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF39FF14))),
              const SizedBox(height: 6),
              Text(description,
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(details,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
          )
        ]),
      ),
    );
  }
}
