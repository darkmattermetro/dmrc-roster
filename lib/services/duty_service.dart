import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../config/constants.dart';
import '../models/duty.dart';

class DutyService {
  final SupabaseClient _client = SupabaseConfig.client;

  String _getTableName(String dayType) {
    switch (dayType.toLowerCase()) {
      case 'saturday':
        return 'duties_saturday';
      case 'sunday':
        return 'duties_sunday';
      case 'special':
        return 'duties_special';
      default:
        return 'duties_weekday';
    }
  }

  Future<DutyResult> searchDuty(String dayType, String dutyNo) async {
    try {
      final tableName = _getTableName(dayType);

      final response = await _client
          .from(tableName)
          .select()
          .ilike('duty_no', '%${dutyNo.trim()}%')
          .order('id')
          .limit(50);

      if (response.isEmpty) {
        return DutyResult.error("Duty '$dutyNo' not found in $dayType roster.");
      }

      final duties = response.map((row) => Duty.fromJson(row)).toList();

      final (totalKm, rakeGaps) = _calculateAnalysis(duties);

      return DutyResult.success(
        duties: duties,
        totalKm: totalKm,
        wefDate: '',
        remarks: '',
        rakeGaps: rakeGaps,
      );
    } catch (e) {
      return DutyResult.error('Error fetching duty: ${e.toString()}');
    }
  }

  (double, List<RakeGap>) _calculateAnalysis(List<Duty> duties) {
    double totalKm = 0;
    final rakeGaps = <RakeGap>[];
    final rakeTrips = <String, List<Duty>>{};

    for (var duty in duties) {
      if (duty.rakeNum.isNotEmpty) {
        rakeTrips[duty.rakeNum] ??= [];
        rakeTrips[duty.rakeNum]!.add(duty);

        final km = KmConstants.getKmReverse(duty.startStn, duty.endStn);
        totalKm += km;
      }
    }

    for (var rake in rakeTrips.keys) {
      final trips = rakeTrips[rake]!;
      trips.sort((a, b) {
        final timeA = KmConstants.timeToMinutes(a.startTime);
        final timeB = KmConstants.timeToMinutes(b.startTime);
        return timeA.compareTo(timeB);
      });

      for (var i = 0; i < trips.length - 1; i++) {
        final currentEnd = KmConstants.timeToMinutes(trips[i].endTime);
        final nextStart = KmConstants.timeToMinutes(trips[i + 1].startTime);

        final gap = currentEnd - nextStart;

        if (gap > 5) {
          rakeGaps.add(RakeGap(
            rakeId: rake,
            time: trips[i].endTime,
            location: trips[i].endStn,
            action: 'RELIEVER REQUIRED',
            gapMinutes: gap.abs().toInt(),
          ));
        }
      }
    }

    return (totalKm, rakeGaps);
  }

  Future<List<String>> getUniqueDutyNumbers(String dayType) async {
    try {
      final tableName = _getTableName(dayType);
      final response =
          await _client.from(tableName).select('duty_no').order('duty_no');

      final duties =
          response.map((row) => row['duty_no'] as String).toSet().toList();
      duties.sort((a, b) {
        final numA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        final numB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return numA.compareTo(numB);
      });

      return duties;
    } catch (e) {
      return [];
    }
  }

  Future<bool> uploadDuties(
      String dayType, List<Map<String, dynamic>> data) async {
    try {
      final tableName = _getTableName(dayType);

      if (data.isEmpty) return false;

      await _client.from(tableName).insert(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clearDuties(String dayType) async {
    try {
      final tableName = _getTableName(dayType);
      await _client.from(tableName).delete().neq('id', 0);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getStats() async {
    try {
      final weekday =
          await _client.from('duties_weekday').select('id, duty_no');
      final saturday =
          await _client.from('duties_saturday').select('id, duty_no');
      final sunday = await _client.from('duties_sunday').select('id, duty_no');
      final special =
          await _client.from('duties_special').select('id, duty_no');

      return {
        'weekday': {
          'rows': weekday.length,
          'duties': weekday.map((r) => r['duty_no']).toSet().length,
        },
        'saturday': {
          'rows': saturday.length,
          'duties': saturday.map((r) => r['duty_no']).toSet().length,
        },
        'sunday': {
          'rows': sunday.length,
          'duties': sunday.map((r) => r['duty_no']).toSet().length,
        },
        'special': {
          'rows': special.length,
          'duties': special.map((r) => r['duty_no']).toSet().length,
        },
      };
    } catch (e) {
      return {};
    }
  }
}
