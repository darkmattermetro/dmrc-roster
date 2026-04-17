import 'package:flutter/material.dart';
import '../../services/message_service.dart';
import '../../models/message.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({super.key});

  @override
  State<MessageTab> createState() => _MessageTabState();
}

class _MessageTabState extends State<MessageTab> {
  final _userMessageController = TextEditingController();
  final _popupMessageController = TextEditingController();
  bool _isLoading = true;
  bool _isSaving = false;
  Message? _currentMessage;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _userMessageController.dispose();
    _popupMessageController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    final messageService = MessageService();
    final messages = await messageService.getMessages();
    
    if (mounted) {
      setState(() {
        _currentMessage = messages;
        _userMessageController.text = messages.userMessage;
        _popupMessageController.text = messages.popupMessage;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveMessages() async {
    setState(() => _isSaving = true);

    final messageService = MessageService();
    final success = await messageService.updateMessages(
      userMessage: _userMessageController.text,
      popupMessage: _popupMessageController.text,
      updatedBy: 'admin',
    );

    if (mounted) {
      setState(() => _isSaving = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Messages updated!' : 'Failed to update'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success) {
        await messageService.addLog(
          empId: 'admin',
          empName: 'Admin',
          action: 'UPDATE_MESSAGES',
          details: 'Updated messages',
        );
      }
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
          _buildPreviewCard(),
          const SizedBox(height: 24),
          _buildEditForm(),
          const SizedBox(height: 24),
          _buildSaveButton(),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
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
              Icon(Icons.preview, color: Color(0xFF00d4ff), size: 20),
              SizedBox(width: 8),
              Text(
                'PREVIEW',
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
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Text('📢', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _userMessageController.text.isEmpty
                        ? 'No message set'
                        : _userMessageController.text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
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
              Icon(Icons.edit, color: Color(0xFF00d4ff), size: 20),
              SizedBox(width: 8),
              Text(
                'EDIT MESSAGES',
                style: TextStyle(
                  color: Color(0xFF00d4ff),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'User Message Banner',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _userMessageController,
            maxLines: 3,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter announcement message...',
              hintStyle: TextStyle(color: Colors.white30),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          const Text(
            'Popup Message',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _popupMessageController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Enter popup message (optional)...',
              hintStyle: TextStyle(color: Colors.white30),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveMessages,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  SizedBox(width: 8),
                  Text(
                    'UPDATE MESSAGES',
                    style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                ],
              ),
      ),
    );
  }
}
