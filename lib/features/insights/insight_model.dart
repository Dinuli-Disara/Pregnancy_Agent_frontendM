class Insight {
  final String summary;
  final String dehydration;
  final String fatigue;
  final String hydrationTrend;
  final String sleepTrend;
  final String babyMovementTrend;
  final List<String> recommendations;

  Insight({
    required this.summary,
    required this.dehydration,
    required this.fatigue,
    required this.hydrationTrend,
    required this.sleepTrend,
    required this.babyMovementTrend,
    required this.recommendations,
  });

  factory Insight.fromJson(Map<String, dynamic> json) {
    return Insight(
      summary: json['summary'] ?? 'No summary available',
      dehydration: json['dehydration'] ?? 'Low',
      fatigue: json['fatigue'] ?? 'Low',
      hydrationTrend: json['hydration_trend'] ?? 'Stable',
      sleepTrend: json['sleep_trend'] ?? 'Stable',
      babyMovementTrend: json['baby_movement_trend'] ?? 'Stable',
      recommendations:
          (json['recommendations'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
    );
  }
}
