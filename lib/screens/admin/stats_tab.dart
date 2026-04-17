import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/duty_service.dart';

class StatsTab extends StatefulWidget {
  const StatsTab({super.key});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final dutyService = DutyService();
    final stats = await dutyService.getStats();
    
    if (mounted) {
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF00d4ff)),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCards(),
          const SizedBox(height: 24),
          _buildChart(),
          const SizedBox(height: 24),
          _buildDutyList(),
        ],
      ),
    );
  }

  Widget _buildOverviewCards() {
    if (_stats == null) return const SizedBox.shrink();

    final totalRows = (_stats!['weekday']?['rows'] ?? 0) +
        (_stats!['saturday']?['rows'] ?? 0) +
        (_stats!['sunday']?['rows'] ?? 0) +
        (_stats!['special']?['rows'] ?? 0);

    final totalDuties = (_stats!['weekday']?['duties'] ?? 0) +
        (_stats!['saturday']?['duties'] ?? 0) +
        (_stats!['sunday']?['duties'] ?? 0) +
        (_stats!['special']?['duties'] ?? 0);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Total Rows',
                value: totalRows.toString(),
                icon: Icons.table_chart,
                color: const Color(0xFF00d4ff),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Total Duties',
                value: totalDuties.toString(),
                icon: Icons.work,
                color: const Color(0xFFa855f7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                title: 'Day Types',
                value: '4',
                icon: Icons.calendar_today,
                color: const Color(0xFF22c55e),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                title: 'Status',
                value: 'Active',
                icon: Icons.check_circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChart() {
    if (_stats == null) return const SizedBox.shrink();

    final weekday = _stats!['weekday']?['rows'] ?? 0;
    final saturday = _stats!['saturday']?['rows'] ?? 0;
    final sunday = _stats!['sunday']?['rows'] ?? 0;
    final special = _stats!['special']?['rows'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DATA DISTRIBUTION',
            style: TextStyle(
              color: Color(0xFF00d4ff),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    value: weekday.toDouble(),
                    title: 'Weekday',
                    color: const Color(0xFF00d4ff),
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: saturday.toDouble(),
                    title: 'Saturday',
                    color: const Color(0xFFa855f7),
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: sunday.toDouble(),
                    title: 'Sunday',
                    color: const Color(0xFF22c55e),
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  PieChartSectionData(
                    value: special.toDouble(),
                    title: 'Special',
                    color: const Color(0xFFff6b35),
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDutyList() {
    if (_stats == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DUTIES BY DAY TYPE',
            style: TextStyle(
              color: Color(0xFF00d4ff),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          _buildDayTypeRow('Weekday', _stats!['weekday']),
          _buildDayTypeRow('Saturday', _stats!['saturday']),
          _buildDayTypeRow('Sunday', _stats!['sunday']),
          _buildDayTypeRow('Special', _stats!['special']),
        ],
      ),
    );
  }

  Widget _buildDayTypeRow(String dayType, Map<String, dynamic>? data) {
    if (data == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: _getColorForDayType(dayType),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              dayType,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Text(
            '${data['duties'] ?? 0} duties',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(width: 16),
          Text(
            '${data['rows'] ?? 0} rows',
            style: const TextStyle(color: Color(0xFF00d4ff)),
          ),
        ],
      ),
    );
  }

  Color _getColorForDayType(String dayType) {
    switch (dayType.toLowerCase()) {
      case 'weekday':
        return const Color(0xFF00d4ff);
      case 'saturday':
        return const Color(0xFFa855f7);
      case 'sunday':
        return const Color(0xFF22c55e);
      case 'special':
        return const Color(0xFFff6b35);
      default:
        return Colors.grey;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
