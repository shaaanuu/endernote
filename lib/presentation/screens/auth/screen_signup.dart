import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../services/firebase_auth_service.dart';

class ScreenSignUp extends StatelessWidget {
  ScreenSignUp({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: ListView(
          children: [
            const Text('Sign up with email and password below'),
            const SizedBox(height: 18),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text;
                final password = _passwordController.text;
                final name = _usernameController.text;

                if (email.isEmpty || password.isEmpty || name.isEmpty) {
                  _showErrorDialog(
                    context,
                    "Seriously...? Fill it idiot...",
                  );
                  return;
                }

                try {
                  await _authService.signUp(email, password, name);

                  final userData = await _authService.signIn(email, password);

                  if (userData.containsKey('idToken') &&
                      userData['idToken'] != null) {
                    await _secureStorage.write(
                      key: "idToken",
                      value: userData['idToken'],
                    );
                    await _secureStorage.write(
                      key: "refreshToken",
                      value: userData['refreshToken'],
                    );
                    await _secureStorage.write(
                      key: 'email',
                      value: email,
                    );

                    Navigator.of(context).pushReplacementNamed('/home');

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Color(0xFF181825),
                        content: Text(
                          'Please restart the app to see changes.',
                          style: TextStyle(color: Color(0xFFbac2de)),
                        ),
                      ),
                    );
                  } else {
                    throw Exception("idToken is missing or null in userData");
                  }
                } catch (error) {
                  _showErrorDialog(context, error.toString());
                }
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/sign_in'),
              child: const Text('Already have an account? Sign in'),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
