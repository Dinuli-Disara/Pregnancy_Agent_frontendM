import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text(
          'AI Insights Screen',
          style: TextStyle(
            fontSize: 24,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}