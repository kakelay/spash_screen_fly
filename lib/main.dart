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
  final int _numberOfBirds = 8;
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _verticalAnimations = [];
  final List<Animation<double>> _horizontalAnimations = [];

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers and animations
    for (int i = 0; i < _numberOfBirds; i++) {
      final controller = AnimationController(
        duration: const Duration(seconds: 3),
        vsync: this,
      )..addListener(() {
          setState(() {});
        });

      final verticalAnimation = Tween<double>(begin: 0, end: -30).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeInOut,
        ),
      );

      _controllers.add(controller);
      _verticalAnimations.add(verticalAnimation);

      // Start the flight cycle with a staggered delay
      Future.delayed(Duration(milliseconds: i * 250), () {
        _startFlight(controller);
      });
    }

    // Simulate a loading time of 3 seconds before navigating
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Initialize horizontal animations
    if (_horizontalAnimations.isEmpty) {
      for (int i = 0; i < _numberOfBirds; i++) {
        final horizontalAnimation = Tween<double>(
          begin: -150,
          end: screenWidth + 150,
        ).animate(
          CurvedAnimation(
            parent: _controllers[i],
            curve: Curves.easeInOut,
          ),
        );
        _horizontalAnimations.add(horizontalAnimation);
      }
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 116, 203, 10),
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
                    'assets/bird.png',
                    width: 50,
                    height: 50,
                    color: Colors.white,
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }

  void _startFlight(AnimationController controller) {
    // Start the forward animation
    controller.forward().then((_) {
      // Optionally, add logic for reversing the animation if needed
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
