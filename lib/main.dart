import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.grey,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _colorAnimation.value,
          body: Center(
            child: LoadingAnimation(),
          ),
        );
      },
    );
  }
}

class LoadingAnimation extends StatefulWidget {
  @override
  _LoadingAnimationState createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(100, 100), // Adjust the size as needed
      painter: CarWheelPainter(dotAnimation: _animationController),
    );
  }
}

class CarWheelPainter extends CustomPainter {
  final Animation<double> dotAnimation;

  CarWheelPainter({required this.dotAnimation}) : super(repaint: dotAnimation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final double radius = size.width / 2;

    // Draw the wheel outer circle
    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);

    // Draw wheel spokes
    paint
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final int numberOfSpokes = 6;
    for (int i = 0; i < numberOfSpokes; i++) {
      double angle = (i / numberOfSpokes) * 2 * pi;
      double x = (size.width / 2) + radius * cos(angle);
      double y = (size.height / 2) + radius * sin(angle);
      canvas.drawLine(Offset(size.width / 2, size.height / 2), Offset(x, y), paint);
    }

    // Draw wheel hub
    final Paint hubPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 10, hubPaint);

    // Draw moving circle
    final Paint circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final double moveRadius = radius - 10; // Distance from center to move circle
    final double angle = dotAnimation.value * 2 * pi; // Full rotation
    final double circleX = (size.width / 2) + moveRadius * cos(angle);
    final double circleY = (size.height / 2) + moveRadius * sin(angle);

    canvas.drawCircle(Offset(circleX, circleY), 8, circlePaint);
  }

  @override
  bool shouldRepaint(CarWheelPainter oldDelegate) => true;
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Screen')),
      body: Center(
        child: Text('Welcome to the Home Screen!'),
      ),
    );
  }
}
