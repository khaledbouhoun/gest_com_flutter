class Nature {
  String? NATNO;
  String? NATNOM;
  String? NATABV;
  double? NATGENRE;

  Nature({this.NATNO, this.NATNOM, this.NATABV, this.NATGENRE});

  factory Nature.fromJson(Map<String, dynamic> json) {
    return Nature(
      NATNO: json['NATNO'] ?? '',
      NATNOM: json['NATNOM'] ?? '',
      NATABV: json['NATABV'] ?? '',
      NATGENRE: (json['NATGENRE'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NATNO': NATNO,
      'NATNOM': NATNOM,
      'NATABV': NATABV,
      'NATGENRE': NATGENRE,
    };
  }

  static List<Nature> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Nature.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Nature> list) {
    return list.map((nature) => nature.toJson()).toList();
  }
}
