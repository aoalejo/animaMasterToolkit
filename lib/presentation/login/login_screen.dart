import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

import 'package:flutter/material.dart';

class LoginScreen {
  static Future<void> showLoginBottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SignInScreen(
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              Navigator.pop(context);
            }),
          ],
          auth: auth.FirebaseAuth.instance,
          providers: [
            EmailAuthProvider(),
            GoogleProvider(clientId: '932283109096-lgtvfeiuejnc24d5hkj8k1jmpasn7m79.apps.googleusercontent.com'),
          ],
          showPasswordVisibilityToggle: true,
          footerBuilder: (context, action) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            );
          },
        );
      },
    );
  }
}
