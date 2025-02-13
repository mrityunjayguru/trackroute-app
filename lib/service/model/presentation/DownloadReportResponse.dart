/// data : "Summary_2025-02-13_15-51-25.xlsx"

class DownloadReportResponse {
  DownloadReportResponse({
      this.data,});

  DownloadReportResponse.fromJson(dynamic json) {
    data = json['data'];
  }
  String? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['data'] = data;
    return map;
  }

}