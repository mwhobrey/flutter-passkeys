import 'dart:html' as html;
import 'package:flutter/foundation.dart';

/// Web-specific implementation for user agent handling
class UserAgentWeb {
  /// Get user agent information for web platform
  static Future<Map<String, dynamic>> getUserAgentInfo() async {
    try {
      // Try to get user agent data if available (modern browsers)
      if (html.window.navigator.userAgentData != null) {
        final userAgentData = html.window.navigator.userAgentData!;
        return {
          'brands':
              userAgentData.brands
                  ?.map(
                    (brand) => {'brand': brand.brand, 'version': brand.version},
                  )
                  .toList() ??
              [],
          'mobile': userAgentData.mobile ?? false,
          'platform': userAgentData.platform ?? 'unknown',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to get userAgentData: $e');
      }
    }

    // Fallback to basic user agent string parsing
    final userAgent = html.window.navigator.userAgent;
    return _parseUserAgentString(userAgent);
  }

  /// Parse user agent string to extract basic information
  static Map<String, dynamic> _parseUserAgentString(String userAgent) {
    final lowerUA = userAgent.toLowerCase();

    // Detect browser
    String browser = 'unknown';
    String version = 'unknown';

    if (lowerUA.contains('chrome')) {
      browser = 'Chrome';
      final match = RegExp(r'chrome/(\d+)').firstMatch(lowerUA);
      if (match != null) {
        version = match.group(1) ?? 'unknown';
      }
    } else if (lowerUA.contains('firefox')) {
      browser = 'Firefox';
      final match = RegExp(r'firefox/(\d+)').firstMatch(lowerUA);
      if (match != null) {
        version = match.group(1) ?? 'unknown';
      }
    } else if (lowerUA.contains('safari')) {
      browser = 'Safari';
      final match = RegExp(r'version/(\d+)').firstMatch(lowerUA);
      if (match != null) {
        version = match.group(1) ?? 'unknown';
      }
    } else if (lowerUA.contains('edge')) {
      browser = 'Edge';
      final match = RegExp(r'edge/(\d+)').firstMatch(lowerUA);
      if (match != null) {
        version = match.group(1) ?? 'unknown';
      }
    }

    // Detect platform
    String platform = 'unknown';
    if (lowerUA.contains('windows')) {
      platform = 'Windows';
    } else if (lowerUA.contains('mac')) {
      platform = 'macOS';
    } else if (lowerUA.contains('linux')) {
      platform = 'Linux';
    } else if (lowerUA.contains('android')) {
      platform = 'Android';
    } else if (lowerUA.contains('ios')) {
      platform = 'iOS';
    }

    // Detect mobile
    final mobile =
        lowerUA.contains('mobile') ||
        lowerUA.contains('android') ||
        lowerUA.contains('iphone') ||
        lowerUA.contains('ipad');

    return {
      'brands': [
        {'brand': browser, 'version': version},
        {'brand': 'Not=A?Brand', 'version': '99'},
      ],
      'mobile': mobile,
      'platform': platform,
      'userAgent': userAgent,
    };
  }

  /// Get a formatted user agent string for Corbado
  static Future<String> getUserAgentString() async {
    final info = await getUserAgentInfo();
    final brands = info['brands'] as List<Map<String, dynamic>>;
    final mobile = info['mobile'] as bool;
    final platform = info['platform'] as String;

    // Format similar to what ua_client_hints would provide
    final brandStrings = brands
        .map((brand) => '${brand['brand']}/${brand['version']}')
        .join(' ');

    return '$brandStrings ($platform; ${mobile ? 'mobile' : 'desktop'})';
  }
}
