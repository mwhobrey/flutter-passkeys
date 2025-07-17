import 'package:flutter/foundation.dart';

/// Web-specific configuration for Corbado Auth Firebase
class WebConfig {
  /// Check if we're running on web platform
  static bool get isWeb => kIsWeb;

  /// Check if passkeys are supported on this platform
  static Future<bool> get isPasskeySupported async {
    if (!isWeb) return true;

    try {
      // Check if the WebAuthn API is available
      return _isWebAuthnSupported();
    } catch (e) {
      if (kDebugMode) {
        print('Error checking passkey support: $e');
      }
      return false;
    }
  }

  /// Check if WebAuthn is supported in the current browser
  static bool _isWebAuthnSupported() {
    // This would need to be implemented with proper web interop
    // For now, we'll assume it's supported in modern browsers
    return true;
  }

  /// Get web-specific error messages
  static String getWebErrorMessage(dynamic error) {
    if (error.toString().contains('MissingPluginException')) {
      return 'Web platform not fully supported. Please use a modern browser with WebAuthn support.';
    }
    if (error.toString().contains('NotSupportedError')) {
      return 'Passkeys are not supported in this browser. Please use a modern browser.';
    }
    if (error.toString().contains('NotAllowedError') ||
        error.toString().contains('cancelled') ||
        error.toString().contains('PasskeyAuthCancelledException')) {
      return 'Passkey operation was cancelled by the user.';
    }
    if (error.toString().contains('InvalidStateError')) {
      return 'Passkey operation failed. Please try again.';
    }
    if (error.toString().contains('UnknownErrorException')) {
      return 'Passkey operation failed. Please try again or contact support.';
    }
    if (error.toString().contains('FirebaseFunctionsException')) {
      if (error.toString().contains('UNKNOWN_ERROR')) {
        return 'Firebase function encountered an unknown error. This may be a server-side issue. Please try again or contact support.';
      }
      return 'Firebase function execution failed. Please check your configuration.';
    }
    return 'An error occurred during passkey operation: ${error.toString()}';
  }

  /// Check if the Corbado Web SDK is loaded
  static bool get isCorbadoWebSDKLoaded {
    if (!isWeb) return true;

    try {
      // This would need proper web interop to check
      // For now, we'll assume it's loaded if we're on web
      return true;
    } catch (e) {
      return false;
    }
  }
}
