import 'package:flutter/material.dart';
import '../services/duty_service.dart';
import '../models/duty.dart';
import '../config/constants.dart';

class DutyResultScreen extends StatefulWidget {
  final String dayType;
  final String dutyNo;

  const DutyResultScreen({
    super.key,
    required this.dayType,
    required this.dutyNo,
  });

  @override
  State<DutyResultScreen> createState() => _DutyResultScreenState();
}

class _DutyResultScreenState extends State<DutyResultScreen> {
  DutyResult? _result;
  bool _isLoading = true;
  bool _showRakeAnalysis = true;

  @override
  void initState() {
    super.initState();
    _fetchDuty();
  }

  Future<void> _fetchDuty() async {
    final dutyService = DutyService();
    final result = await dutyService.searchDuty(widget.dayType, widget.dutyNo);
    
    if (mounted) {
      setState(() {
        _result = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: _buildAppBar(),
      body: _isLoading 
          ? _buildLoading()
          : _result?.error != null
              ? _buildError()
              : _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1a1a2e),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DUTY ${widget.dutyNo}',
            style: const TextStyle(
              color: Color(0xFF00d4ff),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          Text(
            widget.dayType.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            _showRakeAnalysis ? Icons.route : Icons.route_outlined,
            color: _showRakeAnalysis ? const Color(0xFF00d4ff) : Colors.white54,
          ),
          onPressed: () {
            setState(() => _showRakeAnalysis = !_showRakeAnalysis);
          },
          tooltip: 'Toggle Rake Analysis',
        ),
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white54),
          onPressed: _fetchDuty,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF00d4ff)),
          SizedBox(height: 16),
          Text(
            'Loading duty data...',
            style: TextStyle(color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 64,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _result!.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different duty number or day type',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    final duties = _result!.duties;
    final totalTrips = duties.where((d) => d.rake.isNotEmpty).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildSummaryCards(totalTrips),
          const SizedBox(height: 20),
          if (_showRakeAnalysis) ...[
            _buildRakeAnalysisSection(),
            const SizedBox(height: 20),
          ],
          _buildTripTable(),
          const SizedBox(height: 20),
          _buildRakeBreakdown(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(int totalTrips) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'TOTAL KM',
            value: _result!.totalKm.toStringAsFixed(2),
            icon: Icons.straighten,
            color: const Color(0xFF00d4ff),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'TRIPS',
            value: totalTrips.toString(),
            icon: Icons.train,
            color: const Color(0xFFa855f7),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'X POINTS',
            value: (_result!.rakeGaps.length).toString(),
            icon: Icons.warning_amber,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildRakeAnalysisSection() {
    if (_result!.rakeGaps.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No Relievers Required',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'All rakes are continuous',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.red, size: 24),
              SizedBox(width: 12),
              Text(
                'Reliever Points (X)',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...(_result!.rakeGaps.map((gap) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'X',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${gap.rakeId} @ ${gap.location}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${gap.action} • Gap: ${gap.gapMinutes} min',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    gap.time,
                    style: const TextStyle(
                      color: Color(0xFF00d4ff),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ))),
        ],
      ),
    );
  }

  Widget _buildTripTable() {
    final duties = _result!.duties;
    final rakeGroups = <String, List<Duty>>{};

    for (var duty in duties) {
      if (duty.rake.isNotEmpty) {
        rakeGroups[duty.rake] ??= [];
        rakeGroups[duty.rake]!.add(duty);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00d4ff), Color(0xFFa855f7)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                _TableHeader(title: '#', flex: 1),
                _TableHeader(title: 'FROM', flex: 2),
                _TableHeader(title: 'TO', flex: 2),
                _TableHeader(title: 'TIME', flex: 2),
                _TableHeader(title: 'RAKE', flex: 1),
                _TableHeader(title: 'KM', flex: 1),
              ],
            ),
          ),
          ...List.generate(duties.length, (i) {
            final duty = duties[i];
            final isRakeTrip = duty.rake.isNotEmpty;
            final km = isRakeTrip 
                ? KmConstants.getKmReverse(duty.depLoc, duty.arrLoc) 
                : 0.0;
            
            final hasGap = _result!.rakeGaps.any((g) => 
                g.rakeId == duty.rake && g.time == duty.arrTime);

            return Container(
              decoration: BoxDecoration(
                color: hasGap ? Colors.red.withOpacity(0.3) : null,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              child: Row(
                children: [
                  _TableCell(title: '${i + 1}', flex: 1),
                  _TableCell(title: duty.depLoc, flex: 2, isBold: true),
                  _TableCell(title: duty.arrLoc, flex: 2, isBold: true),
                  _TableCell(
                    title: duty.depTime,
                    flex: 2,
                    color: const Color(0xFFff6b35),
                    isBold: true,
                  ),
                  _TableCell(
                    title: isRakeTrip ? duty.rake : '-',
                    flex: 1,
                    color: isRakeTrip ? const Color(0xFF00d4ff) : Colors.white30,
                  ),
                  _TableCell(
                    title: km > 0 ? km.toStringAsFixed(1) : '-',
                    flex: 1,
                    color: km > 0 ? const Color(0xFF22c55e) : Colors.white30,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRakeBreakdown() {
    final duties = _result!.duties;
    final rakeGroups = <String, List<Duty>>{};

    for (var duty in duties) {
      if (duty.rake.isNotEmpty) {
        rakeGroups[duty.rake] ??= [];
        rakeGroups[duty.rake]!.add(duty);
      }
    }

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
            'RAKE BREAKDOWN',
            style: TextStyle(
              color: Color(0xFF00d4ff),
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          ...rakeGroups.entries.map((entry) {
            final rakeKm = entry.value.fold<double>(
              0, 
              (sum, d) => sum + KmConstants.getKmReverse(d.depLoc, d.arrLoc)
            );
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00d4ff),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      entry.key,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${entry.value.length} trips',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                  Text(
                    '${rakeKm.toStringAsFixed(2)} KM',
                    style: const TextStyle(
                      color: Color(0xFF22c55e),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              letterSpacing: 1,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String title;
  final int flex;

  const _TableHeader({required this.title, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 11,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String title;
  final int flex;
  final Color? color;
  final bool isBold;

  const _TableCell({
    required this.title,
    required this.flex,
    this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}
