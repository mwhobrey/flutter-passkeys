import 'package:flutter/material.dart';
import 'package:corbado_auth_firebase/corbado_auth_firebase.dart';
import 'package:corbado_auth_firebase/src/platform/web_config.dart';

/// Example demonstrating web platform improvements
class WebPlatformExample extends StatefulWidget {
  const WebPlatformExample({super.key});

  @override
  State<WebPlatformExample> createState() => _WebPlatformExampleState();
}

class _WebPlatformExampleState extends State<WebPlatformExample> {
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  bool _isLoading = false;
  String? _result;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _testWebPlatform() async {
    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      // Test web platform detection
      final isWeb = WebConfig.isWeb;
      final isPasskeySupported = await WebConfig.isPasskeySupported;
      
      _result = '''
Platform: ${isWeb ? 'Web' : 'Native'}
Passkey Support: ${isPasskeySupported ? 'Yes' : 'No'}
Email: ${_emailController.text}
Full Name: ${_fullNameController.text}
      '''.trim();
    } catch (e) {
      _error = WebConfig.getWebErrorMessage(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testSignUp() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _error = 'Please enter an email address';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      final corbadoAuth = CorbadoAuthFirebase();
      await corbadoAuth.init('us-central1');
      
      final token = await corbadoAuth.signUpWithPasskey(
        email: _emailController.text,
        fullName: _fullNameController.text.isNotEmpty 
            ? _fullNameController.text 
            : null,
      );
      
      _result = 'Sign up successful! Token: $token';
    } catch (e) {
      _error = WebConfig.getWebErrorMessage(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testSignIn() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _error = 'Please enter an email address';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _result = null;
      _error = null;
    });

    try {
      final corbadoAuth = CorbadoAuthFirebase();
      await corbadoAuth.init('us-central1');
      
      final token = await corbadoAuth.loginWithPasskey(
        email: _emailController.text,
      );
      
      _result = 'Sign in successful! Token: $token';
    } catch (e) {
      _error = WebConfig.getWebErrorMessage(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Platform Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _testWebPlatform,
              child: const Text('Test Web Platform'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _testSignUp,
              child: const Text('Test Sign Up'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _isLoading ? null : _testSignIn,
              child: const Text('Test Sign In'),
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_result != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _result!,
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              )
            else if (_error != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
} 