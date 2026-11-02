class Statistic {
  double X;
  double Y;

  Statistic({
    required this.X,
    required this.Y,
  });

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      X: (json['X'] as num?)?.toDouble() ?? 0.0,
      Y: (json['Y'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'X': X,
      'Y': Y,
    };
  }

  static List<Statistic> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Statistic.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Statistic> list) {
    return list.map((statistic) => statistic.toJson()).toList();
  }
}
