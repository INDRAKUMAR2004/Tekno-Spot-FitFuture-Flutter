import 'package:fitfuture/screens/HomeScreen.dart';
import 'package:fitfuture/screens/forgotPassword.dart';
import 'package:fitfuture/screens/loginScreen.dart';
import 'package:fitfuture/screens/signupScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // requires firebase_options if using FlutterFire CLI
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitFuture',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: const Color(0xFF00FF00),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF00FF00),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/forgotPassword': (context) => const ForgotPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

/// Auth wrapper to auto-redirect
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}
