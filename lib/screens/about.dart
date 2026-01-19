import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const neonGreen = Color(0xFF39FF14);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading 1
              const Text(
                "About FitFuture",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: neonGreen,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "FitFuture is a completely free platform built to support teen and student athletes in school and college. Our mission is simple: empower the next generation of athletes by providing AI-powered personalized diet and workout plans tailored to their goals, sport, and training schedule. By combining advanced technology with sports science, FitFuture helps athletes train smarter, recover better, and reach their full potential — without any cost.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),

              // Divider
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 1,
                color: neonGreen,
              ),

              // Heading 2
              const Text(
                "About the Creator",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: neonGreen,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "FitFuture was created by Ahsan Kaja, a passionate student-athlete, innovator, and researcher. Ahsan is a state-level football and badminton player, a national-level archer, and a tech creator with multiple patents in AI-based solutions. His dedication to sports and technology inspired him to design FitFuture as a way to give back to the athletic community — making AI-driven, elite-level training support accessible to every student-athlete.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
