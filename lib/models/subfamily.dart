class SubFamily {
  String SOUFAM;
  String SOUNO;
  String? SOUNOM;

  SubFamily({
    required this.SOUFAM,
    required this.SOUNO,
    this.SOUNOM,
  });

  factory SubFamily.fromJson(Map<String, dynamic> json) {
    return SubFamily(
      SOUFAM: json['SOUFAM'] ?? '',
      SOUNO: json['SOUNO'] ?? '',
      SOUNOM: json['SOUNOM'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SOUFAM': SOUFAM,
      'SOUNO': SOUNO,
      'SOUNOM': SOUNOM,
    };
  }

  static List<SubFamily> listFromJson(List<dynamic> json) {
    return json.map((e) => SubFamily.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<SubFamily> list) {
    return list.map((e) => e.toJson()).toList();
  }
}
