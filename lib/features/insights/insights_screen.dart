import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'insight_service.dart';
import 'insight_model.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late Future<Insight> _insightFuture;

  @override
  void initState() {
    super.initState();
    _insightFuture = InsightService.fetchInsights(1); // TEMP userId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Insights'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Insight>(
        future: _insightFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading insights'));
          }

          final insight = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// 🔹 Daily AI Summary
                _InsightCard(
                  title: 'Daily Health Summary',
                  icon: Icons.psychology,
                  color: AppColors.primary,
                  child: Text(
                    insight.summary,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 Risk Assessment
                _InsightCard(
                  title: 'Risk Assessment',
                  icon: Icons.warning_amber,
                  color: Colors.orange,
                  child: Row(
                    children: [
                      _RiskChip(
                        label: 'Dehydration',
                        level: insight.dehydration,
                      ),
                      const SizedBox(width: 10),
                      _RiskChip(
                        label: 'Fatigue',
                        level: insight.fatigue,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 Health Trends
                _InsightCard(
                  title: 'Health Trends',
                  icon: Icons.show_chart,
                  color: Colors.teal,
                  child: Column(
                    children: [
                      _TrendRow(
                        title: 'Hydration',
                        value: insight.hydrationTrend,
                      ),
                      _TrendRow(
                        title: 'Sleep',
                        value: insight.sleepTrend,
                      ),
                      _TrendRow(
                        title: 'Baby Movement',
                        value: insight.babyMovementTrend,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// 🔹 AI Recommendations
                _InsightCard(
                  title: 'AI Recommendations',
                  icon: Icons.lightbulb,
                  color: Colors.green,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: insight.recommendations
                        .map(
                          (r) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text('• $r'),
                          ),
                        )
                        .toList(),
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔹 Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.chat),
                        label: const Text('Ask AI'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // TODO: Navigate to AI Chat
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.history),
                        label: const Text('View History'),
                        style: OutlinedButton.styleFrom(
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          // TODO: Navigate to history
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// 🔸 Reusable Widgets (UNCHANGED)
///////////////////////////////////////////////////////////

class _InsightCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _InsightCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _RiskChip extends StatelessWidget {
  final String label;
  final String level;

  const _RiskChip({required this.label, required this.level});

  @override
  Widget build(BuildContext context) {
    Color color = level == 'High'
        ? Colors.red
        : level == 'Medium'
            ? Colors.orange
            : Colors.green;

    return Chip(
      label: Text('$label: $level'),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color),
    );
  }
}

class _TrendRow extends StatelessWidget {
  final String title;
  final String value;

  const _TrendRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
