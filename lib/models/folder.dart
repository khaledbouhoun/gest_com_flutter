class Folder {
  String DOSNO;
  String DOSNOM;
  String DOSEXE;
  String DOSBDD;
  double DOSETAT;
  String DOSEXELOC;
  double DOSPOSITION;

  Folder({
    required this.DOSNO,
    required this.DOSNOM,
    required this.DOSEXE,
    required this.DOSBDD,
    required this.DOSETAT,
    required this.DOSEXELOC,
    required this.DOSPOSITION,
  });

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(
      DOSNO: json['DOSNO'] ?? '',
      DOSNOM: json['DOSNOM'] ?? '',
      DOSEXE: json['DOSEXE'] ?? '',
      DOSBDD: json['DOSBDD'] ?? '',
      DOSETAT: (json['DOSETAT'] as num).toDouble() ?? 0.0,
      DOSEXELOC: json['DOSEXELOC'] ?? '',
      DOSPOSITION: (json['DOSPOSITION'] as num).toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DOSNO': DOSNO,
      'DOSNOM': DOSNOM,
      'DOSEXE': DOSEXE,
      'DOSBDD': DOSBDD,
      'DOSETAT': DOSETAT,
      'DOSEXELOC': DOSEXELOC,
      'DOSPOSITION': DOSPOSITION,
    };
  }

  static List<Folder> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Folder.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<Folder> folderList) {
    return folderList.map((folder) => folder.toJson()).toList();
  }
}
