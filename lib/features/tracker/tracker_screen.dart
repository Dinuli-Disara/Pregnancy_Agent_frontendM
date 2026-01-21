import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  int waterGlasses = 0;
  double sleepHours = 7;
  int kicks = 0;

  final List<String> symptoms = [
    'Nausea',
    'Back Pain',
    'Headache',
    'Fatigue',
    'Swelling',
    'Heartburn'
  ];

  final Set<String> selectedSymptoms = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Tracker'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 💧 Water Intake
            _sectionTitle('Water Intake'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (waterGlasses > 0) {
                      setState(() => waterGlasses--);
                    }
                  },
                ),
                Text(
                  '$waterGlasses glasses',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() => waterGlasses++);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// 😴 Sleep
            _sectionTitle('Sleep Hours'),
            Slider(
              value: sleepHours,
              min: 0,
              max: 12,
              divisions: 24,
              label: '${sleepHours.toStringAsFixed(1)} h',
              onChanged: (value) {
                setState(() => sleepHours = value);
              },
            ),
            Text(
              '${sleepHours.toStringAsFixed(1)} hours',
              style: TextStyle(color: AppColors.textSecondary),
            ),

            const SizedBox(height: 24),

            /// 👶 Baby Kicks
            _sectionTitle('Baby Kicks'),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (kicks > 0) {
                      setState(() => kicks--);
                    }
                  },
                ),
                Text(
                  '$kicks kicks',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() => kicks++);
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// 🤒 Symptoms
            _sectionTitle('Symptoms'),
            Wrap(
              spacing: 10,
              children: symptoms.map((symptom) {
                final isSelected = selectedSymptoms.contains(symptom);
                return FilterChip(
                  label: Text(symptom),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedSymptoms.add(symptom);
                      } else {
                        selectedSymptoms.remove(symptom);
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 40),

            /// 💾 Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _saveData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Save Today\'s Data',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Section Title Widget
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 🔹 Save Logic (later connect to backend)
  void _saveData() {
    debugPrint('Water: $waterGlasses');
    debugPrint('Sleep: $sleepHours');
    debugPrint('Kicks: $kicks');
    debugPrint('Symptoms: $selectedSymptoms');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Daily data saved successfully'),
      ),
    );
  }
}
