import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://pmjiopmuvkkwsaurtzjo.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBtamlvcG11dmtrd3NhdXJ0empvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY0MTE2MDQsImV4cCI6MjA5MTk4NzYwNH0.br5RGBnFW3E2D16qKxRrvPhcwL3wStZtf21ARzAf_NA';
  
  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
  
  static SupabaseClient get client => Supabase.instance.client;
}
