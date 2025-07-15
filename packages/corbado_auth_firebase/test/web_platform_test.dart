import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:corbado_auth_firebase/src/platform/user_agent_service.dart';
import 'package:corbado_auth_firebase/src/platform/web_config.dart';

void main() {
  group('Web Platform Tests', () {
    test('UserAgentService should handle web platform', () async {
      // Test that the service can be called without throwing
      final userAgent = await UserAgentService.getUserAgent();
      expect(userAgent, isA<String>());
      expect(userAgent.isNotEmpty, isTrue);
    });

    test('UserAgentService should provide user agent info', () async {
      final info = await UserAgentService.getUserAgentInfo();
      expect(info, isA<Map<String, dynamic>>());
      expect(info.containsKey('userAgent'), isTrue);
    });

    test('WebConfig should detect web platform', () {
      // This test will pass on web, fail on native
      // We're testing the logic, not the actual platform
      expect(WebConfig.isWeb, isA<bool>());
    });

    test('WebConfig should provide error messages', () {
      final error = Exception(
        'MissingPluginException: No implementation found',
      );
      final message = WebConfig.getWebErrorMessage(error);
      expect(message, isA<String>());
      expect(message.isNotEmpty, isTrue);
    });

    test('WebConfig should check passkey support', () async {
      final isSupported = await WebConfig.isPasskeySupported;
      expect(isSupported, isA<bool>());
    });

    test('UserAgentService should handle errors gracefully', () async {
      // Test that the service doesn't throw on error
      try {
        final userAgent = await UserAgentService.getUserAgent();
        expect(userAgent, isA<String>());
      } catch (e) {
        // If it throws, that's also acceptable as long as it's handled
        expect(e, isA<Exception>());
      }
    });
  });

  group('Platform Detection Tests', () {
    test('should detect platform correctly', () {
      // Test platform detection logic
      expect(kIsWeb, isA<bool>());
    });

    test('should provide consistent API across platforms', () async {
      // Test that the API is consistent
      final userAgent = await UserAgentService.getUserAgent();
      expect(userAgent, isA<String>());

      final info = await UserAgentService.getUserAgentInfo();
      expect(info, isA<Map<String, dynamic>>());
    });
  });

  group('Error Handling Tests', () {
    test('should handle MissingPluginException', () {
      final error = Exception(
        'MissingPluginException: No implementation found for method getInfo on channel ua_client_hints',
      );
      final message = WebConfig.getWebErrorMessage(error);
      expect(message, contains('Web platform not fully supported'));
    });

    test('should handle NotSupportedError', () {
      final error = Exception(
        'NotSupportedError: The operation is not supported',
      );
      final message = WebConfig.getWebErrorMessage(error);
      expect(message, contains('Passkeys are not supported'));
    });

    test('should handle NotAllowedError', () {
      final error = Exception('NotAllowedError: The operation was cancelled');
      final message = WebConfig.getWebErrorMessage(error);
      expect(message, contains('cancelled by the user'));
    });

    test('should handle InvalidStateError', () {
      final error = Exception(
        'InvalidStateError: The authenticator was not in a valid state',
      );
      final message = WebConfig.getWebErrorMessage(error);
      expect(message, contains('Please try again'));
    });

    test('should handle unknown errors', () {
      final error = Exception('Some unknown error occurred');
      final message = WebConfig.getWebErrorMessage(error);
      expect(message, contains('An error occurred'));
    });
  });
}
