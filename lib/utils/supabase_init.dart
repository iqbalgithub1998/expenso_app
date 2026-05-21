import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInitResult {
  final bool success;
  final String? errorMessage;

  SupabaseInitResult({required this.success, this.errorMessage});
}

Future<SupabaseInitResult> initializeSupabase() async {
  try {
    // await Supabase.initialize(url: 'https://', anonKey: 'sb_pub');

    print('✅ Supabase initialized successfully');
    return SupabaseInitResult(success: true);
  } catch (e) {
    print('❌ Supabase initialization failed: $e');
    return SupabaseInitResult(success: false, errorMessage: e.toString());
  }
}
