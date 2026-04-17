import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'dart:convert';
import '../../services/duty_service.dart';
import '../../config/constants.dart';

class UploadTab extends StatefulWidget {
  const UploadTab({super.key});

  @override
  State<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends State<UploadTab> {
  String _selectedDayType = 'Weekday';
  PlatformFile? _selectedFile;
  List<List<dynamic>>? _previewData;
  bool _isUploading = false;
  String? _message;

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final csvString = utf8.decode(bytes, allowMalformed: true);
        final rows = const CsvToListConverter().convert(csvString);

        setState(() {
          _selectedFile = result.files.single;
          _previewData = rows;
          _message = null;
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error reading file: $e';
      });
    }
  }

  Future<void> _uploadData() async {
    if (_previewData == null || _previewData!.isEmpty) {
      setState(() => _message = 'No data to upload');
      return;
    }

    setState(() => _isUploading = true);

    try {
      final dutyService = DutyService();

      final dataRows = _previewData!.skip(1).toList();
      final duties = <Map<String, dynamic>>[];

      for (var row in dataRows) {
        if (row.length >= 14) {
          duties.add({
            'duty_no': row[0].toString(),
            'sign_on_time': row[1].toString(),
            'sign_on_loc': row[2].toString(),
            'sign_off_time': row[3].toString(),
            'sign_off_loc': row[4].toString(),
            'running_time': row[5].toString(),
            'trip_no': row[6].toString(),
            'station': row[7].toString(),
            'train': row[8].toString(),
            'dep_loc': row[9].toString(),
            'dep_time': row[10].toString(),
            'arr_loc': row[11].toString(),
            'arr_time': row[12].toString(),
            'rake': row[13].toString(),
          });
        }
      }

      await dutyService.clearDuties(_selectedDayType);
      final success = await dutyService.uploadDuties(_selectedDayType, duties);

      setState(() {
        _isUploading = false;
        _message = success
            ? 'Successfully uploaded ${duties.length} rows!'
            : 'Upload failed';
      });

      if (success) {
        setState(() {
          _selectedFile = null;
          _previewData = null;
        });
      }
    } catch (e) {
      setState(() {
        _isUploading = false;
        _message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDayTypeSelector(),
          const SizedBox(height: 20),
          _buildFilePicker(),
          const SizedBox(height: 20),
          if (_selectedFile != null) _buildPreview(),
          if (_message != null) ...[
            const SizedBox(height: 20),
            _buildMessage(),
          ],
          const SizedBox(height: 20),
          if (_selectedFile != null) _buildUploadButton(),
        ],
      ),
    );
  }

  Widget _buildDayTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFF00d4ff), size: 20),
              SizedBox(width: 8),
              Text(
                'SELECT DAY TYPE',
                style: TextStyle(
                  color: Color(0xFF00d4ff),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: AppConstants.dayTypes.map((type) {
              final isSelected = _selectedDayType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedDayType = type;
                      _selectedFile = null;
                      _previewData = null;
                    });
                  }
                },
                selectedColor: const Color(0xFF00d4ff),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.black : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilePicker() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E32),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF00d4ff).withOpacity(0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: GestureDetector(
        onTap: _pickFile,
        child: Column(
          children: [
            Icon(
              _selectedFile != null ? Icons.check_circle : Icons.upload_file,
              size: 48,
              color: _selectedFile != null
                  ? Colors.green
                  : const Color(0xFF00d4ff),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFile != null
                  ? _selectedFile!.name
                  : 'Tap to select CSV file',
              style: const TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            if (_selectedFile != null) ...[
              const SizedBox(height: 8),
              Text(
                '${_previewData?.length ?? 0} rows found',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.folder_open),
              label:
                  Text(_selectedFile != null ? 'Change File' : 'Browse Files'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF00d4ff),
                side: const BorderSide(color: Color(0xFF00d4ff)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    if (_previewData == null || _previewData!.isEmpty) {
      return const SizedBox.shrink();
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
          const Row(
            children: [
              Icon(Icons.table_chart, color: Color(0xFF00d4ff), size: 20),
              SizedBox(width: 8),
              Text(
                'DATA PREVIEW',
                style: TextStyle(
                  color: Color(0xFF00d4ff),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    const Color(0xFF00d4ff).withOpacity(0.2),
                  ),
                  columns: (_previewData!.first as List)
                      .asMap()
                      .entries
                      .map((e) => DataColumn(
                            label: Text(
                              'Col ${e.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                      .toList(),
                  rows: _previewData!.take(5).map((row) {
                    return DataRow(
                      cells: (row as List).map((cell) {
                        return DataCell(
                          Text(
                            cell.toString().length > 20
                                ? '${cell.toString().substring(0, 20)}...'
                                : cell.toString(),
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage() {
    final isError = _message!.toLowerCase().contains('error') ||
        _message!.toLowerCase().contains('failed');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isError
            ? Colors.red.withOpacity(0.2)
            : Colors.green.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isError ? Colors.red : Colors.green,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error : Icons.check_circle,
            color: isError ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _message!,
              style: TextStyle(
                color: isError ? Colors.red : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isUploading ? null : _uploadData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isUploading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cloud_upload),
                  const SizedBox(width: 8),
                  Text(
                    'UPLOAD TO ${_selectedDayType}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                ],
              ),
      ),
    );
  }
}
