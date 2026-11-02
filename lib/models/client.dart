class Client {
  String CLINO;
  String? CLICATEG;
  String? CLINATURE;
  int CLIAM;
  int CLIPERIODIQUE;
  DateTime? CLIFINACTIVITE;
  int CLITYPE;
  String CLIPRENOM;
  DateTime CLIDATENSC;
  int CLISEXE;
  String? CLINAT;
  String CLIADR1;
  String CLIADR2;
  String CLIADR3;
  String CLIADR4;
  String? CLIPAYS;
  String? CLITERR;
  String CLITEL1;
  String CLITEL2;
  String CLIFAX;
  String CLIEMAIL;
  String CLIWEB;
  String CLIBANQUE;
  String CLIAGENCE;
  String CLICOMPTE;
  String CLIIF;
  String CLIAI;
  String CLINIS;
  int CLIEXONERE;
  double CLIREMISE;
  int CLIREMAUTO;
  double CLIENCMAX;
  double CLISOLDE;
  double CLISLDINIT;
  double CLIREGL;
  double CLISOLDEAB;
  double CLISLDINITAB;
  double CLIREGLAB;
  String? CLINOTES;
  String CLITARIF;
  String CLIPCPT;
  int CLIACTIF;
  int CLICACHE;
  int CLIPEUTPAYER;
  int CLIVEUTPAYER;
  String CLINOBOITE;
  int CLIFOU;
  String CLIFOUNO;
  String? CLIREGION;
  String CLINOM;
  int CLINEW;
  String CLIBANQUE2;
  String CLIAGENCE2;
  String CLICOMPTE2;
  String CLIBANQUE3;
  String CLIAGENCE3;
  String CLICOMPTE3;
  String CLIRC;
  int CLIAUTPAYECHQ;
  int CLIREMARTGLOB;
  String CLIACTIVITE;
  String? CLIVILLE;
  String CLITRANSPORTEUR;
  String CLITARIFAB;
  DateTime CLIDHCRE;
  String CLICREPAR;
  DateTime CLIDHMOD;
  String CLIMODPAR;
  String CLICATEGCOULEUR;
  String CLICOMMERCIAL;
  double CLIREMISE2;
  int CLIREMAUTO2;
  int CLIREMARTGLOB2;
  int CLIAUTSORTORG;
  String CLINOMFACT;
  String CLILOCALISATION;

  Client({
    this.CLINO = '',
    this.CLICATEG,
    this.CLINATURE,
    this.CLIAM = 0,
    this.CLIPERIODIQUE = 0,
    this.CLIFINACTIVITE,
    this.CLITYPE = 0,
    this.CLIPRENOM = '',
    DateTime? CLIDATENSC,
    this.CLISEXE = 0,
    this.CLINAT = '',
    this.CLIADR1 = '',
    this.CLIADR2 = '',
    this.CLIADR3 = '',
    this.CLIADR4 = '',
    this.CLIPAYS,
    this.CLITERR,
    this.CLITEL1 = '',
    this.CLITEL2 = '',
    this.CLIFAX = '',
    this.CLIEMAIL = '',
    this.CLIWEB = '',
    this.CLIBANQUE = '',
    this.CLIAGENCE = '',
    this.CLICOMPTE = '',
    this.CLIIF = '',
    this.CLIAI = '',
    this.CLINIS = '',
    this.CLIEXONERE = 0,
    this.CLIREMISE = 0.0,
    this.CLIREMAUTO = 0,
    this.CLIENCMAX = 0.0,
    this.CLISOLDE = 0.0,
    this.CLISLDINIT = 0.0,
    this.CLIREGL = 0.0,
    this.CLISOLDEAB = 0.0,
    this.CLISLDINITAB = 0.0,
    this.CLIREGLAB = 0.0,
    this.CLINOTES,
    this.CLITARIF = '',
    this.CLIPCPT = '',
    this.CLIACTIF = 0,
    this.CLICACHE = 0,
    this.CLIPEUTPAYER = 0,
    this.CLIVEUTPAYER = 0,
    this.CLINOBOITE = '',
    this.CLIFOU = 0,
    this.CLIFOUNO = '',
    this.CLIREGION,
    this.CLINOM = '',
    this.CLINEW = 0,
    this.CLIBANQUE2 = '',
    this.CLIAGENCE2 = '',
    this.CLICOMPTE2 = '',
    this.CLIBANQUE3 = '',
    this.CLIAGENCE3 = '',
    this.CLICOMPTE3 = '',
    this.CLIRC = '',
    this.CLIAUTPAYECHQ = 0,
    this.CLIREMARTGLOB = 0,
    this.CLIACTIVITE = '',
    this.CLIVILLE,
    this.CLITRANSPORTEUR = '',
    this.CLITARIFAB = '',
    DateTime? CLIDHCRE,
    this.CLICREPAR = '',
    DateTime? CLIDHMOD,
    this.CLIMODPAR = '',
    this.CLICATEGCOULEUR = '',
    this.CLICOMMERCIAL = '',
    this.CLIREMISE2 = 0.0,
    this.CLIREMAUTO2 = 0,
    this.CLIREMARTGLOB2 = 0,
    this.CLIAUTSORTORG = 0,
    this.CLINOMFACT = '',
    this.CLILOCALISATION = '',
  })  : CLIDATENSC = CLIDATENSC ?? DateTime.now(),
        CLIDHCRE = CLIDHCRE ?? DateTime.now(),
        CLIDHMOD = CLIDHMOD ?? DateTime.now();

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      CLINO: json['CLINO'] ?? '',
      CLICATEG: json['CLICATEG'] ?? '00', // Defaulting to '00' for categories
      CLINATURE: json['CLINATURE'] ?? '00',
      CLIAM: json['CLIAM'] ?? 0,
      CLIPERIODIQUE: json['CLIPERIODIQUE'] ?? 0,
      CLIFINACTIVITE: json['CLIFINACTIVITE'] != null ? DateTime.parse(json['CLIFINACTIVITE']) : null,
      CLITYPE: json['CLITYPE'] ?? 0,
      CLIPRENOM: json['CLIPRENOM'] ?? '',
      CLIDATENSC: json['CLIDATENSC'] != null ? DateTime.parse(json['CLIDATENSC']) : DateTime.now(),
      CLISEXE: json['CLISEXE'] ?? 0,
      CLINAT: json['CLINAT'] ?? '',
      CLIADR1: json['CLIADR1'] ?? '',
      CLIADR2: json['CLIADR2'] ?? '',
      CLIADR3: json['CLIADR3'] ?? '',
      CLIADR4: json['CLIADR4'] ?? '',
      CLIPAYS: json['CLIPAYS'] ?? '',
      CLITERR: json['CLITERR'] ?? '',
      CLITEL1: json['CLITEL1'] ?? '',
      CLITEL2: json['CLITEL2'] ?? '',
      CLIFAX: json['CLIFAX'] ?? '',
      CLIEMAIL: json['CLIEMAIL'] ?? '',
      CLIWEB: json['CLIWEB'] ?? '',
      CLIBANQUE: json['CLIBANQUE'] ?? '',
      CLIAGENCE: json['CLIAGENCE'] ?? '',
      CLICOMPTE: json['CLICOMPTE'] ?? '',
      CLIIF: json['CLIIF'] ?? '',
      CLIAI: json['CLIAI'] ?? '',
      CLINIS: json['CLINIS'] ?? '',
      CLIEXONERE: json['CLIEXONERE'] ?? 0,
      CLIREMISE: (json['CLIREMISE'] ?? 0).toDouble(),
      CLIREMAUTO: json['CLIREMAUTO'] ?? 0,
      CLIENCMAX: (json['CLIENCMAX'] ?? 0).toDouble(),
      CLISOLDE: (json['CLISOLDE'] ?? 0).toDouble(),
      CLISLDINIT: (json['CLISLDINIT'] ?? 0).toDouble(),
      CLIREGL: (json['CLIREGL'] ?? 0).toDouble(),
      CLISOLDEAB: (json['CLISOLDEAB'] ?? 0).toDouble(),
      CLISLDINITAB: (json['CLISLDINITAB'] ?? 0).toDouble(),
      CLIREGLAB: (json['CLIREGLAB'] ?? 0).toDouble(),
      CLINOTES: json['CLINOTES'] ?? '', // Defaulting to an empty string
      CLITARIF: json['CLITARIF'] ?? '',
      CLIPCPT: json['CLIPCPT'] ?? '',
      CLIACTIF: json['CLIACTIF'] ?? 0,
      CLICACHE: json['CLICACHE'] ?? 0,
      CLIPEUTPAYER: json['CLIPEUTPAYER'] ?? 0,
      CLIVEUTPAYER: json['CLIVEUTPAYER'] ?? 0,
      CLINOBOITE: json['CLINOBOITE'] ?? '',
      CLIFOU: json['CLIFOU'] ?? 0,
      CLIFOUNO: json['CLIFOUNO'] ?? '',
      CLIREGION: json['CLIREGION'] ?? '',
      CLINOM: json['CLINOM'] ?? '',
      CLINEW: json['CLINEW'] ?? 0,
      CLIBANQUE2: json['CLIBANQUE2'] ?? '',
      CLIAGENCE2: json['CLIAGENCE2'] ?? '',
      CLICOMPTE2: json['CLICOMPTE2'] ?? '',
      CLIBANQUE3: json['CLIBANQUE3'] ?? '',
      CLIAGENCE3: json['CLIAGENCE3'] ?? '',
      CLICOMPTE3: json['CLICOMPTE3'] ?? '',
      CLIRC: json['CLIRC'] ?? '',
      CLIAUTPAYECHQ: json['CLIAUTPAYECHQ'] ?? 0,
      CLIREMARTGLOB: json['CLIREMARTGLOB'] ?? 0,
      CLIACTIVITE: json['CLIACTIVITE'] ?? '',
      CLIVILLE: json['CLIVILLE'] ?? '',
      CLITRANSPORTEUR: json['CLITRANSPORTEUR'] ?? '',
      CLITARIFAB: json['CLITARIFAB'] ?? '',
      CLIDHCRE: json['CLIDHCRE'] != null ? DateTime.parse(json['CLIDHCRE']) : DateTime.now(),
      CLICREPAR: json['CLICREPAR'] ?? '',
      CLIDHMOD: json['CLIDHMOD'] != null ? DateTime.parse(json['CLIDHMOD']) : DateTime.now(),
      CLIMODPAR: json['CLIMODPAR'] ?? '',
      CLICATEGCOULEUR: json['CLICATEGCOULEUR'] ?? '',
      CLICOMMERCIAL: json['CLICOMMERCIAL'] ?? '',
      CLIREMISE2: (json['CLIREMISE2'] ?? 0).toDouble(),
      CLIREMAUTO2: json['CLIREMAUTO2'] ?? 0,
      CLIREMARTGLOB2: json['CLIREMARTGLOB2'] ?? 0,
      CLIAUTSORTORG: json['CLIAUTSORTORG'] ?? 0,
      CLINOMFACT: json['CLINOMFACT'] ?? '',
      CLILOCALISATION: json['CLILOCALISATION'] ?? '',
    );
  }

  static Client modified(Map<String, dynamic> json) {
    return Client(
      CLINO: json['CLINO'] ?? '',
      CLICATEG: json['CLICATEG'] ?? '00', // Defaulting to '00' for categories
      CLINATURE: json['CLINATURE'] ?? '00',
      CLIAM: json['CLIAM'] ?? 0,
      CLIPERIODIQUE: json['CLIPERIODIQUE'] ?? 0,
      CLIFINACTIVITE: json['CLIFINACTIVITE'] != null ? DateTime.parse(json['CLIFINACTIVITE']) : null,
      CLITYPE: json['CLITYPE'] ?? 0,
      CLIPRENOM: json['CLIPRENOM'] ?? '',
      CLIDATENSC: json['CLIDATENSC'] != null ? DateTime.parse(json['CLIDATENSC']) : DateTime.now(),
      CLISEXE: json['CLISEXE'] ?? 0,
      CLINAT: json['CLINAT'] ?? '',
      CLIADR1: json['CLIADR1'] ?? '',
      CLIADR2: json['CLIADR2'] ?? '',
      CLIADR3: json['CLIADR3'] ?? '',
      CLIADR4: json['CLIADR4'] ?? '',
      CLIPAYS: json['CLIPAYS'] ?? '',
      CLITERR: json['CLITERR'] ?? '',
      CLITEL1: json['CLITEL1'] ?? '',
      CLITEL2: json['CLITEL2'] ?? '',
      CLIFAX: json['CLIFAX'] ?? '',
      CLIEMAIL: json['CLIEMAIL'] ?? '',
      CLIWEB: json['CLIWEB'] ?? '',
      CLIBANQUE: json['CLIBANQUE'] ?? '',
      CLIAGENCE: json['CLIAGENCE'] ?? '',
      CLICOMPTE: json['CLICOMPTE'] ?? '',
      CLIIF: json['CLIIF'] ?? '',
      CLIAI: json['CLIAI'] ?? '',
      CLINIS: json['CLINIS'] ?? '',
      CLIEXONERE: json['CLIEXONERE'] ?? 0,
      CLIREMISE: (json['CLIREMISE'] ?? 0).toDouble(),
      CLIREMAUTO: json['CLIREMAUTO'] ?? 0,
      CLIENCMAX: (json['CLIENCMAX'] ?? 0).toDouble(),
      CLISOLDE: (json['CLISOLDE'] ?? 0).toDouble(),
      CLISLDINIT: (json['CLISLDINIT'] ?? 0).toDouble(),
      CLIREGL: (json['CLIREGL'] ?? 0).toDouble(),
      CLISOLDEAB: (json['CLISOLDEAB'] ?? 0).toDouble(),
      CLISLDINITAB: (json['CLISLDINITAB'] ?? 0).toDouble(),
      CLIREGLAB: (json['CLIREGLAB'] ?? 0).toDouble(),
      CLINOTES: json['CLINOTES'] ?? '', // Defaulting to an empty string
      CLITARIF: json['CLITARIF'] ?? '',
      CLIPCPT: json['CLIPCPT'] ?? '',
      CLIACTIF: json['CLIACTIF'] ?? 0,
      CLICACHE: json['CLICACHE'] ?? 0,
      CLIPEUTPAYER: json['CLIPEUTPAYER'] ?? 0,
      CLIVEUTPAYER: json['CLIVEUTPAYER'] ?? 0,
      CLINOBOITE: json['CLINOBOITE'] ?? '',
      CLIFOU: json['CLIFOU'] ?? 0,
      CLIFOUNO: json['CLIFOUNO'] ?? '',
      CLIREGION: json['CLIREGION'] ?? '',
      CLINOM: json['CLINOM'] ?? '',
      CLINEW: json['CLINEW'] ?? 0,
      CLIBANQUE2: json['CLIBANQUE2'] ?? '',
      CLIAGENCE2: json['CLIAGENCE2'] ?? '',
      CLICOMPTE2: json['CLICOMPTE2'] ?? '',
      CLIBANQUE3: json['CLIBANQUE3'] ?? '',
      CLIAGENCE3: json['CLIAGENCE3'] ?? '',
      CLICOMPTE3: json['CLICOMPTE3'] ?? '',
      CLIRC: json['CLIRC'] ?? '',
      CLIAUTPAYECHQ: json['CLIAUTPAYECHQ'] ?? 0,
      CLIREMARTGLOB: json['CLIREMARTGLOB'] ?? 0,
      CLIACTIVITE: json['CLIACTIVITE'] ?? '',
      CLIVILLE: json['CLIVILLE'] ?? '',
      CLITRANSPORTEUR: json['CLITRANSPORTEUR'] ?? '',
      CLITARIFAB: json['CLITARIFAB'] ?? '',
      CLIDHCRE: json['CLIDHCRE'] != null ? DateTime.parse(json['CLIDHCRE']) : DateTime.now(),
      CLICREPAR: json['CLICREPAR'] ?? '',
      CLIDHMOD: json['CLIDHMOD'] != null ? DateTime.parse(json['CLIDHMOD']) : DateTime.now(),
      CLIMODPAR: json['CLIMODPAR'] ?? '',
      CLICATEGCOULEUR: json['CLICATEGCOULEUR'] ?? '',
      CLICOMMERCIAL: json['CLICOMMERCIAL'] ?? '',
      CLIREMISE2: (json['CLIREMISE2'] ?? 0).toDouble(),
      CLIREMAUTO2: json['CLIREMAUTO2'] ?? 0,
      CLIREMARTGLOB2: json['CLIREMARTGLOB2'] ?? 0,
      CLIAUTSORTORG: json['CLIAUTSORTORG'] ?? 0,
      CLINOMFACT: json['CLINOMFACT'] ?? '',
      CLILOCALISATION: json['CLILOCALISATION'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CLINO': CLINO,
      'CLICATEG': CLICATEG,
      'CLINATURE': CLINATURE,
      'CLIAM': CLIAM,
      'CLIPERIODIQUE': CLIPERIODIQUE,
      'CLIFINACTIVITE': CLIFINACTIVITE?.toIso8601String(),
      'CLITYPE': CLITYPE,
      'CLIPRENOM': CLIPRENOM,
      'CLIDATENSC': CLIDATENSC.toIso8601String(),
      'CLISEXE': CLISEXE,
      'CLINAT': CLINAT,
      'CLIADR1': CLIADR1,
      'CLIADR2': CLIADR2,
      'CLIADR3': CLIADR3,
      'CLIADR4': CLIADR4,
      'CLIPAYS': CLIPAYS,
      'CLITERR': CLITERR,
      'CLITEL1': CLITEL1,
      'CLITEL2': CLITEL2,
      'CLIFAX': CLIFAX,
      'CLIEMAIL': CLIEMAIL,
      'CLIWEB': CLIWEB,
      'CLIBANQUE': CLIBANQUE,
      'CLIAGENCE': CLIAGENCE,
      'CLICOMPTE': CLICOMPTE,
      'CLIIF': CLIIF,
      'CLIAI': CLIAI,
      'CLINIS': CLINIS,
      'CLIEXONERE': CLIEXONERE,
      'CLIREMISE': CLIREMISE,
      'CLIREMAUTO': CLIREMAUTO,
      'CLIENCMAX': CLIENCMAX,
      'CLISOLDE': CLISOLDE,
      'CLISLDINIT': CLISLDINIT,
      'CLIREGL': CLIREGL,
      'CLISOLDEAB': CLISOLDEAB,
      'CLISLDINITAB': CLISLDINITAB,
      'CLIREGLAB': CLIREGLAB,
      'CLINOTES': CLINOTES,
      'CLITARIF': CLITARIF,
      'CLIPCPT': CLIPCPT,
      'CLIACTIF': CLIACTIF,
      'CLICACHE': CLICACHE,
      'CLIPEUTPAYER': CLIPEUTPAYER,
      'CLIVEUTPAYER': CLIVEUTPAYER,
      'CLINOBOITE': CLINOBOITE,
      'CLIFOU': CLIFOU,
      'CLIFOUNO': CLIFOUNO,
      'CLIREGION': CLIREGION,
      'CLINOM': CLINOM,
      'CLINEW': CLINEW,
      'CLIBANQUE2': CLIBANQUE2,
      'CLIAGENCE2': CLIAGENCE2,
      'CLICOMPTE2': CLICOMPTE2,
      'CLIBANQUE3': CLIBANQUE3,
      'CLIAGENCE3': CLIAGENCE3,
      'CLICOMPTE3': CLICOMPTE3,
      'CLIRC': CLIRC,
      'CLIAUTPAYECHQ': CLIAUTPAYECHQ,
      'CLIREMARTGLOB': CLIREMARTGLOB,
      'CLIACTIVITE': CLIACTIVITE,
      'CLIVILLE': CLIVILLE,
      'CLITRANSPORTEUR': CLITRANSPORTEUR,
      'CLITARIFAB': CLITARIFAB,
      'CLIDHCRE': CLIDHCRE.toIso8601String(),
      'CLICREPAR': CLICREPAR,
      'CLIDHMOD': CLIDHMOD.toIso8601String(),
      'CLIMODPAR': CLIMODPAR,
      'CLICATEGCOULEUR': CLICATEGCOULEUR,
      'CLICOMMERCIAL': CLICOMMERCIAL,
      'CLIREMISE2': CLIREMISE2,
      'CLIREMAUTO2': CLIREMAUTO2,
      'CLIREMARTGLOB2': CLIREMARTGLOB2,
      'CLIAUTSORTORG': CLIAUTSORTORG,
      'CLINOMFACT': CLINOMFACT,
      'CLILOCALISATION': CLILOCALISATION,
    };
  }

  static List<Client> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Client.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Client> list) {
    return list.map((client) => client.toJson()).toList();
  }
}
