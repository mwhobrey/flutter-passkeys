library corbado_auth_firebase;

export 'src/corbado_auth_firebase.dart';

// Re-export types from corbado_auth for convenience
export 'package:corbado_auth/corbado_auth.dart'
    show PasskeyInfo, UnknownUserException, NoPasskeyForDeviceException;

// Re-export exception types from passkeys package
export 'package:passkeys/exceptions.dart' show PasskeyAuthCancelledException;

// Platform-specific exports for advanced usage
export 'src/platform/user_agent_service.dart';
export 'src/platform/web_config.dart';
