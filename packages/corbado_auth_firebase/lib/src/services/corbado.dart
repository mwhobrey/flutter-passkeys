import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:corbado_auth/corbado_auth.dart';
import 'package:corbado_auth_firebase/src/exceptions.dart';
import 'package:passkeys/types.dart';
import 'package:flutter/foundation.dart';

class CorbadoService {
  final FirebaseFunctions _functions;
  static final _functionOptions = HttpsCallableOptions(
    timeout: const Duration(seconds: 30),
  );

  String? _ongoingEmailOTPCodeID;

  static CorbadoService? _instance;

  CorbadoService(FirebaseFunctions functions) : _functions = functions;

  static CorbadoService getInstance() {
    _instance ??= CorbadoService(FirebaseFunctions.instance);
    return _instance!;
  }

  Future<RegisterRequestType> startSignUpWithPasskey(
    String email,
    String userAgent, {
    String? fullName,
  }) async {
    try {
      if (kDebugMode) {
        print(
            'Calling Firebase function: ext-authentication-corbado-startSignUpWithPasskey');
        print('Email: $email, UserAgent: $userAgent, FullName: $fullName');
      }

      final startResponse = await _functions
          .httpsCallable('ext-authentication-corbado-startSignUpWithPasskey',
              options: _functionOptions)
          .call<String>({
        'username': email,
        'userAgent': userAgent,
        if (fullName != null) 'fullName': fullName,
      });

      if (kDebugMode) {
        print('Start signup Firebase function succeeded');
      }

      final json = jsonDecode(startResponse.data) as Map<String, dynamic>;

      return StartRegisterResponse.fromJson(json).toPlatformType();
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        print('Start signup FirebaseFunctionsException: ${e.message}');
        print('Start signup FirebaseFunctionsException code: ${e.code}');
        print('Start signup FirebaseFunctionsException details: ${e.details}');
      }
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      if (kDebugMode) {
        print('Start signup unexpected error: $e');
      }
      rethrow;
    }
  }

  Future<String> finishSignUpWithPasskey(
    RegisterResponseType platformResponse,
    String userAgent,
  ) async {
    try {
      if (kDebugMode) {
        print('Finishing signup with userAgent: $userAgent');
      }

      final finishRequest = FinishRegisterRequest.fromRegisterCompleteRequest(
        platformResponse,
      );

      final signedChallenge = jsonEncode(finishRequest.toJson());
      if (kDebugMode) {
        print('Sending signedChallenge to Firebase function');
        print('signedChallenge length: ${signedChallenge.length}');
        print(
            'signedChallenge preview: ${signedChallenge.substring(0, 100)}...');
        print('finishRequest type: ${finishRequest.runtimeType}');
        print(
            'finishRequest.toJson() keys: ${finishRequest.toJson().keys.toList()}');

        // Log the full signedChallenge for debugging
        print('Full signedChallenge: $signedChallenge');

        // Log the platformResponse details
        print('PlatformResponse type: ${platformResponse.runtimeType}');
        if (platformResponse is RegisterResponseType) {
          print('RegisterResponseType details:');
          print('  id: ${platformResponse.id}');
          print('  rawId length: ${platformResponse.rawId.length}');
          print(
              '  clientDataJSON length: ${platformResponse.clientDataJSON.length}');
          print(
              '  attestationObject length: ${platformResponse.attestationObject.length}');
          print('  transports: ${platformResponse.transports}');
        }
      }

      if (kDebugMode) {
        print(
            'Calling Firebase function: ext-authentication-corbado-finishSignUpWithPasskey');
        print(
            'Function timeout: ${_functionOptions.timeout?.inSeconds} seconds');

        // Log the exact request being sent
        final requestData = {
          'signedChallenge': signedChallenge,
          'userAgent': userAgent
        };
        print('Request data keys: ${requestData.keys.toList()}');
        print(
            'Request data types: ${requestData.map((k, v) => MapEntry(k, v.runtimeType))}');
        print('UserAgent in request: ${requestData['userAgent']}');
        print(
            'SignedChallenge preview in request: ${(requestData['signedChallenge'] as String).substring(0, 100)}...');
      }

      final finishResponse = await _functions
          .httpsCallable('ext-authentication-corbado-finishSignUpWithPasskey',
              options: _functionOptions)
          .call<String>(
              {'signedChallenge': signedChallenge, 'userAgent': userAgent});

      if (kDebugMode) {
        print('Firebase function response received');
        print('Response data type: ${finishResponse.data.runtimeType}');
        print('Response data: ${finishResponse.data}');
      }

      return finishResponse.data;
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        print('FirebaseFunctionsException: ${e.message}');
        print('FirebaseFunctionsException code: ${e.code}');
        print('FirebaseFunctionsException details: ${e.details}');
        print('FirebaseFunctionsException stackTrace: ${e.stackTrace}');

        // Try to extract more details from the exception
        if (e.details != null) {
          print('Exception details type: ${e.details.runtimeType}');
          print('Exception details content: $e.details');
        }

        // Log additional context for debugging
        print(
            'Function name: ext-authentication-corbado-finishSignUpWithPasskey');
        print('UserAgent that was sent: $userAgent');

        // Check if this is a common error pattern
        if (e.message == 'UNKNOWN_ERROR') {
          print(
              '⚠️  UNKNOWN_ERROR detected - this is typically a server-side Corbado integration issue');
          print('💡  Check Firebase Functions logs for more details');
          print('💡  Verify Corbado project configuration');
          print(
              '💡  Check if the signedChallenge format is expected by Corbado');
        }
      }
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected error in finishSignUpWithPasskey: $e');
        print('Error type: ${e.runtimeType}');
        print('Error stack trace: ${StackTrace.current}');
      }
      rethrow;
    }
  }

  Future<AuthenticateRequestType> startLoginWithPasskey(
    String email,
    String userAgent, {
    bool conditional = false,
  }) async {
    try {
      final startResponse = await _functions
          .httpsCallable('ext-authentication-corbado-startLoginWithPasskey',
              options: _functionOptions)
          .call<String>({'username': email, 'userAgent': userAgent});
      final json = jsonDecode(startResponse.data) as Map<String, dynamic>;

      return StartLoginResponse.fromJson(json).toPlatformType(
        conditional: conditional,
      );
    } on FirebaseFunctionsException catch (e) {
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> finishLoginWithPasskey(
      AuthenticateResponseType platformResponse, String userAgent) async {
    try {
      final finishRequest = FinishLoginRequest.fromPlatformType(
        platformResponse,
      );
      final signedChallenge = jsonEncode(finishRequest.toJson());
      final finishResponse = await _functions
          .httpsCallable('ext-authentication-corbado-finishLoginWithPasskey',
              options: _functionOptions)
          .call<String>(
              {'signedChallenge': signedChallenge, 'userAgent': userAgent});

      return finishResponse.data;
    } on FirebaseFunctionsException catch (e) {
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> startLoginWithEmailOTP(String email) async {
    try {
      final startResponse = await _functions
          .httpsCallable('ext-authentication-corbado-startLoginWithEmailOTP',
              options: _functionOptions)
          .call<String>({'username': email});

      _ongoingEmailOTPCodeID = startResponse.data;

      return;
    } on FirebaseFunctionsException catch (e) {
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> finishLoginWithEmailOTP(String code) async {
    try {
      final finishResponse = await _functions
          .httpsCallable('ext-authentication-corbado-finishLoginWithEmailOTP',
              options: _functionOptions)
          .call<String>({'emailCodeID': _ongoingEmailOTPCodeID, 'code': code});

      return finishResponse.data;
    } on FirebaseFunctionsException catch (e) {
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<RegisterRequestType> startPasskeyAppend(
    String firebaseToken,
    String userAgent,
  ) async {
    try {
      final startResponse = await _functions
          .httpsCallable('ext-authentication-corbado-startPasskeyAppend',
              options: _functionOptions)
          .call<String>(
              {'firebaseToken': firebaseToken, 'userAgent': userAgent});
      final json = jsonDecode(startResponse.data) as Map<String, dynamic>;

      return StartRegisterResponse.fromJson(json).toPlatformType();
    } on FirebaseFunctionsException catch (e) {
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> finishPasskeyAppend(
    String firebaseToken,
    RegisterResponseType platformResponse,
    String userAgent,
  ) async {
    try {
      final finishRequest =
          FinishRegisterRequest.fromRegisterCompleteRequest(platformResponse);

      final signedChallenge = jsonEncode(finishRequest.toJson());
      final res = await _functions
          .httpsCallable('ext-authentication-corbado-finishPasskeyAppend',
              options: _functionOptions)
          .call<bool>({
        'firebaseToken': firebaseToken,
        'signedChallenge': signedChallenge,
        'userAgent': userAgent,
      });

      return res.data;
    } on FirebaseFunctionsException catch (e) {
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PasskeyInfo>> getPasskeys(String firebaseToken) async {
    try {
      final res = await _functions
          .httpsCallable('ext-authentication-corbado-getPasskeys',
              options: _functionOptions)
          .call<String>({'firebaseToken': firebaseToken});

      final json = jsonDecode(res.data) as List<dynamic>;
      return json
          .map((e) => PasskeyInfo.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FirebaseFunctionsException catch (e) {
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePasskey(String firebaseToken, String passkeyId) async {
    try {
      await _functions
          .httpsCallable('ext-authentication-corbado-deletePasskey',
              options: _functionOptions)
          .call<void>({'firebaseToken': firebaseToken, 'passkeyId': passkeyId});

      return;
    } on FirebaseFunctionsException catch (e) {
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String firebaseToken) async {
    try {
      await _functions
          .httpsCallable('ext-authentication-corbado-deleteUser',
              options: _functionOptions)
          .call<void>({'firebaseToken': firebaseToken});

      return;
    } on FirebaseFunctionsException catch (e) {
      throw _convertFirebaseFunctionsException(e);
    } catch (e) {
      rethrow;
    }
  }

  Exception _convertFirebaseFunctionsException(FirebaseFunctionsException e) {
    switch (e.message) {
      case 'UNKNOWN_USER':
        return UnknownUserException('');
      case 'NO_PASSKEY_AVAILABLE':
        return NoPasskeyForDeviceException();
      case 'USER_ALREADY_EXISTS':
        return UserAlreadyExistsException();
      case 'INVALID_USERNAME':
        return InvalidUsernameException();
      case 'INVALID_OTP_CODE':
        return InvalidOTPCodeException();
      case 'INVALID_AUTH_TOKEN':
        return InvalidAuthTokenException();
      case 'PASSKEY_ALREADY_EXISTS':
        return PasskeyAlreadyExistsException();
      case 'UNKNOWN_ERROR':
        return UnknownErrorException.fromFirebaseFunctionsException(e);
    }

    return UnknownErrorException.fromFirebaseFunctionsException(e);
  }
}
