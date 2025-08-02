// TODO Implement this library.
// widgets/feature_chip.dart
import 'package:flutter/material.dart';

class FeatureChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureChip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.blue),
      label: Text(text),
      backgroundColor: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}