import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInitResult {
  final bool success;
  final String? errorMessage;

  SupabaseInitResult({required this.success, this.errorMessage});
}

Future<SupabaseInitResult> initializeSupabase() async {
  try {
    // await Supabase.initialize(url: 'https://', anonKey: 'sb_pub');
    await Supabase.initialize(
      url: 'https://oxwkbiismvuoyebapzmh.supabase.co',
      anonKey: 'sb_publishable_kBLz54GiAfNou9C2DXoR8w_4xSdymQr',
    );

    print('✅ Supabase initialized successfully');
    return SupabaseInitResult(success: true);
  } catch (e) {
    print('❌ Supabase initialization failed: $e');
    return SupabaseInitResult(success: false, errorMessage: e.toString());
  }
}
