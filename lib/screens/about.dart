import 'package:fitfuture/utils/constants.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.darkBackground,
      appBar: AppBar(
        backgroundColor: AppConstants.darkBackground,
        elevation: 0,
        title: const Text("About FitFuture",
            style: TextStyle(
                color: AppConstants.neonGreen, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppConstants.neonGreen, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section with subtle gradient
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppConstants.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: AppConstants.neonGreen.withOpacity(0.1)),
              ),
              child: const Column(
                children: [
                  Icon(Icons.auto_awesome,
                      color: AppConstants.neonGreen, size: 50),
                  SizedBox(height: 15),
                  Text(
                    "FitFuture",
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "AI-Powered Athletic Excellence",
                    style: TextStyle(
                        fontSize: 14,
                        color: AppConstants.neonGreen,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            _buildSection(
              "Our Mission",
              "FitFuture is a completely free platform built to support teen and student athletes in school and college. Our mission is simple: empower the next generation of athletes by providing AI-powered personalized diet and workout plans tailored to their goals, sport, and training schedule. By combining advanced technology with sports science, FitFuture helps athletes train smarter, recover better, and reach their full potential — without any cost.",
            ),

            const SizedBox(height: 30),

            _buildSection(
              "The Creator",
              "FitFuture was created by Ahsan Kaja, a passionate student-athlete, innovator, and researcher. Ahsan is a state-level football and badminton player, a national-level archer, and a tech creator with multiple patents in AI-based solutions. His dedication to sports and technology inspired him to design FitFuture as a way to give back to the athletic community — making AI-driven, elite-level training support accessible to every student-athlete.",
            ),

            const SizedBox(height: 40),

            Center(
              child: Text(
                "Version 1.0.0",
                style: TextStyle(color: Colors.grey[800], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppConstants.neonGreen,
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          content,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
