import 'package:flutter/material.dart';

class TopPicksScreen extends StatelessWidget {
  const TopPicksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Picks & Great Offers')),
      body: const Center(
        child: Text('Top picks and great offers will be shown here.'),
      ),
    );
  }
}
