class Access {
  String URSUSR;
  String URSTRS;
  String URSRES;
  String URSDRO;
  double URSCOUL;
  String URSDOS;
  String? URSROL;

  Access({
    required this.URSUSR,
    required this.URSTRS,
    required this.URSRES,
    required this.URSDRO,
    required this.URSCOUL,
    required this.URSDOS,
    this.URSROL,
  });

  factory Access.fromJson(Map<String, dynamic> json) {
    return Access(
      URSUSR: json['URSUSR'] ?? '',
      URSTRS: json['URSTRS'] ?? '',
      URSRES: json['URSRES'] ?? '',
      URSDRO: json['URSDRO'] ?? '',
      URSCOUL: (json['URSCOUL'] as num?)?.toDouble() ?? 0.0,
      URSDOS: json['URSDOS'] ?? '',
      URSROL: json['URSROL'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'URSUSR': URSUSR,
      'URSTRS': URSTRS,
      'URSRES': URSRES,
      'URSDRO': URSDRO,
      'URSCOUL': URSCOUL,
      'URSDOS': URSDOS,
      'URSROL': URSROL,
    };
  }

  static List<Access> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Access.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Access> accessList) {
    return accessList.map((access) => access.toJson()).toList();
  }
}
