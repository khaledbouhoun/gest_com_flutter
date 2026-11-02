class CommandeEntate {
  DateTime? cDEDATE;
  String? cDENO;
  String? cDECLI;
  int? cDEETAT;
  double? cDEMNTHT;
  double? cDEMNTTVA;
  double? cDEMNTTTC;
  double? cDETREM;
  double? cDEREMISE;
  double? cDENAP;
  String? cDENOTES;
  DateTime? cDEDHCRE;
  DateTime? cDEDHMOD;
  int? cDEVALIDE;
  DateTime? cDEDATEVAL;
  String? cDESITE;
  DateTime? cDEDHIMPR;
  int? cDETYPEREM;
  String? cDECREPAR;
  String? cDEMODPAR;
  String? cDEVALPAR;
  String? cDEIMPRPAR;
  String? cDENOBC;
  DateTime? cDEDATELIVR;
  String? cDECODESEL;
  String? cDEJNL;
  double? cDETIMBRE;
  String? cDECATEG;
  DateTime? cDEDATERSV;
  int? cDERSVCOURS;
  int? cDEVERROU;
  DateTime? cDEDHDERNOUVER;
  String? cLINOM;
  String? cLIPRENOM;
  String? cLITEL1;

  CommandeEntate(
      {this.cDEDATE,
      this.cDENO,
      this.cDECLI,
      this.cDEETAT,
      this.cDEMNTHT,
      this.cDEMNTTVA,
      this.cDEMNTTTC,
      this.cDETREM,
      this.cDEREMISE,
      this.cDENAP,
      this.cDENOTES,
      this.cDEDHCRE,
      this.cDEDHMOD,
      this.cDEVALIDE,
      this.cDEDATEVAL,
      this.cDESITE,
      this.cDEDHIMPR,
      this.cDETYPEREM,
      this.cDECREPAR,
      this.cDEMODPAR,
      this.cDEVALPAR,
      this.cDEIMPRPAR,
      this.cDENOBC,
      this.cDEDATELIVR,
      this.cDECODESEL,
      this.cDEJNL,
      this.cDETIMBRE,
      this.cDECATEG,
      this.cDEDATERSV,
      this.cDERSVCOURS,
      this.cDEVERROU,
      this.cDEDHDERNOUVER,
      this.cLINOM,
      this.cLIPRENOM,
      this.cLITEL1});

  CommandeEntate.fromJson(Map<String, dynamic> json) {
    cDEDATE = json['CDEDATE'] != null ? DateTime.parse(json['CDEDATE']) : null;
    cDENO = json['CDENO'];
    cDECLI = json['CDECLI'];
    cDEETAT = json['CDEETAT'];
    cDEMNTHT = (json['CDEMNTHT'] as num?)?.toDouble();
    cDEMNTTVA = (json['CDEMNTTVA'] as num?)?.toDouble();
    cDEMNTTTC = (json['CDEMNTTTC'] as num?)?.toDouble();
    cDETREM = (json['CDETREM'] as num?)?.toDouble();
    cDEREMISE = (json['CDEREMISE'] as num?)?.toDouble();
    cDENAP = (json['CDENAP'] as num?)?.toDouble();
    cDENOTES = json['CDENOTES'];
    cDEDHCRE = json['CDEDHCRE'] != null ? DateTime.parse(json['CDEDHCRE']) : null;
    cDEDHMOD = json['CDEDHMOD'] != null ? DateTime.parse(json['CDEDHMOD']) : null;
    cDEVALIDE = json['CDEVALIDE'];
    cDEDATEVAL = json['CDEDATEVAL'] != null ? DateTime.parse(json['CDEDATEVAL']) : null;
    cDESITE = json['CDESITE'];
    cDEDHIMPR = json['CDEDHIMPR'] != null ? DateTime.parse(json['CDEDHIMPR']) : null;
    cDETYPEREM = json['CDETYPEREM'];
    cDECREPAR = json['CDECREPAR'];
    cDEMODPAR = json['CDEMODPAR'];
    cDEVALPAR = json['CDEVALPAR'];
    cDEIMPRPAR = json['CDEIMPRPAR'];
    cDENOBC = json['CDENOBC'];
    cDEDATELIVR = json['CDEDATELIVR'] != null ? DateTime.parse(json['CDEDATELIVR']) : null;
    cDECODESEL = json['CDECODESEL'];
    cDEJNL = json['CDEJNL'];
    cDETIMBRE = (json['CDETIMBRE'] as num?)?.toDouble();
    cDECATEG = json['CDECATEG'];
    cDEDATERSV = json['CDEDATERSV'] != null ? DateTime.parse(json['CDEDATERSV']) : null;
    cDERSVCOURS = json['CDERSVCOURS'];
    cDEVERROU = json['CDEVERROU'];
    cDEDHDERNOUVER = json['CDEDHDERNOUVER'] != null ? DateTime.parse(json['CDEDHDERNOUVER']) : null;
    cLINOM = json['CLINOM'];
    cLIPRENOM = json['CLIPRENOM'];
    cLITEL1 = json['CLITEL1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CDEDATE'] = cDEDATE;
    data['CDENO'] = cDENO;
    data['CDECLI'] = cDECLI;
    data['CDEETAT'] = cDEETAT;
    data['CDEMNTHT'] = cDEMNTHT;
    data['CDEMNTTVA'] = cDEMNTTVA;
    data['CDEMNTTTC'] = cDEMNTTTC;
    data['CDETREM'] = cDETREM;
    data['CDEREMISE'] = cDEREMISE;
    data['CDENAP'] = cDENAP;
    data['CDENOTES'] = cDENOTES;
    data['CDEDHCRE'] = cDEDHCRE;
    data['CDEDHMOD'] = cDEDHMOD;
    data['CDEVALIDE'] = cDEVALIDE;
    data['CDEDATEVAL'] = cDEDATEVAL;
    data['CDESITE'] = cDESITE;
    data['CDEDHIMPR'] = cDEDHIMPR;
    data['CDETYPEREM'] = cDETYPEREM;
    data['CDECREPAR'] = cDECREPAR;
    data['CDEMODPAR'] = cDEMODPAR;
    data['CDEVALPAR'] = cDEVALPAR;
    data['CDEIMPRPAR'] = cDEIMPRPAR;
    data['CDENOBC'] = cDENOBC;
    data['CDEDATELIVR'] = cDEDATELIVR;
    data['CDECODESEL'] = cDECODESEL;
    data['CDEJNL'] = cDEJNL;
    data['CDETIMBRE'] = cDETIMBRE;
    data['CDECATEG'] = cDECATEG;
    data['CDEDATERSV'] = cDEDATERSV;
    data['CDERSVCOURS'] = cDERSVCOURS;
    data['CDEVERROU'] = cDEVERROU;
    data['CDEDHDERNOUVER'] = cDEDHDERNOUVER;
    data['CLINOM'] = cLINOM;
    data['CLIPRENOM'] = cLIPRENOM;
    data['CLITEL1'] = cLITEL1;
    return data;
  }
}
