import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flying Birds Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final int _numberOfBirds = 5; // Number of birds to animate
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _verticalAnimations = [];
  final List<Animation<double>> _horizontalAnimations = [];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers and animations for each bird
    for (int i = 0; i < _numberOfBirds; i++) {
      final controller = AnimationController(
        duration: const Duration(seconds: 3), // Duration for flying out and back
        vsync: this, // Using TickerProviderStateMixin
      );

      final verticalAnimation = Tween<double>(begin: 0, end: -30).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );

      _controllers.add(controller);
      _verticalAnimations.add(verticalAnimation);

      // Start the flight cycle with a staggered delay
      Future.delayed(Duration(milliseconds: i * 300), () {
        _startFlight(controller);
      });
    }

    // Simulate a loading time of 5 seconds
    Timer(Duration(seconds: 5), () {
      // Navigate to the next screen or perform any other action
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  void _startFlight(AnimationController controller) {
    // Start the forward animation
    controller.forward().then((_) {
      // Pause before reversing direction
      Future.delayed(Duration(seconds: 1), () {
        // Start the reverse animation
        controller.reverse().then((_) {
          // Start the cycle again
          _startFlight(controller);
        });
      });
    });
  }

  @override
  void dispose() {
    // Dispose all animation controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery here ensures that context is fully built
    final screenWidth = MediaQuery.of(context).size.width;

    // Initialize horizontal animations
    if (_horizontalAnimations.isEmpty) {
      for (int i = 0; i < _numberOfBirds; i++) {
        final horizontalAnimation = TweenSequence([
          // Fly from left to right
          TweenSequenceItem(
            tween: Tween<double>(begin: -150, end: screenWidth + 150),
            weight: 1,
          ),
          // Fly back from right to left
          TweenSequenceItem(
            tween: Tween<double>(begin: screenWidth + 150, end: -150),
            weight: 1,
          ),
        ]).animate(
          CurvedAnimation(
            parent: _controllers[i],
            curve: Curves.easeInOut,
          ),
        );
        _horizontalAnimations.add(horizontalAnimation);
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Stack(
          children: List.generate(_numberOfBirds, (index) {
            return AnimatedBuilder(
              animation: _controllers[index],
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _horizontalAnimations[index].value,
                    _verticalAnimations[index].value + index * 20,
                  ),
                  child: Image.asset(
                    'assets/bird.png', // Replace with your own image
                    width: 50,
                    height: 50,
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
