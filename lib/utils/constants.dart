import 'package:flutter/material.dart';

class AppConstants {
  // Theme Colors
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color darkBackground = Colors.black;
  static const Color surfaceColor = Color(0xFF111111);
  static const Color cardColor = Color(0xFF1A1A1A);

  // API Keys (⚠️ In a real production app, use environment variables or a secure backend)
  static const String groqApiKey =
      "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";
  static const String groqModel = "llama-3.3-70b-versatile";
  static const String groqUrl =
      "https://api.groq.com/openai/v1/chat/completions";
}
