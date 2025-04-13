import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:code_structure/ui/screens/auth/sign_in_screen.dart';
import 'package:code_structure/ui/screens/root_screen/root_screen.dart';
import 'package:code_structure/ui/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    print("Starting navigation logic...");
    await Future.delayed(
        const Duration(seconds: 2)); // Adding delay for splash screen
    print("Starting prefs");
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTime') ?? true;
    print("End prefs");
    if (isFirstTime) {
      print("Starting navigation logic...");
      await prefs.setBool('isFirstTime', false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => StartScreen()),
      );
    } else {
      try {
        final session = await Amplify.Auth.fetchAuthSession();
        if (session.isSignedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => RootScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AuthScreen()),
          );
        }
      } catch (e) {
        debugPrint("Error during session check: $e");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AuthScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0XFFE6DCB8),
                Color(0XFF645830),
              ],
            ),
          ),
          child: Image.asset(
            "assets/static_assets/logo.png",
            scale: 3,
          ),
        ),
      ),
    );
  }
}
