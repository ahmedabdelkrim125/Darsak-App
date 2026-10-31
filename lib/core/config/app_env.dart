import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppEnv {
  AppEnv._();

  static const String _urlKey = 'SUPABASE_URL';
  static const String _publishableKey = 'SUPABASE_PUBLISHABLE_KEY';

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
    _read(_urlKey);
    if (_read(_publishableKey).startsWith('sb_secret_')) {
      throw StateError('A secret key must never be bundled in the app');
    }
  }

  static String get supabaseUrl {
    final value = _read(_urlKey);
    return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }

  static String get publishableKey => _read(_publishableKey);

  static String get restUrl => '$supabaseUrl/rest/v1';

  static String get authUrl => '$supabaseUrl/auth/v1';

  static String get storageUrl => '$supabaseUrl/storage/v1';

  static String get functionsUrl => '$supabaseUrl/functions/v1';

  static String _read(String key) {
    final value = dotenv.maybeGet(key)?.trim() ?? '';
    if (value.isEmpty) throw StateError('Missing $key in .env');
    return value;
  }
}
