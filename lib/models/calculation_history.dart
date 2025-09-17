class CalculationHistory {
  final String expression;
  final String result;
  final DateTime timestamp;

  CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory CalculationHistory.fromJson(Map<String, dynamic> json) {
    return CalculationHistory(
      expression: json['expression'],
      result: json['result'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  String get formattedTime {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
