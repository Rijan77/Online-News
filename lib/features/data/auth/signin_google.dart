import 'package:flutter/material.dart';

import '../../../core/common/widgets/custom_dialog.dart';
import '../../presentation/views/home.dart';
import 'google_auth.dart';

class GoogleSignIn {
  final GoogleAuth googleAuth = GoogleAuth();


  Future<void> loginWithGoogle(BuildContext context) async {

    try {
      final user = await googleAuth.loginWithGoogle();

      if (user != null) {
        CustomDialog.showSuccessDialog(
          context: context,
          title: "Welcome Back!",
          message: "You have successfully signed in with Google.",

          onConfirm: () {
            print("User: ${user.user?.displayName}, Email: ${user.user?.email}");
            Navigator.pushReplacement(
              context,

              MaterialPageRoute(builder: (context) => const Home()),
            );

          },
        );
      } else {
        CustomDialog.showSnackBar(
          context: context,
          message: "Login was unsuccessful. Please check your credentials and try again.",
        );
      }
    } catch (e) {
      CustomDialog.showSnackBar(
        context: context,
        message: "Google Login failed. Please try again later.",
      );
    }

  }
}
