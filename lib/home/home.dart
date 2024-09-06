import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('YouTube'),
          actions: [
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  print("onclick ");
                })
          ],
        ),
        body: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: const Color(0xFFFFC107),
                  height: 1000,
                  width: 400,
                  child: Image.network(
                    'https://www.norton-u.com/images/logo-banner-blue.png',
                  ),
                ),
              ],
            ),
            Image.asset('assets/logo.png')
          ],
        ));
  }
}
