/// Stub implementation of UserAgentWeb for platforms where dart:html is not available
class UserAgentWeb {
  /// Get user agent information for web platform
  static Future<Map<String, dynamic>> getUserAgentInfo() async {
    return {
      'brands': [
        {'brand': 'Unknown', 'version': '1.0'},
        {'brand': 'Not=A?Brand', 'version': '99'},
      ],
      'mobile': false,
      'platform': 'unknown',
      'userAgent': 'Unknown/1.0',
    };
  }

  /// Get a formatted user agent string for Corbado
  static Future<String> getUserAgentString() async {
    return 'Unknown/1.0 (unknown; desktop)';
  }
} 