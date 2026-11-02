class FactureDetail {
  DateTime? FTDDATE;
  String FTDART;
  double FTDORD;
  double FTDQTE;
  double FTDPU;
  String FTDCTVA;
  double FTDTVA;
  double FTDTREM;
  double FTDREMISE;
  double FTDMNTTTC;
  double FTDREMGLOB;
  double FTDANNULER;
  double FTDLONG;
  double FTDLARG;
  double FTDCOMPAR;
  double FTDBASE;
  double FTDMARGE;
  String FTDCOLISAGE;
  double FTDCOLIS;
  double FTDUNTCOL;
  double FTDPUTTC;
  double FTDIMPRIMER;
  DateTime? FTDCDEDATE;
  String FTDCDENO;
  double FTDBASEG;
  String FTDDEPOT;
  double FTDTYPEREM;
  String FTDARTNOM;
  double FTDCOUTU;
  double FTDCOUTG;
  String FTDQTEEXPR;
  double FTDTRI;
  String FTDNO;
  double FTDQTEG;
  double FTDCDEORD;

  FactureDetail({
    this.FTDDATE,
    this.FTDART = '',
    this.FTDORD = 0.0,
    this.FTDQTE = 0.0,
    this.FTDPU = 0.0,
    this.FTDCTVA = '',
    this.FTDTVA = 0.0,
    this.FTDTREM = 0.0,
    this.FTDREMISE = 0.0,
    this.FTDMNTTTC = 0.0,
    this.FTDREMGLOB = 0.0,
    this.FTDANNULER = 0.0,
    this.FTDLONG = 0.0,
    this.FTDLARG = 0.0,
    this.FTDCOMPAR = 0.0,
    this.FTDBASE = 0.0,
    this.FTDMARGE = 0.0,
    this.FTDCOLISAGE = '',
    this.FTDCOLIS = 0.0,
    this.FTDUNTCOL = 0.0,
    this.FTDPUTTC = 0.0,
    this.FTDIMPRIMER = 0.0,
    this.FTDCDEDATE,
    this.FTDCDENO = '',
    this.FTDBASEG = 0.0,
    this.FTDDEPOT = '',
    this.FTDTYPEREM = 0.0,
    this.FTDARTNOM = '',
    this.FTDCOUTU = 0.0,
    this.FTDCOUTG = 0.0,
    this.FTDQTEEXPR = '',
    this.FTDTRI = 0.0,
    this.FTDNO = '',
    this.FTDQTEG = 0.0,
    this.FTDCDEORD = 0.0,
  });

  factory FactureDetail.fromJson(Map<String, dynamic> json) {
    return FactureDetail(
      FTDDATE: json['FTDDATE'] != null ? DateTime.parse(json['FTDDATE']) : null,
      FTDART: json['FTDART'] ?? '',
      FTDORD: json['FTDORD'] != null ? json['FTDORD'].toDouble() : 0.0,
      FTDQTE: json['FTDQTE'] != null ? json['FTDQTE'].toDouble() : 0.0,
      FTDPU: json['FTDPU'] != null ? json['FTDPU'].toDouble() : 0.0,
      FTDCTVA: json['FTDCTVA'] ?? '',
      FTDTVA: json['FTDTVA'] != null ? json['FTDTVA'].toDouble() : 0.0,
      FTDTREM: json['FTDTREM'] != null ? json['FTDTREM'].toDouble() : 0.0,
      FTDREMISE: json['FTDREMISE'] != null ? json['FTDREMISE'].toDouble() : 0.0,
      FTDMNTTTC: json['FTDMNTTTC'] != null ? json['FTDMNTTTC'].toDouble() : 0.0,
      FTDREMGLOB: json['FTDREMGLOB'] != null ? json['FTDREMGLOB'].toDouble() : 0.0,
      FTDANNULER: json['FTDANNULER'] != null ? json['FTDANNULER'].toDouble() : 0.0,
      FTDLONG: json['FTDLONG'] != null ? json['FTDLONG'].toDouble() : 0.0,
      FTDLARG: json['FTDLARG'] != null ? json['FTDLARG'].toDouble() : 0.0,
      FTDCOMPAR: json['FTDCOMPAR'] != null ? json['FTDCOMPAR'].toDouble() : 0.0,
      FTDBASE: json['FTDBASE'] != null ? json['FTDBASE'].toDouble() : 0.0,
      FTDMARGE: json['FTDMARGE'] != null ? json['FTDMARGE'].toDouble() : 0.0,
      FTDCOLISAGE: json['FTDCOLISAGE'] ?? '',
      FTDCOLIS: json['FTDCOLIS'] != null ? json['FTDCOLIS'].toDouble() : 0.0,
      FTDUNTCOL: json['FTDUNTCOL'] != null ? json['FTDUNTCOL'].toDouble() : 0.0,
      FTDPUTTC: json['FTDPUTTC'] != null ? json['FTDPUTTC'].toDouble() : 0.0,
      FTDIMPRIMER: json['FTDIMPRIMER'] != null ? json['FTDIMPRIMER'].toDouble() : 0.0,
      FTDCDEDATE: json['FTDCDEDATE'] != null ? DateTime.parse(json['FTDCDEDATE']) : null,
      FTDCDENO: json['FTDCDENO'] ?? '',
      FTDBASEG: json['FTDBASEG'] != null ? json['FTDBASEG'].toDouble() : 0.0,
      FTDDEPOT: json['FTDDEPOT'] ?? '',
      FTDTYPEREM: json['FTDTYPEREM'] != null ? json['FTDTYPEREM'].toDouble() : 0.0,
      FTDARTNOM: json['FTDARTNOM'] ?? '',
      FTDCOUTU: json['FTDCOUTU'] != null ? json['FTDCOUTU'].toDouble() : 0.0,
      FTDCOUTG: json['FTDCOUTG'] != null ? json['FTDCOUTG'].toDouble() : 0.0,
      FTDQTEEXPR: json['FTDQTEEXPR'] ?? '',
      FTDTRI: json['FTDTRI'] != null ? json['FTDTRI'].toDouble() : 0.0,
      FTDNO: json['FTDNO'] ?? '',
      FTDQTEG: json['FTDQTEG'] != null ? json['FTDQTEG'].toDouble() : 0.0,
      FTDCDEORD: json['FTDCDEORD'] != null ? json['FTDCDEORD'].toDouble() : 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'FTDDATE': FTDDATE?.toIso8601String(),
      'FTDART': FTDART,
      'FTDORD': FTDORD,
      'FTDQTE': FTDQTE,
      'FTDPU': FTDPU,
      'FTDCTVA': FTDCTVA,
      'FTDTVA': FTDTVA,
      'FTDTREM': FTDTREM,
      'FTDREMISE': FTDREMISE,
      'FTDMNTTTC': FTDMNTTTC,
      'FTDREMGLOB': FTDREMGLOB,
      'FTDANNULER': FTDANNULER,
      'FTDLONG': FTDLONG,
      'FTDLARG': FTDLARG,
      'FTDCOMPAR': FTDCOMPAR,
      'FTDBASE': FTDBASE,
      'FTDMARGE': FTDMARGE,
      'FTDCOLISAGE': FTDCOLISAGE,
      'FTDCOLIS': FTDCOLIS,
      'FTDUNTCOL': FTDUNTCOL,
      'FTDPUTTC': FTDPUTTC,
      'FTDIMPRIMER': FTDIMPRIMER,
      'FTDCDEDATE': FTDCDEDATE?.toIso8601String(),
      'FTDCDENO': FTDCDENO,
      'FTDBASEG': FTDBASEG,
      'FTDDEPOT': FTDDEPOT,
      'FTDTYPEREM': FTDTYPEREM,
      'FTDARTNOM': FTDARTNOM,
      'FTDCOUTU': FTDCOUTU,
      'FTDCOUTG': FTDCOUTG,
      'FTDQTEEXPR': FTDQTEEXPR,
      'FTDTRI': FTDTRI,
      'FTDNO': FTDNO,
      'FTDQTEG': FTDQTEG,
      'FTDCDEORD': FTDCDEORD,
    };
  }

  static List<FactureDetail> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => FactureDetail.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<FactureDetail> list) {
    return list.map((facturedetail) => facturedetail.toJson()).toList();
  }
}
