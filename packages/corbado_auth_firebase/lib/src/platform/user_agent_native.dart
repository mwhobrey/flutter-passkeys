import 'package:ua_client_hints/ua_client_hints.dart';

/// Native platform implementation for user agent handling
class UserAgentNative {
  /// Get user agent information for native platforms
  static Future<Map<String, dynamic>> getUserAgentInfo() async {
    try {
      final ua = await userAgent();
      return {
        'userAgent': ua,
        'platform': 'native',
      };
    } catch (e) {
      return {
        'userAgent': 'Unknown',
        'platform': 'native',
        'error': e.toString(),
      };
    }
  }

  /// Get user agent string for Corbado
  static Future<String> getUserAgentString() async {
    try {
      return await userAgent();
    } catch (e) {
      return 'Unknown/1.0 (native; desktop)';
    }
  }
} 