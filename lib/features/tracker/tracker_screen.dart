import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Tracker'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'Health Tracker Screen',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}