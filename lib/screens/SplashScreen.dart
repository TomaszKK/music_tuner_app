import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the services package
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Lock the orientation to portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,  // Lock to portrait
      DeviceOrientation.portraitDown, // Lock to portrait
    ]);

    // Simulate a loading period before navigating to the next screen
    Future.delayed(const Duration(seconds: 3), () {
      // After 3 seconds, navigate to the next screen (e.g., HomePage)
      // Unlock the orientation when leaving the splash screen
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]).then((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NextScreen()), // Replace with your next screen
        );
      });
    });
  }

  @override
  void dispose() {
    // Unlock the orientation when the splash screen is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.green,
          size: 50.0,
        ),
      ),
    );
  }
}

// Replace with your actual next screen
class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(child: const Text('Welcome to the Home Page!')),
    );
  }
}
