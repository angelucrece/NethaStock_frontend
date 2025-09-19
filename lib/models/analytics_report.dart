class AnalyticsReport {
  final Map<String, dynamic> stockOverview;
  final Map<String, dynamic> movementSummary;
  final List<Map<String, dynamic>> topProducts;
  final List<Map<String, dynamic>> userActivity;
  final List<Map<String, dynamic>> dailyEvolution;
  final String generatedAt;
  final String generatedBy;
  final int period;

  AnalyticsReport({
    required this.stockOverview,
    required this.movementSummary,
    required this.topProducts,
    required this.userActivity,
    required this.dailyEvolution,
    required this.generatedAt,
    required this.generatedBy,
    required this.period,
  });

  factory AnalyticsReport.fromJson(Map<String, dynamic> json) {
    return AnalyticsReport(
      stockOverview: Map<String, dynamic>.from(json['stockOverview'] ?? {}),
      movementSummary: Map<String, dynamic>.from(json['movementSummary'] ?? {}),
      topProducts: List<Map<String, dynamic>>.from(json['topProducts'] ?? []),
      userActivity: List<Map<String, dynamic>>.from(json['userActivity'] ?? []),
      dailyEvolution: List<Map<String, dynamic>>.from(json['dailyEvolution'] ?? []),
      generatedAt: json['generatedAt'] ?? '',
      generatedBy: json['generatedBy'] ?? '',
      period: json['period'] ?? 30,
    );
  }
}
