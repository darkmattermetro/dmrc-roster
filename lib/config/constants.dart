class KmConstants {
  static const Map<String, double> kmMap = {
    'DDSC DN|KKDA DN': 26.22,
    'DDSC DN PF|KKDA DN': 26.22,
    'DDSC DN PF STABLE|KKDA DN': 26.22,
    'DDSC SDG|PBGW UP': 12.26,
    'DDSC SDG STABLE|PBGW UP': 12.26,
    'DDSC SDG|KKDA DN': 26.75,
    'DDSC SDG STABLE|KKDA DN': 26.75,
    'DDSC|DDSC SDG STABLE': 0.5,
    'DDSC|DDSC SDG': 0.5,
    'IPE|PBGW UP': 34.92,
    'IPE|KKDA DN': 3.16,
    'KKDA DN|SAKP': 27.26,
    'KKDA DN|MUPR DN': 7.3,
    'KKDA DN|MKPR': 20.67,
    'KKDA DN|PBGW DN': 29.10,
    'KKDA UP|PBGW UP': 38.08,
    'KKDA UP|IPE': 3.16,
    'KKDA UP|NZM': 13.26,
    'MKPR|KKDA UP': 20.67,
    'MKPR|PBGW DN': 8.43,
    'MKPR|SAKP': 6.59,
    'MKPR|MUPR': 13.36,
    'MUPR|SVVR DN SDG': 4.0,
    'MUPR|MUPR 4TH PF': 1.0,
    'MUPR|MUPR 4TH SDG': 1.4,
    'MUPR 3RD SDG|KKDA UP': 7.7,
    'MUPR 4TH|KKDA UP': 7.3,
    'PBGW DN|DDSC DN PF STABLE': 11.86,
    'PBGW DN|DDSC DN PF': 11.86,
    'PBGW DN|DDSC DN': 11.86,
    'PBGW DN|DDSC SDG STABLE': 12.26,
    'PBGW DN|DDSC SDG': 12.26,
    'PBGW DN|IPE': 34.92,
    'PBGW DN|KKDA DN': 38.08,
    'PBGW UP|KKDA UP': 29.10,
    'PBGW UP|MUPR': 21.79,
    'PBGW UP|MKPR': 8.43,
    'SVVR DN|KKDA UP': 11.91,
    'NZM|MVPO DN': 6.31,
    'MVPO DN|KKDA UP': 6.31,
    'SVVR DN|MUPR': 4.0,
    'MVPO DN|MUPR': 6.0,
    'SAKP 3RD|KKDA DN': 27.26,
    'SAKP|KKDA DN': 27.26,
    'DDSC DN|KKDA UP': 26.22,
    'DDSC SDG|KKDA UP': 26.75,
  };

  static int timeToMinutes(String timeStr) {
    if (timeStr.isEmpty || !timeStr.contains(':')) return -1;
    final parts = timeStr.split(':');
    return ((int.tryParse(parts[0]) ?? 0) * 60) + (int.tryParse(parts[1]) ?? 0);
  }

  static double getKm(String from, String to) {
    final key = '${from.toUpperCase().trim()}|${to.toUpperCase().trim()}';
    return kmMap[key] ?? 0;
  }

  static double getKmReverse(String from, String to) {
    final key1 = '${from.toUpperCase().trim()}|${to.toUpperCase().trim()}';
    final key2 = '${to.toUpperCase().trim()}|${from.toUpperCase().trim()}';
    return kmMap[key1] ?? kmMap[key2] ?? 0;
  }
}

class AppConstants {
  static const String appName = 'DMRC Line 7 Roster Master';
  static const String appVersion = '1.0.0';

  static const List<String> dayTypes = [
    'Weekday',
    'Saturday',
    'Sunday',
    'Special'
  ];

  static const List<String> stations = [
    'DDSC DN',
    'DDSC SDG',
    'KKDA DN',
    'KKDA UP',
    'PBGW DN',
    'PBGW UP',
    'MKPR',
    'MUPR',
    'MUPR DN',
    'IPE',
    'SAKP',
    'SAKP 3RD',
    'SVVR DN',
    'MVPO DN',
    'NZM',
  ];
}
