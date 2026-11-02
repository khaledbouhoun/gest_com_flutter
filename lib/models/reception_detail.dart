class ReceptionDetail {
  DateTime? fTDDATE;
  String? fTDNO;
  String? fTDART;
  double? fTDORD;
  double? fTDQTE;
  double? fTDPU;
  String? fTDCTVA;
  double? fTDTVA;
  double? fTDTREM;
  double? fTDREMISE;
  double? fTDMNTTTC;
  double? fTDREMGLOB;
  double? fTDLONG;
  double? fTDLARG;
  double? fTDCOMPAR;
  double? fTDPUTTC;
  String? fTDCOLISAGE;
  double? fTDCOLIS;
  double? fTDUNTCOL;
  String? fTDDEPOT;
  double? fTDFRAISACC;
  double? fTDTYPEREM;
  double? fTDCOUTU;
  double? fTDCOUTG;
  String? fTDARTNOM;
  double? fTDPUCOLIS;
  double? fTDQTEG;

  ReceptionDetail(
      {this.fTDDATE,
      this.fTDNO,
      this.fTDART,
      this.fTDORD,
      this.fTDQTE,
      this.fTDPU,
      this.fTDCTVA,
      this.fTDTVA,
      this.fTDTREM,
      this.fTDREMISE,
      this.fTDMNTTTC,
      this.fTDREMGLOB,
      this.fTDLONG,
      this.fTDLARG,
      this.fTDCOMPAR,
      this.fTDPUTTC,
      this.fTDCOLISAGE,
      this.fTDCOLIS,
      this.fTDUNTCOL,
      this.fTDDEPOT,
      this.fTDFRAISACC,
      this.fTDTYPEREM,
      this.fTDCOUTU,
      this.fTDCOUTG,
      this.fTDARTNOM,
      this.fTDPUCOLIS,
      this.fTDQTEG});

  ReceptionDetail.fromJson(Map<String, dynamic> json) {
    fTDDATE = DateTime.parse(json['FTDDATE']);
    fTDNO = json['FTDNO'];
    fTDART = json['FTDART'];
    fTDORD = (json['FTDORD'] as num?)?.toDouble();
    fTDQTE = (json['FTDQTE'] as num?)?.toDouble();
    fTDPU = (json['FTDPU'] as num?)?.toDouble();
    fTDCTVA = json['FTDCTVA'];
    fTDTVA = (json['FTDTVA'] as num?)?.toDouble();
    fTDTREM = (json['FTDTREM'] as num?)?.toDouble();
    fTDREMISE = (json['FTDREMISE'] as num?)?.toDouble();
    fTDMNTTTC = (json['FTDMNTTTC'] as num?)?.toDouble();
    fTDREMGLOB = (json['FTDREMGLOB'] as num?)?.toDouble();
    fTDLONG = (json['FTDLONG'] as num?)?.toDouble();
    fTDLARG = (json['FTDLARG'] as num?)?.toDouble();
    fTDCOMPAR = (json['FTDCOMPAR'] as num?)?.toDouble();
    fTDPUTTC = (json['FTDPUTTC'] as num?)?.toDouble();
    fTDCOLISAGE = json['FTDCOLISAGE'];
    fTDCOLIS = (json['FTDCOLIS'] as num?)?.toDouble();
    fTDUNTCOL = (json['FTDUNTCOL'] as num?)?.toDouble();
    fTDDEPOT = json['FTDDEPOT'];
    fTDFRAISACC = (json['FTDFRAISACC'] as num?)?.toDouble();
    fTDTYPEREM = (json['FTDTYPEREM'] as num?)?.toDouble();
    fTDCOUTU = (json['FTDCOUTU'] as num?)?.toDouble();
    fTDCOUTG = (json['FTDCOUTG'] as num?)?.toDouble();
    fTDARTNOM = json['FTDARTNOM'];
    fTDPUCOLIS = (json['FTDPUCOLIS'] as num?)?.toDouble();
    fTDQTEG = (json['FTDQTEG'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['FTDDATE'] = fTDDATE;
    data['FTDNO'] = fTDNO;
    data['FTDART'] = fTDART;
    data['FTDORD'] = fTDORD;
    data['FTDQTE'] = fTDQTE;
    data['FTDPU'] = fTDPU;
    data['FTDCTVA'] = fTDCTVA;
    data['FTDTVA'] = fTDTVA;
    data['FTDTREM'] = fTDTREM;
    data['FTDREMISE'] = fTDREMISE;
    data['FTDMNTTTC'] = fTDMNTTTC;
    data['FTDREMGLOB'] = fTDREMGLOB;
    data['FTDLONG'] = fTDLONG;
    data['FTDLARG'] = fTDLARG;
    data['FTDCOMPAR'] = fTDCOMPAR;
    data['FTDPUTTC'] = fTDPUTTC;
    data['FTDCOLISAGE'] = fTDCOLISAGE;
    data['FTDCOLIS'] = fTDCOLIS;
    data['FTDUNTCOL'] = fTDUNTCOL;
    data['FTDDEPOT'] = fTDDEPOT;
    data['FTDFRAISACC'] = fTDFRAISACC;
    data['FTDTYPEREM'] = fTDTYPEREM;
    data['FTDCOUTU'] = fTDCOUTU;
    data['FTDCOUTG'] = fTDCOUTG;
    data['FTDARTNOM'] = fTDARTNOM;
    data['FTDPUCOLIS'] = fTDPUCOLIS;
    data['FTDQTEG'] = fTDQTEG;
    return data;
  }
}
