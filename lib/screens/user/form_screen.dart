import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  bool _hasForm = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkForm();
  }

  Future<void> _checkForm() async {
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      setState(() {
        _hasForm = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FORMS',
          style: TextStyle(
            color: Color(0xFF00d4ff),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00d4ff)),
            )
          : _hasForm
              ? _buildForm()
              : _buildNoForm(),
    );
  }

  Widget _buildNoForm() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFa855f7).withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.article_outlined,
                size: 64,
                color: Color(0xFFa855f7),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Active Form',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'There is no active form available at the moment.\nCheck back later.',
              textAlign: TextAlign.center,
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

  Widget _buildForm() {
    return const Center(
      child: Text(
        'Form coming soon...',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
