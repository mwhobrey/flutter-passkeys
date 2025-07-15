# Changelog

## 2.0.6 - 2024-07

### 🎉 **Added**
* **Web Platform Support**: Comprehensive web platform support with graceful fallbacks
* **Platform-Agnostic User Agent Service**: New `UserAgentService` that handles both web and native platforms
* **Web-Specific Error Handling**: User-friendly error messages for web platform issues
* **Web Configuration**: New `WebConfig` class for web-specific configuration and validation
* **Enhanced Documentation**: Detailed documentation for web platform usage

### 🔧 **Improved**
* **Error Handling**: Better error messages for `MissingPluginException` and other web-specific issues
* **User Agent Detection**: Robust user agent detection with fallbacks for unsupported browsers
* **Platform Detection**: Automatic platform detection with appropriate implementations
* **Backward Compatibility**: All existing functionality remains unchanged for native platforms

### 🐛 **Fixed**
* **MissingPluginException**: Fixed `ua_client_hints` MissingPluginException on web platform
* **Web Platform Compatibility**: Resolved web platform compatibility issues
* **Error Messages**: Improved error messages for better user experience

### 📚 **Documentation**
* Added `WEB_PLATFORM.md` with comprehensive web platform documentation
* Updated examples to demonstrate web platform improvements
* Added web platform tests for validation

### 🧪 **Testing**
* Added comprehensive web platform tests
* Created web platform example application
* Enhanced error handling test coverage

## 2.0.6
* Update dependencies

## 2.0.5
* Bump versions of passkeys, corbado_auth and corbado_frontend_api_client

## 2.0.4
* Pass correct userAgent to passkey related firebase functions

## 2.0.3
* Added excludeCredentials support

## 2.0.2
* Updated docs
* Make Firebase region configurable

## 2.0.1
* Update docs

## 2.0.0
* Initial stable release

## 2.0.0-dev.3
* Bump passkeys version

## 2.0.0-dev.2
* Initial open source release.