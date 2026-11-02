class Rubrique {
  final String USBUSR;
  final String USBDOS;
  final String USBTRS;
  final String USBTRB;
  final double USBCOUL;
  final String USBRUB;
  final double? USBETAT;
  final String? USBROL;
  final double? USBREAD;
  final double? USBWRITE;
  final double? USBDEFAULT;

  Rubrique({
    required this.USBUSR,
    required this.USBDOS,
    required this.USBTRS,
    required this.USBTRB,
    required this.USBCOUL,
    required this.USBRUB,
    this.USBETAT,
    this.USBROL,
    this.USBREAD,
    this.USBWRITE,
    this.USBDEFAULT,
  });

  factory Rubrique.fromJson(Map<String, dynamic> json) {
    return Rubrique(
      USBUSR: json['USBUSR'] ?? '',
      USBDOS: json['USBDOS'] ?? '',
      USBTRS: json['USBTRS'] ?? '',
      USBTRB: json['USBTRB'] ?? '',
      USBCOUL: json['USBCOUL'].toDouble(),
      USBRUB: json['USBRUB'] ?? '',
      USBETAT: json['USBETAT']?.toDouble(),
      USBROL: json['USBROL'] ?? '',
      USBREAD: json['USBREAD']?.toDouble(),
      USBWRITE: json['USBWRITE']?.toDouble(),
      USBDEFAULT: json['USBDEFAULT']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'USBUSR': USBUSR,
      'USBDOS': USBDOS,
      'USBTRS': USBTRS,
      'USBTRB': USBTRB,
      'USBCOUL': USBCOUL,
      'USBRUB': USBRUB,
      'USBETAT': USBETAT,
      'USBROL': USBROL,
      'USBREAD': USBREAD,
      'USBWRITE': USBWRITE,
      'USBDEFAULT': USBDEFAULT,
    };
  }

  static List<Rubrique> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Rubrique.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Rubrique> list) {
    return list.map((rubrique) => rubrique.toJson()).toList();
  }
}
