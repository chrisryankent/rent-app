import 'package:flutter/material.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deals of the Day')),
      body: const Center(
        child: Text('All deals of the day will be shown here.'),
      ),
    );
  }
}
