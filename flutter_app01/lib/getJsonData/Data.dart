class TotalData {
  int code;
  VersionData versionData;
  TotalData({this.code, this.versionData});
  factory TotalData.fromJson(Map<String, dynamic> json) {
    return TotalData(
        code: json['code'], versionData: VersionData.fromJson(json['data']));
  }
}

class VersionData {
  String id;
  static String oldversionId = "201";
  String newversionId;
  String versionTime;
  String versionUrl;
  String versionText;
  String versionType;

  VersionData(
      {this.id,
      this.newversionId,
      this.versionTime,
      this.versionUrl,
      this.versionText,
      this.versionType});
  factory VersionData.fromJson(Map<String, dynamic> json) {
    return VersionData(
        id: json['id'],
        newversionId: json['versionId'],
        versionTime: json['versionTime'],
        versionUrl: json['versionUrl'],
        versionText: json['versionText'],
        versionType: json['versionType']);
  }
}

class switchData {
  var data;
  var code;
  switchData({this.data, this.code});

  factory switchData.fromJson(Map<String, dynamic> json) {
    return switchData(
      data: json['data'],
      code: json['code'],
    );
  }
}
