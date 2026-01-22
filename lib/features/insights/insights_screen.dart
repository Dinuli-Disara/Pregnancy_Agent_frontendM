import 'package:flutter/material.dart';
import 'insights_service.dart';
import 'insights_model.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late Future<Insight> future;

  @override
  void initState() {
    super.initState();
    future = InsightsService().fetchInsights(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4FB),
      appBar: AppBar(
        title: const Text("AI Insights"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Insight>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Failed to load insights"));
          }

          final insight = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _summaryCard(insight.summary),
              const SizedBox(height: 16),
              _riskCard(insight),
              const SizedBox(height: 16),
              _trendCard(insight),
              const SizedBox(height: 16),
              _recommendationCard(insight.recommendations),
            ],
          );
        },
      ),
    );
  }

  // 🌸 SUMMARY
  Widget _summaryCard(String text) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9D50BB), Color(0xFF6E48AA)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Daily Health Summary",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 🚨 RISK
  Widget _riskCard(Insight i) {
    return _card(
      "Risk Assessment",
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statusChip("Dehydration", i.dehydration),
          _statusChip("Fatigue", i.fatigue),
        ],
      ),
    );
  }

  // 📊 TRENDS
  Widget _trendCard(Insight i) {
    return _card(
      "Health Trends",
      Column(
        children: [
          _trendRow(Icons.water_drop, "Hydration", i.hydrationTrend),
          _trendRow(Icons.bedtime, "Sleep", i.sleepTrend),
          _trendRow(Icons.favorite, "Baby Movement", i.babyMovementTrend),
        ],
      ),
    );
  }

  // 💡 AI RECOMMENDATIONS
  Widget _recommendationCard(List<String> recs) {
    return _card(
      "AI Recommendations",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: recs
            .map(
              (r) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: const [
                    Icon(Icons.check_circle, color: Colors.green, size: 18),
                    SizedBox(width: 8),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // 🧱 COMMON CARD
  Widget _card(String title, Widget child) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  // 🔘 CHIP
  Widget _statusChip(String label, String value) {
    Color color =
        value == "Low" ? Colors.green : value == "Medium" ? Colors.orange : Colors.red;

    return Column(
      children: [
        Text(label),
        const SizedBox(height: 4),
        Chip(
          label: Text(value),
          backgroundColor: color.withOpacity(0.15),
          labelStyle: TextStyle(color: color),
        ),
      ],
    );
  }

  // ➖ ROW
  Widget _trendRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
