import 'package:flutter/material.dart';
import 'package:gestion_stock/models/tarif_entate.dart';
import 'package:gestion_stock/view_models/stock_view_model.dart';
import 'package:provider/provider.dart';

class TarifDetail {
  String tfdtfe;
  String tTFDART;
  double marge;
  double tFDPRIXMIN;
  double ttc;
  int base;
  double? tariftype;

  TarifDetail({
    this.tfdtfe = '',
    this.tTFDART = '',
    this.marge = 0.0,
    this.tFDPRIXMIN = 0.0,
    this.ttc = 0.0,
    this.base = 0,
    this.tariftype,
  });

  factory TarifDetail.fromJson(
      Map<String, dynamic> json, BuildContext context) {
    return TarifDetail(
      tfdtfe: json['TFDTFE'] ?? '',
      tTFDART: json['TFDART'] ?? '',
      marge: (json['TFDPRIX'] as num?)?.toDouble() ?? 0.0,
      tFDPRIXMIN: (json['TFDPRIXMIN'] as num?)?.toDouble() ?? 0.0,
      ttc: (json['TFDPRIXTTC'] as num?)?.toDouble() ?? 0.0,
      base: (json['TFDBASE'] as num?)?.toInt() ?? 0,
      tariftype: Provider.of<StockViewModel>(context, listen: false)
          .tarifs
          ?.firstWhere((element) => element.TFENO == json['TFDTFE'],
              orElse: () => Provider.of<StockViewModel>(context, listen: false)
                  .tarifs!
                  .first)
          .TFETYPE,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tarif': tfdtfe,
      'article': tTFDART,
      'marge': marge,
      'ttc': ttc,
      'base': base,
      'tarif_type': tariftype,
    };
  }

  static List<TarifDetail> listFromJson(
      List<dynamic> json, BuildContext context) {
    return json
        .map((e) => TarifDetail.fromJson(e as Map<String, dynamic>, context))
        .toList();
  }

  static List<Map<String, dynamic>> listToJson(List<TarifDetail> list) {
    return list.map((e) => e.toJson()).toList();
  }
}
