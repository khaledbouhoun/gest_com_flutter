class Brand {
  String? MRQNOM;
  String MRQNO;

  Brand({
    this.MRQNOM,
    required this.MRQNO,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      MRQNOM: json['MRQNOM'] ?? '',
      MRQNO: json['MRQNO'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MRQNOM': MRQNOM,
      'MRQNO': MRQNO,
    };
  }

  static List<Brand> listFromJson(List<dynamic> json) {
    return json.map((e) => Brand.fromJson(e)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Brand> list) {
    return list.map((e) => e.toJson()).toList();
  }
}
