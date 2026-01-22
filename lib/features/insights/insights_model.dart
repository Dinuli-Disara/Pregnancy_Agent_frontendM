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
      dehydration: json['risk']?['dehydration'] ?? 'Low',
      fatigue: json['risk']?['fatigue'] ?? 'Low',
      hydrationTrend: json['trends']?['hydration'] ?? 'Stable',
      sleepTrend: json['trends']?['sleep'] ?? 'Stable',
      babyMovementTrend: json['trends']?['baby_movement'] ?? 'Stable',
      recommendations:
          (json['recommendations'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [],
    );
  }
}
