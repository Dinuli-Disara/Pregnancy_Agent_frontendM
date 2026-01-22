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

  final List<Map<String, dynamic>> symptoms = [
    {'name': 'Nausea', 'color': Colors.orange},
    {'name': 'Back Pain', 'color': Colors.red},
    {'name': 'Headache', 'color': Colors.purple},
    {'name': 'Fatigue', 'color': Colors.blue},
    {'name': 'Swelling', 'color': Colors.teal},
    {'name': 'Heartburn', 'color': Colors.deepOrange},
  ];

  final Set<String> selectedSymptoms = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Tracker',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Track your daily wellness',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.monitor_heart,
                        color: AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Water Intake Card
                _buildTrackerCard(
                  title: 'Water Intake',
                  subtitle: 'Stay hydrated',
                  icon: Icons.water_drop,
                  color: Colors.blue,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildControlButton(
                            icon: Icons.remove,
                            onPressed: () {
                              if (waterGlasses > 0) {
                                setState(() => waterGlasses--);
                              }
                            },
                          ),
                          const SizedBox(width: 24),
                          Column(
                            children: [
                              Text(
                                '$waterGlasses',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                'glasses',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 24),
                          _buildControlButton(
                            icon: Icons.add,
                            onPressed: () {
                              setState(() => waterGlasses++);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: waterGlasses / 8,
                        backgroundColor: Colors.blue.shade100,
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${((waterGlasses / 8) * 100).toInt()}% of daily goal',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Sleep Card
                _buildTrackerCard(
                  title: 'Sleep',
                  subtitle: 'Rest well for you and baby',
                  icon: Icons.bedtime,
                  color: Colors.purple,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.bedtime,
                            color: Colors.purple,
                            size: 40,
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${sleepHours.toStringAsFixed(1)} hours',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                              Text(
                                sleepHours >= 7 ? 'Good sleep!' : 'Aim for 7+ hours',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.purple,
                          inactiveTrackColor: Colors.purple.shade100,
                          thumbColor: Colors.purple,
                          overlayColor: Colors.purple.withOpacity(0.2),
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 20,
                          ),
                          trackHeight: 8,
                        ),
                        child: Slider(
                          value: sleepHours,
                          min: 0,
                          max: 12,
                          divisions: 24,
                          label: '${sleepHours.toStringAsFixed(1)} hours',
                          onChanged: (value) {
                            setState(() => sleepHours = value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Baby Kicks Card
                _buildTrackerCard(
                  title: 'Baby Kicks',
                  subtitle: 'Track baby movements',
                  icon: Icons.favorite,
                  color: Colors.pink,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildControlButton(
                            icon: Icons.remove,
                            onPressed: () {
                              if (kicks > 0) {
                                setState(() => kicks--);
                              }
                            },
                          ),
                          const SizedBox(width: 32),
                          Column(
                            children: [
                              Text(
                                '$kicks',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pink,
                                ),
                              ),
                              Text(
                                'kicks',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.pink.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 32),
                          _buildControlButton(
                            icon: Icons.add,
                            onPressed: () {
                              setState(() => kicks++);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (kicks > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Baby is active!',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Symptoms Section - Clean text-only version
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Symptoms Today',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to select symptoms you\'re experiencing',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Clean text-only symptom pills
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: symptoms.map((symptom) {
                        final isSelected = selectedSymptoms.contains(symptom['name']);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                selectedSymptoms.remove(symptom['name']);
                              } else {
                                selectedSymptoms.add(symptom['name']);
                              }
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected 
                                ? symptom['color'] as Color
                                : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected 
                                  ? (symptom['color'] as Color).withOpacity(0.5)
                                  : Colors.grey.shade300,
                                width: 1,
                              ),
                              boxShadow: isSelected 
                                ? [
                                    BoxShadow(
                                      color: (symptom['color'] as Color).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : [],
                            ),
                            child: Text(
                              symptom['name'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Selected symptoms summary
                    if (selectedSymptoms.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade100),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${selectedSymptoms.length} symptom${selectedSymptoms.length > 1 ? 's' : ''} selected',
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 40),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Save Today\'s Data',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Stats Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        value: waterGlasses.toString(),
                        label: 'Water',
                        icon: Icons.water_drop,
                        color: Colors.blue,
                      ),
                      _buildStatItem(
                        value: sleepHours.toStringAsFixed(1),
                        label: 'Sleep',
                        icon: Icons.bedtime,
                        color: Colors.purple,
                      ),
                      _buildStatItem(
                        value: kicks.toString(),
                        label: 'Kicks',
                        icon: Icons.favorite,
                        color: Colors.pink,
                      ),
                      _buildStatItem(
                        value: selectedSymptoms.length.toString(),
                        label: 'Symptoms',
                        icon: Icons.health_and_safety,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTrackerCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textPrimary),
        onPressed: onPressed,
        splashRadius: 20,
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _saveData() {
    debugPrint('Water: $waterGlasses glasses');
    debugPrint('Sleep: $sleepHours hours');
    debugPrint('Kicks: $kicks kicks');
    debugPrint('Symptoms: $selectedSymptoms');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Daily data saved successfully!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}