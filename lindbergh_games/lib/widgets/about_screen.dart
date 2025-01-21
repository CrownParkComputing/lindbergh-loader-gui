import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  Future<void> _launchURL(String url) async {
    // TODO: Implement Linux URL opening
    print('Would open URL: $url');
  }

  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lindbergh Games Launcher',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'A Flutter-based GUI frontend for the Lindbergh Loader project.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Based on the original Lindbergh Loader:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchURL('https://github.com/lindbergh-loader/lindbergh-loader'),
              child: const Text(
                'https://github.com/lindbergh-loader/lindbergh-loader',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Game library management'),
            const Text('• Launch games with custom executable paths'),
            const Text('• Access test menus with -t flag'),
            const Text('• Game compatibility information'),
            const Text('• Intuitive UI with game icons'),
            const SizedBox(height: 24),
            const Text(
              'License:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('MIT License'),
            const Spacer(),
            Center(
              child: Text(
                '© 2023 Lindbergh Games Launcher',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
