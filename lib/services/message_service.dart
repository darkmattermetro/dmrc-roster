import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/message.dart';

class MessageService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<Message> getMessages() async {
    try {
      final response = await _client
          .from('messages')
          .select()
          .maybeSingle();

      if (response == null) {
        return Message.empty();
      }

      return Message.fromJson(response);
    } catch (e) {
      return Message.empty();
    }
  }

  Future<bool> updateMessages({
    required String userMessage,
    required String popupMessage,
    required String updatedBy,
  }) async {
    try {
      final response = await _client
          .from('messages')
          .update({
            'user_message': userMessage,
            'popup_message': popupMessage,
            'updated_at': DateTime.now().toIso8601String(),
            'updated_by': updatedBy,
          })
          .eq('id', 1);

      return response != null;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getMessageLogs() async {
    try {
      final response = await _client
          .from('message_logs')
          .select()
          .order('timestamp', ascending: false)
          .limit(50);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }

  Future<bool> addLog({
    required String empId,
    required String empName,
    required String action,
    required String details,
  }) async {
    try {
      await _client.from('message_logs').insert({
        'emp_id': empId,
        'emp_name': empName,
        'action': action,
        'details': details,
        'timestamp': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
