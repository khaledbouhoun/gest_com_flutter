class Product {
  List<DepotStock> depots = [];
  String? ARTNO;
  String? ARTUNI;
  double? ARTPOIDS;
  double? ARTCOMPO;
  String? ARTFAM;
  String? ARTSFAM;
  String? ARTTVA;
  double? ARTQTEAB;
  double? ARTVALAB;
  double? ARTPRIXACH;
  double? ARTPRIXACHAB;
  double? ARTQTEMIN;
  double? ARTQTEMAX;
  double? ARTQTE;
  double? ARTVAL;
  double? ARTPMPAB;
  double? ARTALERTE;
  String? ARTFOU;
  double? ARTCOUL;
  double? ARTPMP;
  double? ARTDPA;
  double? ARTACTIF;
  double? ARTQTEINIT;
  double? ARTVALINIT;
  double? ARTQTEINITAB;
  double? ARTVALINITAB;
  double? ARTAM;
  double? ARTCACHE;
  double? ARTLONG;
  double? ARTLARG;
  double? ARTACHPAR;
  double? ARTVTEPAR; ////
  double? ARTTYPE;
  double? ARTPRIXVTE;
  double? ARTMARGE;
  String? ARTCOLIS;
  double? ARTUNTCOL;
  double? ARTVOLUME;
  String? ARTNOMSUP;
  double? ARTPAP;
  double? ARTNEW;
  double? ARTPAPAM;
  double? ARTDDOUANE;
  double? ARTMODIFNOM;
  double? ARTPRODPAR;
  String? ARTROUTINE;
  double? ARTREMISABLE;
  double? ARTTXREMISE;
  String? ARTCPTSTOCK;
  String? ARTCPTINTERM;
  String? ARTCPTCHARGE;
  String? ARTCAB;
  double? ARTAUTSTKNEG;
  double? ARTAUTSTKNEGAB;
  double? ARTNUMSERIE;
  String? ARTTSERV;
  String? ARTNOM;
  String? ARTLIENFICHE;
  double? ARTCOMPO2;
  String? ARTCATEG;
  String? ARTCAB2;
  String? ARTCAB3;
  String? ARTCAB4;
  String? ARTCAB5;
  String? ARTCAB6;
  String? ARTCAB7;
  String? ARTCAB8;
  String? ARTCAB9;
  String? ARTCAB10;
  String? ARTMARQUE;
  String? ARTNOMEN;
  String? ARTCASIER;
  double? ARTKIT;
  String? ARTREF;
  String? ARTREF2;
  String? ARTREF3;
  double? ARTQTETHEOR;
  double? ARTPRIX;
  String? TFDTFE;
  String? TFDART;
  double? TFDPRIX;
  double? TFDPRIXMIN;
  double? TFDPRIXTTC;
  double? TFDBASE;
  double? TFETYPE;

  Product({
    this.ARTNO = '',
    this.ARTUNI,
    this.ARTPOIDS = 0.0,
    this.ARTCOMPO = 0.0,
    this.ARTFAM,
    this.ARTSFAM,
    this.ARTTVA,
    this.ARTQTEAB = 0.0,
    this.ARTVALAB = 0.0,
    this.ARTPRIXACH = 0.0,
    this.ARTPRIXACHAB = 0.0,
    this.ARTQTEMIN = 0.0,
    this.ARTQTEMAX = 0.0,
    this.ARTQTE = 0.0,
    this.ARTVAL = 0.0,
    this.ARTPMPAB = 0.0,
    this.ARTALERTE = 0.0,
    this.ARTFOU = '',
    this.ARTCOUL = 0.0,
    this.ARTPMP = 0.0,
    this.ARTDPA = 0.0,
    this.ARTACTIF = 0.0,
    this.ARTQTEINIT = 0.0,
    this.ARTVALINIT = 0.0,
    this.ARTQTEINITAB = 0.0,
    this.ARTVALINITAB = 0.0,
    this.ARTAM = 0.0,
    this.ARTCACHE = 0.0,
    this.ARTLONG = 0.0,
    this.ARTLARG = 0.0,
    this.ARTACHPAR,
    this.ARTVTEPAR,
    this.ARTTYPE = 0.0,
    this.ARTPRIXVTE = 0.0,
    this.ARTMARGE = 0.0,
    this.ARTCOLIS,
    this.ARTUNTCOL = 0.0,
    this.ARTVOLUME = 0.0,
    this.ARTNOMSUP = '',
    this.ARTPAP = 0.0,
    this.ARTNEW = 0.0,
    this.ARTPAPAM = 0.0,
    this.ARTDDOUANE = 0.0,
    this.ARTMODIFNOM = 0.0,
    this.ARTPRODPAR = 0.0,
    this.ARTROUTINE = '',
    this.ARTREMISABLE = 0.0,
    this.ARTTXREMISE = 0.0,
    this.ARTCPTSTOCK = '',
    this.ARTCPTINTERM = '',
    this.ARTCPTCHARGE = '',
    this.ARTCAB = '',
    this.ARTAUTSTKNEG = 0.0,
    this.ARTAUTSTKNEGAB = 0.0,
    this.ARTNUMSERIE = 0.0,
    this.ARTTSERV = '',
    this.ARTNOM = '',
    this.ARTLIENFICHE = '',
    this.ARTCOMPO2 = 0.0,
    this.ARTCATEG = '',
    this.ARTCAB2 = '',
    this.ARTCAB3 = '',
    this.ARTCAB4 = '',
    this.ARTCAB5 = '',
    this.ARTCAB6 = '',
    this.ARTCAB7 = '',
    this.ARTCAB8 = '',
    this.ARTCAB9 = '',
    this.ARTCAB10 = '',
    this.ARTMARQUE,
    this.ARTNOMEN = '',
    this.ARTCASIER = '',
    this.ARTKIT = 0.0,
    this.ARTREF = '',
    this.ARTREF2 = '',
    this.ARTREF3 = '',
    this.ARTQTETHEOR = 0.0,
    this.ARTPRIX = 0.0,
    this.TFDTFE = '',
    this.TFDART = '',
    this.TFDPRIX = 0.0,
    this.TFDPRIXMIN = 0.0,
    this.TFDPRIXTTC = 0.0,
    this.TFDBASE = 0.0,
    this.TFETYPE = 0.0,
    // List<DepotStock>? depots,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      ARTNO: json['ARTNO'] ?? '',
      ARTUNI: json['ARTUNI'],
      ARTPOIDS: json['ARTPOIDS']?.toDouble() ?? 0.0,
      ARTCOMPO: json['ARTCOMPO']?.toDouble() ?? 0.0,
      ARTFAM: json['ARTFAM'],
      ARTSFAM: json['ARTSFAM'],
      ARTTVA: json['ARTTVA'] ?? "01",
      ARTQTEAB: json['ARTQTEAB']?.toDouble() ?? 0.0,
      ARTVALAB: json['ARTVALAB']?.toDouble() ?? 0.0,
      ARTPRIXACH: json['ARTPRIXACH']?.toDouble() ?? 0.0,
      ARTPRIXACHAB: json['ARTPRIXACHAB']?.toDouble() ?? 0.0,
      ARTQTEMIN: json['ARTQTEMIN']?.toDouble() ?? 0.0,
      ARTQTEMAX: json['ARTQTEMAX']?.toDouble() ?? 0.0,
      ARTQTE: json['ARTQTE']?.toDouble() ?? 0.0,
      ARTVAL: json['ARTVAL']?.toDouble() ?? 0.0,
      ARTPMPAB: json['ARTPMPAB']?.toDouble() ?? 0.0,
      ARTALERTE: json['ARTALERTE']?.toDouble() ?? 0.0,
      ARTFOU: json['ARTFOU'] ?? '',
      ARTCOUL: json['ARTCOUL']?.toDouble() ?? 0.0,
      ARTPMP: json['ARTPMP']?.toDouble() ?? 0.0,
      ARTDPA: json['ARTDPA']?.toDouble() ?? 0.0,
      ARTACTIF: json['ARTACTIF']?.toDouble() ?? 0.0,
      ARTQTEINIT: json['ARTQTEINIT']?.toDouble() ?? 0.0,
      ARTVALINIT: json['ARTVALINIT']?.toDouble() ?? 0.0,
      ARTQTEINITAB: json['ARTQTEINITAB']?.toDouble() ?? 0.0,
      ARTVALINITAB: json['ARTVALINITAB']?.toDouble() ?? 0.0,
      ARTAM: json['ARTAM']?.toDouble() ?? 0.0,
      ARTCACHE: json['ARTCACHE']?.toDouble() ?? 0.0,
      ARTLONG: json['ARTLONG']?.toDouble() ?? 0.0,
      ARTLARG: json['ARTLARG']?.toDouble() ?? 0.0,
      ARTACHPAR: json['ARTACHPAR']?.toDouble(),
      ARTVTEPAR: json['ARTVTEPAR']?.toDouble(),
      ARTTYPE: json['ARTTYPE']?.toDouble() ?? 0.0,
      ARTPRIXVTE: json['ARTPRIXVTE']?.toDouble() ?? 0.0,
      ARTMARGE: json['ARTMARGE']?.toDouble() ?? 0.0,
      ARTCOLIS: json['ARTCOLIS'],
      ARTUNTCOL: json['ARTUNTCOL']?.toDouble() ?? 0.0,
      ARTVOLUME: json['ARTVOLUME']?.toDouble() ?? 0.0,
      ARTNOMSUP: json['ARTNOMSUP'] ?? '',
      ARTPAP: json['ARTPAP']?.toDouble() ?? 0.0,
      ARTNEW: json['ARTNEW']?.toDouble() ?? 0.0,
      ARTPAPAM: json['ARTPAPAM']?.toDouble() ?? 0.0,
      ARTDDOUANE: json['ARTDDOUANE']?.toDouble() ?? 0.0,
      ARTMODIFNOM: json['ARTMODIFNOM']?.toDouble() ?? 0.0,
      ARTPRODPAR: json['ARTPRODPAR']?.toDouble() ?? 0.0,
      ARTROUTINE: json['ARTROUTINE'] ?? '',
      ARTREMISABLE: json['ARTREMISABLE']?.toDouble() ?? 0.0,
      ARTTXREMISE: json['ARTTXREMISE']?.toDouble() ?? 0.0,
      ARTCPTSTOCK: json['ARTCPTSTOCK'] ?? '',
      ARTCPTINTERM: json['ARTCPTINTERM'] ?? '',
      ARTCPTCHARGE: json['ARTCPTCHARGE'] ?? '',
      ARTCAB: json['ARTCAB'] ?? '',
      ARTAUTSTKNEG: json['ARTAUTSTKNEG']?.toDouble() ?? 0.0,
      ARTAUTSTKNEGAB: json['ARTAUTSTKNEGAB']?.toDouble() ?? 0.0,
      ARTNUMSERIE: json['ARTNUMSERIE']?.toDouble() ?? 0.0,
      ARTTSERV: json['ARTTSERV'] ?? '',
      ARTNOM: json['ARTNOM'] ?? '',
      ARTLIENFICHE: json['ARTLIENFICHE'] ?? '',
      ARTCOMPO2: json['ARTCOMPO2']?.toDouble() ?? 0.0,
      ARTCATEG: json['ARTCATEG'] ?? '',
      ARTCAB2: json['ARTCAB2'] ?? '',
      ARTCAB3: json['ARTCAB3'] ?? '',
      ARTCAB4: json['ARTCAB4'] ?? '',
      ARTCAB5: json['ARTCAB5'] ?? '',
      ARTCAB6: json['ARTCAB6'] ?? '',
      ARTCAB7: json['ARTCAB7'] ?? '',
      ARTCAB8: json['ARTCAB8'] ?? '',
      ARTCAB9: json['ARTCAB9'] ?? '',
      ARTCAB10: json['ARTCAB10'] ?? '',
      ARTMARQUE: json['ARTMARQUE'],
      ARTNOMEN: json['ARTNOMEN'] ?? '',
      ARTCASIER: json['ARTCASIER'] ?? '',
      ARTKIT: json['ARTKIT']?.toDouble() ?? 0.0,
      ARTREF: json['ARTREF'] ?? '',
      ARTREF2: json['ARTREF2'] ?? '',
      ARTREF3: json['ARTREF3'] ?? '',
      ARTQTETHEOR: json['ARTQTETHEOR']?.toDouble() ?? 0.0,
      ARTPRIX: json['ARTPRIX']?.toDouble() ?? 0.0,
      TFDTFE: json['TFDTFE'] ?? '',
      TFDART: json['TFDART'] ?? '',
      TFDPRIX: json['TFDPRIX']?.toDouble() ?? 0.0,
      TFDPRIXMIN: json['TFDPRIXMIN']?.toDouble() ?? 0.0,
      TFDPRIXTTC: json['TFDPRIXTTC']?.toDouble() ?? 0.0,
      TFDBASE: json['TFDBASE']?.toDouble() ?? 0.0,
      TFETYPE: json['TFETYPE']?.toDouble() ?? 0.0,
      // depots: [
      //   DepotStock(
      //     depotNom: json['DEPOTNOM'] ?? '',
      //     depot: json['ARTDEPOT'] ?? '',
      //     qte: (json['ARTQTE'] as num?)?.toDouble() ?? 0.0,
      //   )
      // ],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ARTNO': ARTNO,
      'ARTUNI': ARTUNI,
      'ARTPOIDS': ARTPOIDS,
      'ARTCOMPO': ARTCOMPO,
      'ARTFAM': ARTFAM,
      'ARTSFAM': ARTSFAM,
      'ARTTVA': ARTTVA,
      'ARTQTEAB': ARTQTEAB,
      'ARTVALAB': ARTVALAB,
      'ARTPRIXACH': ARTPRIXACH,
      'ARTPRIXACHAB': ARTPRIXACHAB,
      'ARTQTEMIN': ARTQTEMIN,
      'ARTQTEMAX': ARTQTEMAX,
      'ARTQTE': ARTQTE,
      'ARTVAL': ARTVAL,
      'ARTPMPAB': ARTPMPAB,
      'ARTALERTE': ARTALERTE,
      'ARTFOU': ARTFOU,
      'ARTCOUL': ARTCOUL,
      'ARTPMP': ARTPMP,
      'ARTDPA': ARTDPA,
      'ARTACTIF': ARTACTIF,
      'ARTQTEINIT': ARTQTEINIT,
      'ARTVALINIT': ARTVALINIT,
      'ARTQTEINITAB': ARTQTEINITAB,
      'ARTVALINITAB': ARTVALINITAB,
      'ARTAM': ARTAM,
      'ARTCACHE': ARTCACHE,
      'ARTLONG': ARTLONG,
      'ARTLARG': ARTLARG,
      'ARTACHPAR': ARTACHPAR,
      'ARTVTEPAR': ARTVTEPAR,
      'ARTTYPE': ARTTYPE,
      'ARTPRIXVTE': ARTPRIXVTE,
      'ARTMARGE': ARTMARGE,
      'ARTCOLIS': ARTCOLIS,
      'ARTUNTCOL': ARTUNTCOL,
      'ARTVOLUME': ARTVOLUME,
      'ARTNOMSUP': ARTNOMSUP,
      'ARTPAP': ARTPAP,
      'ARTNEW': ARTNEW,
      'ARTPAPAM': ARTPAPAM,
      'ARTDDOUANE': ARTDDOUANE,
      'ARTMODIFNOM': ARTMODIFNOM,
      'ARTPRODPAR': ARTPRODPAR,
      'ARTROUTINE': ARTROUTINE,
      'ARTREMISABLE': ARTREMISABLE,
      'ARTTXREMISE': ARTTXREMISE,
      'ARTCPTSTOCK': ARTCPTSTOCK,
      'ARTCPTINTERM': ARTCPTINTERM,
      'ARTCPTCHARGE': ARTCPTCHARGE,
      'ARTCAB': ARTCAB,
      'ARTAUTSTKNEG': ARTAUTSTKNEG,
      'ARTAUTSTKNEGAB': ARTAUTSTKNEGAB,
      'ARTNUMSERIE': ARTNUMSERIE,
      'ARTTSERV': ARTTSERV,
      'ARTNOM': ARTNOM,
      'ARTLIENFICHE': ARTLIENFICHE,
      'ARTCOMPO2': ARTCOMPO2,
      'ARTCATEG': ARTCATEG,
      'ARTCAB2': ARTCAB2,
      'ARTCAB3': ARTCAB3,
      'ARTCAB4': ARTCAB4,
      'ARTCAB5': ARTCAB5,
      'ARTCAB6': ARTCAB6,
      'ARTCAB7': ARTCAB7,
      'ARTCAB8': ARTCAB8,
      'ARTCAB9': ARTCAB9,
      'ARTCAB10': ARTCAB10,
      'ARTMARQUE': ARTMARQUE,
      'ARTNOMEN': ARTNOMEN,
      'ARTCASIER': ARTCASIER,
      'ARTKIT': ARTKIT,
      'ARTREF': ARTREF,
      'ARTREF2': ARTREF2,
      'ARTREF3': ARTREF3,
      'ARTQTETHEOR': ARTQTETHEOR,
      'ARTPRIX': ARTPRIX,
      'TFDTFE': TFDTFE,
      'TFDART': TFDART,
      'TFDPRIX': TFDPRIX,
      'TFDPRIXMIN': TFDPRIXMIN,
      'TFDPRIXTTC': TFDPRIXTTC,
      'TFDBASE': TFDBASE,
      'TFETYPE': TFETYPE
    };
  }

  static Product modified(Map<String, dynamic> json) {
    return Product(
      ARTNO: json['ARTNO'] ?? '',
      ARTUNI: json['ARTUNI'],
      ARTPOIDS: json['ARTPOIDS']?.toDouble() ?? 0.0,
      ARTCOMPO: json['ARTCOMPO']?.toDouble() ?? 0.0,
      ARTFAM: json['ARTFAM'],
      ARTSFAM: json['ARTSFAM'],
      ARTTVA: json['ARTTVA'],
      ARTQTEAB: json['ARTQTEAB']?.toDouble() ?? 0.0,
      ARTVALAB: json['ARTVALAB']?.toDouble() ?? 0.0,
      ARTPRIXACH: json['ARTPRIXACH']?.toDouble() ?? 0.0,
      ARTPRIXACHAB: json['ARTPRIXACHAB']?.toDouble() ?? 0.0,
      ARTQTEMIN: json['ARTQTEMIN']?.toDouble() ?? 0.0,
      ARTQTEMAX: json['ARTQTEMAX']?.toDouble() ?? 0.0,
      ARTQTE: json['ARTQTE']?.toDouble() ?? 0.0,
      ARTVAL: json['ARTVAL']?.toDouble() ?? 0.0,
      ARTPMPAB: json['ARTPMPAB']?.toDouble() ?? 0.0,
      ARTALERTE: json['ARTALERTE']?.toDouble() ?? 0.0,
      ARTFOU: json['ARTFOU'] ?? '',
      ARTCOUL: json['ARTCOUL']?.toDouble() ?? 0.0,
      ARTPMP: json['ARTPMP']?.toDouble() ?? 0.0,
      ARTDPA: json['ARTDPA']?.toDouble() ?? 0.0,
      ARTACTIF: json['ARTACTIF']?.toDouble() ?? 0.0,
      ARTQTEINIT: json['ARTQTEINIT']?.toDouble() ?? 0.0,
      ARTVALINIT: json['ARTVALINIT']?.toDouble() ?? 0.0,
      ARTQTEINITAB: json['ARTQTEINITAB']?.toDouble() ?? 0.0,
      ARTVALINITAB: json['ARTVALINITAB']?.toDouble() ?? 0.0,
      ARTAM: json['ARTAM']?.toDouble() ?? 0.0,
      ARTCACHE: json['ARTCACHE']?.toDouble() ?? 0.0,
      ARTLONG: json['ARTLONG']?.toDouble() ?? 0.0,
      ARTLARG: json['ARTLARG']?.toDouble() ?? 0.0,
      ARTACHPAR: json['ARTACHPAR']?.toDouble(),
      ARTVTEPAR: json['ARTVTEPAR']?.toDouble(),
      ARTTYPE: json['ARTTYPE']?.toDouble() ?? 0.0,
      ARTPRIXVTE: json['ARTPRIXVTE']?.toDouble() ?? 0.0,
      ARTMARGE: json['ARTMARGE']?.toDouble() ?? 0.0,
      ARTCOLIS: json['ARTCOLIS'],
      ARTUNTCOL: json['ARTUNTCOL']?.toDouble() ?? 0.0,
      ARTVOLUME: json['ARTVOLUME']?.toDouble() ?? 0.0,
      ARTNOMSUP: json['ARTNOMSUP'] ?? '',
      ARTPAP: json['ARTPAP']?.toDouble() ?? 0.0,
      ARTNEW: json['ARTNEW']?.toDouble() ?? 0.0,
      ARTPAPAM: json['ARTPAPAM']?.toDouble() ?? 0.0,
      ARTDDOUANE: json['ARTDDOUANE']?.toDouble() ?? 0.0,
      ARTMODIFNOM: json['ARTMODIFNOM']?.toDouble() ?? 0.0,
      ARTPRODPAR: json['ARTPRODPAR']?.toDouble() ?? 0.0,
      ARTROUTINE: json['ARTROUTINE'] ?? '',
      ARTREMISABLE: json['ARTREMISABLE']?.toDouble() ?? 0.0,
      ARTTXREMISE: json['ARTTXREMISE']?.toDouble() ?? 0.0,
      ARTCPTSTOCK: json['ARTCPTSTOCK'] ?? '',
      ARTCPTINTERM: json['ARTCPTINTERM'] ?? '',
      ARTCPTCHARGE: json['ARTCPTCHARGE'] ?? '',
      ARTCAB: json['ARTCAB'] ?? '',
      ARTAUTSTKNEG: json['ARTAUTSTKNEG']?.toDouble() ?? 0.0,
      ARTAUTSTKNEGAB: json['ARTAUTSTKNEGAB']?.toDouble() ?? 0.0,
      ARTNUMSERIE: json['ARTNUMSERIE']?.toDouble() ?? 0.0,
      ARTTSERV: json['ARTTSERV'] ?? '',
      ARTNOM: json['ARTNOM'] ?? '',
      ARTLIENFICHE: json['ARTLIENFICHE'] ?? '',
      ARTCOMPO2: json['ARTCOMPO2']?.toDouble() ?? 0.0,
      ARTCATEG: json['ARTCATEG'] ?? '',
      ARTCAB2: json['ARTCAB2'] ?? '',
      ARTCAB3: json['ARTCAB3'] ?? '',
      ARTCAB4: json['ARTCAB4'] ?? '',
      ARTCAB5: json['ARTCAB5'] ?? '',
      ARTCAB6: json['ARTCAB6'] ?? '',
      ARTCAB7: json['ARTCAB7'] ?? '',
      ARTCAB8: json['ARTCAB8'] ?? '',
      ARTCAB9: json['ARTCAB9'] ?? '',
      ARTCAB10: json['ARTCAB10'] ?? '',
      ARTMARQUE: json['ARTMARQUE'] ?? '',
      ARTNOMEN: json['ARTNOMEN'] ?? '',
      ARTCASIER: json['ARTCASIER'] ?? '',
      ARTKIT: json['ARTKIT']?.toDouble() ?? 0.0,
      ARTREF: json['ARTREF'] ?? '',
      ARTREF2: json['ARTREF2'] ?? '',
      ARTREF3: json['ARTREF3'] ?? '',
      ARTQTETHEOR: json['ARTQTETHEOR']?.toDouble() ?? 0.0,
      ARTPRIX: json['ARTPRIX']?.toDouble() ?? 0.0,
      TFDTFE: json['TFDTFE'] ?? '',
      TFDART: json['TFDART'] ?? '',
      TFDPRIX: json['TFDPRIX']?.toDouble() ?? 0.0,
      TFDPRIXMIN: json['TFDPRIXMIN']?.toDouble() ?? 0.0,
      TFDPRIXTTC: json['TFDPRIXTTC']?.toDouble() ?? 0.0,
      TFDBASE: json['TFDBASE']?.toDouble() ?? 0.0,
      TFETYPE: json['TFETYPE']?.toDouble() ?? 0.0,
    );
  }

  static List<dynamic> listToJson(List<Product> list) {
    return list.map((product) => product.toJson()).toList();
  }

  static List<Product> listFromJson(List<dynamic> json) {
    return json.map((value) => Product.fromJson(value)).toList();
  }

}

class DepotStock {
  String depotNom;
  String depot;
  double qte;

  DepotStock({
    required this.depotNom,
    required this.depot,
    required this.qte,
  });
}
