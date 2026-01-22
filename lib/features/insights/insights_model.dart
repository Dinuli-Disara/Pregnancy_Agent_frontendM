class InsightData {
  final String dailySummary;
  final String dehydrationRisk;
  final String fatigueRisk;

  final String hydrationTrend;
  final String sleepTrend;
  final String babyMovementTrend;

  final List<String> aiRecommendations;

  InsightData({
    required this.dailySummary,
    required this.dehydrationRisk,
    required this.fatigueRisk,
    required this.hydrationTrend,
    required this.sleepTrend,
    required this.babyMovementTrend,
    required this.aiRecommendations,
  });
}
