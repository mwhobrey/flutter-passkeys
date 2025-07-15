/// Stub implementation of UserAgentWeb for platforms where dart:html is not available
class UserAgentWeb {
  /// Get user agent information for web platform
  static Future<Map<String, dynamic>> getUserAgentInfo() async {
    return {
      'brands': [
        {'brand': 'Chrome', 'version': '120'},
        {'brand': 'Not=A?Brand', 'version': '99'},
      ],
      'mobile': false,
      'platform': 'Windows',
      'userAgent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    };
  }

  /// Get a formatted user agent string for Corbado
  static Future<String> getUserAgentString() async {
    return 'Chrome/120 (Windows; desktop)';
  }
}
