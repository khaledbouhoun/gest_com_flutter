class Unit {
  String UNINO;
  String? UNIABV;
  String? UNINOM;

  Unit({
    required this.UNINO,
    this.UNIABV,
    this.UNINOM,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      UNINO: json['UNINO'] ?? '',
      UNIABV: json['UNIABV'] ?? '',
      UNINOM: json['UNINOM'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UNINO': UNINO,
      'UNIABV': UNIABV,
      'UNINOM': UNINOM,
    };
  }

  static List<Unit> listFromJson(List<dynamic> json) {
    return json.map((e) => Unit.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Unit> list) {
    return list.map((e) => e.toJson()).toList();
  }
}
