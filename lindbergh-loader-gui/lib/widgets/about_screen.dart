import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage('assets/images/sega-logo.png'),
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Lindbergh Loader',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text('A Linux-only Lindbergh games manager and loader'),
          ],
        ),
      ),
    );
  }
}
