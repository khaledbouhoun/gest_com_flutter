class Package {
  String COLNO;
  String? COLNOM;
  String? COLABV;

  Package({
    required this.COLNO,
    this.COLNOM,
    this.COLABV,
  });

  factory Package.fromJson(Map<String, dynamic> json) {
    return Package(
      COLNO: json['COLNO'] ?? '',
      COLNOM: json['COLNOM'] ?? '',
      COLABV: json['COLABV'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'COLNO': COLNO,
      'COLNOM': COLNOM,
      'COLABV': COLABV,
    };
  }

  static List<Package> listFromJson(List<dynamic> json) {
    return json.map((e) => Package.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Package> list) {
    return list.map((e) => e.toJson()).toList();
  }
}
