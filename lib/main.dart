import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomePage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 8));
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFace(ImageProvider? image, Color? color, double x, double y, double z) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(50.0 * x, 50.0 * y, 50.0 * z)
        ..rotateX(0.6)
        ..rotateY(0.6),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: color,
          image: image != null
              ? DecorationImage(
                  image: image,
                  fit: BoxFit.cover,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: color?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCube() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..rotateX(_controller.value * 2.0 * 3.1415927)
            ..rotateY(_controller.value * 2.0 * 3.1415927),
          child: Stack(
            children: [
              _buildFace(NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT0HMFJz_CP5-8fRcNGjy9bX-SOe5hxg0r-KA&s'), null, -1, 0, 0), // Front face with image
              _buildFace(null, Colors.green, 1, 0, 0), // Back face with color
              _buildFace(NetworkImage('https://cdn.iconscout.com/icon/free/png-256/free-github-logo-icon-download-in-svg-png-gif-file-formats--wordmark-programming-language-logos-pack-icons-1174970.png'), null, 0, -1, 0), // Left face with image
              _buildFace(null, Colors.yellow, 0, 1, 0), // Right face with color
              _buildFace(NetworkImage('https://w7.pngwing.com/pngs/512/824/png-transparent-visual-studio-code-hd-logo-thumbnail.png'), null, 0, 0, -1), // Top face with image
              _buildFace(null, Colors.orange, 0, 0, 1), // Bottom face with color
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _buildCube(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
