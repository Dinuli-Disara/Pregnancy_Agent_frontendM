import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../shared/session/user_session.dart';
import '../insights/insights_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String fullName = "User";
  int week = 1;
  String trimester = "First Trimester";
  String babySize = "—";
  Future<Map<String, dynamic>>? insightFuture;

  @override
  void initState() {
    super.initState();

    // ✅ load user name from session
    final name = UserSession.fullName;
    if (name != null && name.trim().isNotEmpty) {
      fullName = name;
    }

    // ✅ load AI summary using real userId
    final userId = UserSession.userId;
    if (userId != null) {
      insightFuture = InsightsService().fetchInsights(userId);
      _loadWeekAndComputeUI(userId);
    }
  }

  // Reads week from insights response (which comes from DB pregnancy.current_week)
  Future<void> _loadWeekAndComputeUI(int userId) async {
    try {
      final data = await InsightsService().fetchInsights(userId);

      // your backend currently returns trends/risk/recommendations/summary only
      // we’ll infer week using a key IF you add it. For now, fallback week=16 (demo)
      // ✅ BEST: modify backend insights.py to return "week": pregnancy.current_week
      final serverWeek = data["week"];
      if (serverWeek != null) {
        week = int.tryParse(serverWeek.toString()) ?? week;
      } else {
        // fallback if week not returned by backend
        week = 16;
      }

      trimester = _getTrimester(week);
      babySize = _getBabySize(week);

      setState(() {});
    } catch (_) {}
  }

  String _getTrimester(int w) {
    if (w <= 12) return "First Trimester";
    if (w <= 27) return "Second Trimester";
    return "Third Trimester";
  }

  String _getBabySize(int w) {
    // Simple mapping (good enough for demo)
    if (w <= 8) return "Blueberry 🫐";
    if (w <= 12) return "Lime 🍋";
    if (w <= 16) return "Avocado 🥑";
    if (w <= 20) return "Banana 🍌";
    if (w <= 24) return "Corn 🌽";
    if (w <= 28) return "Eggplant 🍆";
    if (w <= 32) return "Coconut 🥥";
    if (w <= 36) return "Papaya 🍈";
    return "Watermelon 🍉";
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ✅ Welcome Section
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  radius: 25,
                  child: Icon(
                    Icons.pregnant_woman,
                    color: AppColors.primary,
                    size: 25,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ✅ Pregnancy Week Card (dynamic)
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      radius: 40,
                      child: const Icon(
                        Icons.favorite,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Week $week',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            trimester,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Baby size: $babySize',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ✅ Daily AI Summary from backend
            Text(
              "Daily AI Health Summary",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),

            FutureBuilder<Map<String, dynamic>>(
              future: insightFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text("Could not load AI summary"),
                    ),
                  );
                }

                final data = snapshot.data!;
                final summary = (data["summary"] ?? "No summary").toString();

                final recs = (data["recommendations"] is List)
                    ? (data["recommendations"] as List)
                    : [];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          summary,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (recs.isNotEmpty) ...[
                          Text(
                            "Recommendations",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...recs.take(3).map((r) => Text("• $r")).toList(),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),

            // ✅ Quick Actions removed completely ✅
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
