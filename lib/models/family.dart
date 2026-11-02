class Family {
  String FAMNO;
  String? FAMNOM;
  String? FAMTYPE;
  double FAMCACHE;
  double FAMSELECT;
  String? FAMCPTSTOCK;
  String? FAMCPTINTERM;
  String? FAMCPTCHARGE;

  Family({
    required this.FAMNO,
    this.FAMNOM,
    this.FAMTYPE,
    required this.FAMCACHE,
    required this.FAMSELECT,
    this.FAMCPTSTOCK,
    this.FAMCPTINTERM,
    this.FAMCPTCHARGE,
  });

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
      FAMNO: json['FAMNO'] ?? '',
      FAMNOM: json['FAMNOM'] ?? '',
      FAMTYPE: json['FAMTYPE'] ?? '',
      FAMCACHE: (json['FAMCACHE'] as num).toDouble() ?? 0.0,
      FAMSELECT: (json['FAMSELECT'] as num).toDouble() ?? 0.0,
      FAMCPTSTOCK: json['FAMCPTSTOCK'] ?? '',
      FAMCPTINTERM: json['FAMCPTINTERM'] ?? '',
      FAMCPTCHARGE: json['FAMCPTCHARGE'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FAMNO': FAMNO,
      'FAMNOM': FAMNOM,
      'FAMTYPE': FAMTYPE,
      'FAMCACHE': FAMCACHE,
      'FAMSELECT': FAMSELECT,
      'FAMCPTSTOCK': FAMCPTSTOCK,
      'FAMCPTINTERM': FAMCPTINTERM,
      'FAMCPTCHARGE': FAMCPTCHARGE,
    };
  }

  static List<Family> listFromJson(List<dynamic> json) {
    return json.map((e) => Family.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Family> list) {
    return list.map((e) => e.toJson()).toList();
  }
}
