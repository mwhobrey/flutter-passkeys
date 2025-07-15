# Web Platform Support for Corbado Auth Firebase

This document describes the web platform improvements made to the `corbado_auth_firebase` package to handle web-specific issues and provide better user experience.

## 🎯 **Improvements Made**

### **1. Platform-Agnostic User Agent Service**
- **File**: `lib/src/platform/user_agent_service.dart`
- **Purpose**: Provides consistent user agent handling across web and native platforms
- **Features**:
  - Graceful fallback when `ua_client_hints` package fails
  - Web-specific user agent parsing
  - Native platform support maintained

### **2. Web-Specific User Agent Implementation**
- **File**: `lib/src/platform/user_agent_web.dart`
- **Purpose**: Handles user agent detection for web browsers
- **Features**:
  - Modern browser API support (`navigator.userAgentData`)
  - Fallback to user agent string parsing
  - Browser and platform detection
  - Mobile/desktop detection

### **3. Native Platform User Agent Implementation**
- **File**: `lib/src/platform/user_agent_native.dart`
- **Purpose**: Maintains existing native platform functionality
- **Features**:
  - Uses `ua_client_hints` package for native platforms
  - Graceful error handling
  - Consistent API with web implementation

### **4. Web Configuration and Error Handling**
- **File**: `lib/src/platform/web_config.dart`
- **Purpose**: Provides web-specific configuration and error messages
- **Features**:
  - Passkey support detection
  - WebAuthn API availability checking
  - User-friendly error messages
  - Corbado Web SDK loading verification

## 🔧 **Technical Details**

### **User Agent Service Architecture**
```
UserAgentService
├── Web Platform → UserAgentWeb
└── Native Platform → UserAgentNative
```

### **Error Handling Flow**
1. Try to use `ua_client_hints` package
2. If it fails, fall back to platform-specific implementation
3. Provide user-friendly error messages for web platform
4. Maintain backward compatibility for native platforms

### **Web Platform Requirements**
- Modern browser with WebAuthn support
- Corbado Web SDK loaded (`bundle.js`)
- Secure context (HTTPS or localhost)

## 🚀 **Usage**

The improvements are transparent to existing code. The package will automatically:

1. **Detect the platform** (web vs native)
2. **Use appropriate user agent service**
3. **Handle errors gracefully** with platform-specific messages
4. **Maintain backward compatibility**

### **Example Usage**
```dart
final corbadoAuth = CorbadoAuthFirebase();
await corbadoAuth.init('us-central1');

// These calls now work on both web and native platforms
await corbadoAuth.signUpWithPasskey(
  email: 'user@example.com',
  fullName: 'John Doe',
);

await corbadoAuth.loginWithPasskey(
  email: 'user@example.com',
);
```

## 🐛 **Issues Resolved**

### **MissingPluginException for ua_client_hints**
- **Problem**: `ua_client_hints` package throws `MissingPluginException` on web
- **Solution**: Platform-agnostic user agent service with graceful fallback

### **Web Platform Compatibility**
- **Problem**: Web platform not fully supported
- **Solution**: Comprehensive web-specific implementations

### **Error Handling**
- **Problem**: Cryptic error messages on web
- **Solution**: User-friendly, platform-specific error messages

## 📋 **Testing**

### **Web Platform Testing**
1. Run on Chrome/Edge/Firefox with WebAuthn support
2. Test passkey registration and authentication
3. Verify error handling for unsupported browsers
4. Check user agent detection accuracy

### **Native Platform Testing**
1. Ensure existing functionality remains unchanged
2. Test on Android and iOS devices
3. Verify `ua_client_hints` integration still works

## 🤝 **Contributing**

When contributing to web platform support:

1. **Test on multiple browsers** (Chrome, Firefox, Safari, Edge)
2. **Verify native platform compatibility**
3. **Add appropriate error handling**
4. **Update documentation**

## 📚 **References**

- [WebAuthn API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Authentication_API)
- [User Agent Client Hints](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/userAgentData)
- [Corbado Web SDK](https://github.com/corbado/flutter-passkeys/releases) 