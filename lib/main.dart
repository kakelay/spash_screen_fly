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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.grey.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center, // Align items in the center of the stack
            children: [
              
              // Flying birds
              ...List.generate(_numberOfBirds, (index) {
                return AnimatedBuilder(
                  animation: _controllers[index],
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..translate(
                          _horizontalAnimations[index].value,
                          _verticalAnimations[index].value + index * 20,
                        )
                        ..rotateZ(index.isEven ? 0.1 : -0.1), // Slight rotation for variety
                      child: Image.asset(
                        'assets/logo.png',
                        width: 150,
                        height: 150,
                       
                      ),
                    );
                  },
                );
              }),

              // Centered text
              
            ],
          ),
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
