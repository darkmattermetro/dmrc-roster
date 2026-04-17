class Duty {
  final int id;
  final String dutyNo;
  final String signOnTime;
  final String signOnLoc;
  final String signOffTime;
  final String signOffLoc;
  final String drivingHrs;
  final String dutyHrs;
  final String sameJurisdiction;
  final String rakeNum;
  final String startStn;
  final String startTime;
  final String endStn;
  final String endTime;
  final String serviceDuration;
  final String breakTime;
  final String stepbackRake;

  Duty({
    required this.id,
    required this.dutyNo,
    required this.signOnTime,
    required this.signOnLoc,
    required this.signOffTime,
    required this.signOffLoc,
    required this.drivingHrs,
    required this.dutyHrs,
    required this.sameJurisdiction,
    required this.rakeNum,
    required this.startStn,
    required this.startTime,
    required this.endStn,
    required this.endTime,
    required this.serviceDuration,
    required this.breakTime,
    required this.stepbackRake,
  });

  factory Duty.fromJson(Map<String, dynamic> json) {
    return Duty(
      id: json['id'] ?? 0,
      dutyNo: json['duty_no'] ?? '',
      signOnTime: json['sign_on_time'] ?? '',
      signOnLoc: json['sign_on_loc'] ?? '',
      signOffTime: json['sign_off_time'] ?? '',
      signOffLoc: json['sign_off_loc'] ?? '',
      drivingHrs: json['driving_hrs'] ?? '',
      dutyHrs: json['duty_hrs'] ?? '',
      sameJurisdiction: json['same_jurisdiction'] ?? '',
      rakeNum: json['rake_num'] ?? '',
      startStn: json['start_stn'] ?? '',
      startTime: json['start_time'] ?? '',
      endStn: json['end_stn'] ?? '',
      endTime: json['end_time'] ?? '',
      serviceDuration: json['service_duration'] ?? '',
      breakTime: json['break_time'] ?? '',
      stepbackRake: json['stepback_rake'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'duty_no': dutyNo,
      'sign_on_time': signOnTime,
      'sign_on_loc': signOnLoc,
      'sign_off_time': signOffTime,
      'sign_off_loc': signOffLoc,
      'driving_hrs': drivingHrs,
      'duty_hrs': dutyHrs,
      'same_jurisdiction': sameJurisdiction,
      'rake_num': rakeNum,
      'start_stn': startStn,
      'start_time': startTime,
      'end_stn': endStn,
      'end_time': endTime,
      'service_duration': serviceDuration,
      'break_time': breakTime,
      'stepback_rake': stepbackRake,
    };
  }

  String get rake => rakeNum;
  String get depLoc => startStn;
  String get depTime => startTime;
  String get arrLoc => endStn;
  String get arrTime => endTime;
  String? get wefDate => null;
  String? get remarks => null;
}

class DutyResult {
  final List<Duty> duties;
  final double totalKm;
  final String wefDate;
  final String remarks;
  final List<RakeGap> rakeGaps;
  final String? error;

  DutyResult({
    required this.duties,
    required this.totalKm,
    required this.wefDate,
    required this.remarks,
    required this.rakeGaps,
    this.error,
  });

  factory DutyResult.success({
    required List<Duty> duties,
    required double totalKm,
    required String wefDate,
    required String remarks,
    required List<RakeGap> rakeGaps,
  }) {
    return DutyResult(
      duties: duties,
      totalKm: totalKm,
      wefDate: wefDate,
      remarks: remarks,
      rakeGaps: rakeGaps,
    );
  }

  factory DutyResult.error(String message) {
    return DutyResult(
      duties: [],
      totalKm: 0,
      wefDate: '',
      remarks: '',
      rakeGaps: [],
      error: message,
    );
  }
}

class RakeGap {
  final String rakeId;
  final String time;
  final String location;
  final String action;
  final int gapMinutes;

  RakeGap({
    required this.rakeId,
    required this.time,
    required this.location,
    required this.action,
    required this.gapMinutes,
  });

  String get displayText =>
      '$rakeId @ $location - $action ($gapMinutes min gap)';
}
