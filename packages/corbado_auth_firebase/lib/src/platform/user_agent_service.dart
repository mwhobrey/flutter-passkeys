import 'package:flutter/foundation.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

// Platform-specific implementations
import 'user_agent_native.dart';
import 'user_agent_web_stub.dart' if (dart.library.html) 'user_agent_web.dart';

/// Platform-agnostic user agent service
class UserAgentService {
  /// Get user agent information for the current platform
  static Future<Map<String, dynamic>> getUserAgentInfo() async {
    if (kIsWeb) {
      return UserAgentWeb.getUserAgentInfo();
    } else {
      return UserAgentNative.getUserAgentInfo();
    }
  }

  /// Get user agent string for Corbado
  static Future<String> getUserAgentString() async {
    if (kIsWeb) {
      return UserAgentWeb.getUserAgentString();
    } else {
      return UserAgentNative.getUserAgentString();
    }
  }

  /// Get user agent using the ua_client_hints package with fallback
  static Future<String> getUserAgent() async {
    try {
      // Try to use the ua_client_hints package
      final ua = await userAgent();
      if (kDebugMode) {
        print('ua_client_hints succeeded: $ua');
      }
      return ua;
    } catch (e) {
      if (kDebugMode) {
        print('ua_client_hints failed, using fallback: $e');
      }

      // Fallback to our platform-specific implementation
      try {
        final fallbackUa = await getUserAgentString();
        if (kDebugMode) {
          print('Platform-specific implementation succeeded: $fallbackUa');
        }
        return fallbackUa;
      } catch (e) {
        if (kDebugMode) {
          print(
              'Platform-specific implementation failed, using hardcoded fallback: $e');
        }

        // Final fallback - return a realistic user agent string
        final hardcodedUa = kIsWeb ? 'Chrome/120 (Windows; desktop)' : 'Unknown/1.0 (native; desktop)';
        if (kDebugMode) {
          print('Using hardcoded fallback: $hardcodedUa');
        }
        return hardcodedUa;
      }
    }
  }
}
